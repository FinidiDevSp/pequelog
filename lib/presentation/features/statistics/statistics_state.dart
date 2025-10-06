import 'package:flutter/foundation.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';

/// Data class for daily statistics metrics
class DailyMetrics {
  final int feedCount;
  final int totalMl;
  final double averageMl;
  final int diaperCount;
  final int urineCount;
  final int fecesCount;
  final int bathCount;
  final int vomitCount;
  final Duration? averageInterval;
  final Duration? minInterval;
  final Duration? maxInterval;

  const DailyMetrics({
    required this.feedCount,
    required this.totalMl,
    required this.averageMl,
    required this.diaperCount,
    required this.urineCount,
    required this.fecesCount,
    required this.bathCount,
    required this.vomitCount,
    this.averageInterval,
    this.minInterval,
    this.maxInterval,
  });

  static const empty = DailyMetrics(
    feedCount: 0,
    totalMl: 0,
    averageMl: 0,
    diaperCount: 0,
    urineCount: 0,
    fecesCount: 0,
    bathCount: 0,
    vomitCount: 0,
  );
}

/// Data class for weekly bar chart data
class WeeklyData {
  final DateTime date;
  final int feedCount;
  final int totalMl;
  final String dayLabel; // 'L', 'M', 'X', 'J', 'V', 'S', 'D'

  const WeeklyData({
    required this.date,
    required this.feedCount,
    required this.totalMl,
    required this.dayLabel,
  });
}

/// State management for statistics screen
class StatisticsState extends ChangeNotifier {
  final BabyActionRepository _repository;
  final String babyId;

  bool _isLoading = false;
  DailyMetrics _todayMetrics = DailyMetrics.empty;
  DailyMetrics _yesterdayMetrics = DailyMetrics.empty;
  List<WeeklyData> _weeklyData = [];

  StatisticsState({
    required BabyActionRepository repository,
    required this.babyId,
  })  : _repository = repository {
    _loadStatistics();
  }

  bool get isLoading => _isLoading;
  DailyMetrics get todayMetrics => _todayMetrics;
  DailyMetrics get yesterdayMetrics => _yesterdayMetrics;
  List<WeeklyData> get weeklyData => _weeklyData;

  /// Reload all statistics
  Future<void> reload() async {
    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final yesterdayStart = todayStart.subtract(const Duration(days: 1));
      final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

      // Load today's actions
      final todayActions = await _repository.fetchFilteredActions(
        babyId: babyId,
        startDate: todayStart,
        endDate: now,
      );

      // Load yesterday's actions
      final yesterdayActions = await _repository.fetchFilteredActions(
        babyId: babyId,
        startDate: yesterdayStart,
        endDate: todayStart,
      );

      // Load weekly actions
      final weeklyActions = await _repository.fetchFilteredActions(
        babyId: babyId,
        startDate: weekStart,
        endDate: now,
      );

      _todayMetrics = _calculateMetrics(todayActions);
      _yesterdayMetrics = _calculateMetrics(yesterdayActions);
      _weeklyData = _calculateWeeklyData(weeklyActions, weekStart);
    } catch (e) {
      debugPrint('Error loading statistics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  DailyMetrics _calculateMetrics(List<BabyAction> actions) {
    if (actions.isEmpty) return DailyMetrics.empty;

    int feedCount = 0;
    int totalMl = 0;
    int diaperCount = 0;
    int urineCount = 0;
    int fecesCount = 0;
    int bathCount = 0;
    int vomitCount = 0;

    final feedActions = <BabyAction>[];

    for (final action in actions) {
      switch (action.kind) {
        case BabyActionKind.feed:
          feedCount++;
          feedActions.add(action);
          final amountMl = action.details['amountMl'] as int?;
          if (amountMl != null) {
            totalMl += amountMl;
          }
          break;

        case BabyActionKind.diaper:
          diaperCount++;
          final hasUrine = action.details['hasUrine'] as bool? ?? false;
          final hasFeces = action.details['hasFeces'] as bool? ?? false;
          if (hasUrine) urineCount++;
          if (hasFeces) fecesCount++;
          break;

        case BabyActionKind.bath:
          bathCount++;
          break;

        case BabyActionKind.vomit:
          vomitCount++;
          break;
      }
    }

    final averageMl = feedCount > 0 ? totalMl / feedCount : 0.0;

    // Calculate intervals between feeds
    Duration? averageInterval;
    Duration? minInterval;
    Duration? maxInterval;

    if (feedActions.length >= 2) {
      final intervals = <Duration>[];
      for (int i = 0; i < feedActions.length - 1; i++) {
        final interval = feedActions[i].occurredAt.difference(
          feedActions[i + 1].occurredAt,
        );
        intervals.add(interval);
      }

      if (intervals.isNotEmpty) {
        final totalMinutes = intervals.fold<int>(
          0,
          (sum, interval) => sum + interval.inMinutes,
        );
        averageInterval = Duration(minutes: totalMinutes ~/ intervals.length);
        
        intervals.sort((a, b) => a.inMinutes.compareTo(b.inMinutes));
        minInterval = intervals.first;
        maxInterval = intervals.last;
      }
    }

    return DailyMetrics(
      feedCount: feedCount,
      totalMl: totalMl,
      averageMl: averageMl,
      diaperCount: diaperCount,
      urineCount: urineCount,
      fecesCount: fecesCount,
      bathCount: bathCount,
      vomitCount: vomitCount,
      averageInterval: averageInterval,
      minInterval: minInterval,
      maxInterval: maxInterval,
    );
  }

  List<WeeklyData> _calculateWeeklyData(
    List<BabyAction> actions,
    DateTime weekStart,
  ) {
    final weeklyMap = <DateTime, List<BabyAction>>{};

    // Initialize all 7 days
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      weeklyMap[dateKey] = [];
    }

    // Group actions by day
    for (final action in actions) {
      final dateKey = DateTime(
        action.occurredAt.year,
        action.occurredAt.month,
        action.occurredAt.day,
      );
      weeklyMap[dateKey]?.add(action);
    }

    // Calculate metrics for each day
    final result = <WeeklyData>[];
    final dayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    weeklyMap.forEach((date, dayActions) {
      int feedCount = 0;
      int totalMl = 0;

      for (final action in dayActions) {
        if (action.kind == BabyActionKind.feed) {
          feedCount++;
          final amountMl = action.details['amountMl'] as int?;
          if (amountMl != null) {
            totalMl += amountMl;
          }
        }
      }

      final weekday = date.weekday - 1; // 0-6
      result.add(WeeklyData(
        date: date,
        feedCount: feedCount,
        totalMl: totalMl,
        dayLabel: dayLabels[weekday],
      ));
    });

    // Sort by date
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }
}
