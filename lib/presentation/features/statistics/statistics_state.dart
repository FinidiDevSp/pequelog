import 'package:flutter/foundation.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';

/// Available ranges to filter statistics data.
enum StatisticsRange {
  last7Days,
  last14Days,
  last30Days,
  custom,
}

extension on StatisticsRange {
  int? get daySpan {
    switch (this) {
      case StatisticsRange.last7Days:
        return 7;
      case StatisticsRange.last14Days:
        return 14;
      case StatisticsRange.last30Days:
        return 30;
      case StatisticsRange.custom:
        return null;
    }
  }
}

/// Data class for daily statistics metrics
class DailyMetrics {
  final int feedCount;
  final double totalMl;
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
    totalMl: 0.0,
    averageMl: 0.0,
    diaperCount: 0,
    urineCount: 0,
    fecesCount: 0,
    bathCount: 0,
    vomitCount: 0,
  );
}

/// Data class for time series chart data
class WeeklyData {
  final DateTime date;
  final int feedCount;
  final double totalMl;
  final String dayLabel;

  const WeeklyData({
    required this.date,
    required this.feedCount,
    required this.totalMl,
    required this.dayLabel,
  });
}

class _DateRange {
  const _DateRange({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}

/// State management for statistics screen
class StatisticsState extends ChangeNotifier {
  final BabyActionRepository _repository;
  final String babyId;

  bool _isLoading = false;
  StatisticsRange _selectedRange = StatisticsRange.last7Days;
  DateTime? _customStartDate;
  DailyMetrics _currentPeriodMetrics = DailyMetrics.empty;
  DailyMetrics _previousPeriodMetrics = DailyMetrics.empty;
  List<WeeklyData> _weeklyData = [];
  DateTime _currentRangeStart = DateTime.now();
  DateTime _currentRangeEnd = DateTime.now();
  DateTime? _previousRangeStart;
  DateTime? _previousRangeEnd;

  StatisticsState({
    required BabyActionRepository repository,
    required this.babyId,
  })  : _repository = repository {
    _loadStatistics();
  }

  bool get isLoading => _isLoading;
  StatisticsRange get selectedRange => _selectedRange;
  DateTime? get customStartDate => _customStartDate;
  DailyMetrics get currentPeriodMetrics => _currentPeriodMetrics;
  DailyMetrics get previousPeriodMetrics => _previousPeriodMetrics;
  List<WeeklyData> get weeklyData => _weeklyData;
  DateTime get currentRangeStart => _currentRangeStart;
  DateTime get currentRangeEnd => _currentRangeEnd;
  DateTime? get previousRangeStart => _previousRangeStart;
  DateTime? get previousRangeEnd => _previousRangeEnd;
  bool get hasPreviousPeriod => _previousRangeStart != null;

  /// Reload all statistics
  Future<void> reload() async {
    await _loadStatistics();
  }

  Future<void> updateRange(StatisticsRange range) async {
    if (_selectedRange == range && range != StatisticsRange.custom) {
      return;
    }
    _selectedRange = range;
    if (range != StatisticsRange.custom) {
      _customStartDate = null;
    }
    await _loadStatistics();
  }

  Future<void> updateCustomStartDate(DateTime startDate) async {
    _selectedRange = StatisticsRange.custom;
    _customStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final todayEnd = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );
      final periodStart = _resolvePeriodStart(todayEnd);
      _currentRangeStart = periodStart;
      _currentRangeEnd = todayEnd;

      // Parse babyId to int
      final babyIdInt = int.tryParse(babyId);
      if (babyIdInt == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load actions for the selected period
      final currentActions = await _repository.fetchFilteredActions(
        babyIdInt,
        startDate: periodStart,
        endDate: todayEnd,
      );

      _currentPeriodMetrics = _calculateMetrics(currentActions);

      final previousRange = _resolvePreviousRange(periodStart, todayEnd);
      if (previousRange != null) {
        final previousActions = await _repository.fetchFilteredActions(
          babyIdInt,
          startDate: previousRange.start,
          endDate: previousRange.end,
        );
        _previousPeriodMetrics = _calculateMetrics(previousActions);
        _previousRangeStart = previousRange.start;
        _previousRangeEnd = previousRange.end;
      } else {
        _previousPeriodMetrics = DailyMetrics.empty;
        _previousRangeStart = null;
        _previousRangeEnd = null;
      }

      _weeklyData = _calculateWeeklyData(currentActions, periodStart, todayEnd);
    } catch (e) {
      debugPrint('Error loading statistics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  DateTime _resolvePeriodStart(DateTime todayEnd) {
    final daySpan = _selectedRange.daySpan;
    if (_selectedRange == StatisticsRange.custom && _customStartDate != null) {
      final custom = _customStartDate!;
      final customStart = DateTime(custom.year, custom.month, custom.day);
      if (customStart.isAfter(todayEnd)) {
        return DateTime(todayEnd.year, todayEnd.month, todayEnd.day);
      }
      return customStart;
    }

    final startOfToday = DateTime(todayEnd.year, todayEnd.month, todayEnd.day);
    if (daySpan == null || daySpan <= 1) {
      return startOfToday;
    }
    return startOfToday.subtract(Duration(days: daySpan - 1));
  }

  _DateRange? _resolvePreviousRange(DateTime start, DateTime end) {
    final spanDays = end.difference(start).inDays + 1;
    if (spanDays <= 1) {
      return null;
    }

    final previousPeriodEnd = start.subtract(const Duration(milliseconds: 1));
    final previousPeriodStart = DateTime(
      previousPeriodEnd.year,
      previousPeriodEnd.month,
      previousPeriodEnd.day,
    ).subtract(Duration(days: spanDays - 1));
    return _DateRange(
      start: previousPeriodStart,
      end: previousPeriodEnd,
    );
  }

  DailyMetrics _calculateMetrics(List<BabyAction> actions) {
    if (actions.isEmpty) return DailyMetrics.empty;

    int feedCount = 0;
    double totalMl = 0;
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
          final amountMl = action.details['amountMl'];
          if (amountMl is num) {
            totalMl += amountMl.toDouble();
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
      feedActions.sort(
        (a, b) => a.occurredAt.compareTo(b.occurredAt),
      );
      final intervals = <Duration>[];
      for (int i = 0; i < feedActions.length - 1; i++) {
        final interval = feedActions[i + 1].occurredAt.difference(
          feedActions[i].occurredAt,
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
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    final weeklyMap = <DateTime, List<BabyAction>>{};

    final totalDays = periodEnd.difference(periodStart).inDays;
    for (int i = 0; i <= totalDays; i++) {
      final date = periodStart.add(Duration(days: i));
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

    weeklyMap.forEach((date, dayActions) {
      int feedCount = 0;
      double totalMl = 0;

      for (final action in dayActions) {
        if (action.kind == BabyActionKind.feed) {
          feedCount++;
          final amountMl = action.details['amountMl'];
          if (amountMl is num) {
            totalMl += amountMl.toDouble();
          }
        }
      }

      result.add(WeeklyData(
        date: date,
        feedCount: feedCount,
        totalMl: totalMl,
        dayLabel: '${date.day}/${date.month}',
      ));
    });

    // Sort by date
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }
}
