import 'package:flutter/foundation.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';

/// Groups actions by their date (ignoring time).
class ActionDayGroup {
  /// Creates a group with a specific date and list of actions.
  ActionDayGroup({
    required this.date,
    required this.actions,
    this.isExpanded = true,
  });

  /// The date (time set to midnight) for this group.
  final DateTime date;

  /// All actions that occurred on this date.
  final List<BabyAction> actions;

  /// Whether this group is currently expanded in the UI.
  bool isExpanded;
}

/// Manages the history screen state including filters, actions, and pagination.
class BabyHistoryState extends ChangeNotifier {
  /// Creates the history state with the given repository.
  BabyHistoryState({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  int? _babyId;
  List<BabyAction> _allActions = [];
  List<ActionDayGroup> _dayGroups = [];
  Set<BabyActionKind> _selectedFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentOffset = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  static const int _pageSize = 100;
  static const int _initialDaysToLoad = 30;

  /// All loaded actions.
  List<BabyAction> get allActions => List.unmodifiable(_allActions);

  /// Actions grouped by day.
  List<ActionDayGroup> get dayGroups => List.unmodifiable(_dayGroups);

  /// Currently selected filter kinds.
  Set<BabyActionKind> get selectedFilters => Set.unmodifiable(_selectedFilters);

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Whether there is more data to load.
  bool get hasMoreData => _hasMoreData;

  /// Whether any filters are active.
  bool get hasActiveFilters => _selectedFilters.isNotEmpty;

  /// Whether there are no actions to display.
  bool get isEmpty => _allActions.isEmpty && !_isLoading;

  /// Updates the active baby and reloads data.
  Future<void> updateBabyId(int? babyId) async {
    if (_babyId == babyId) return;
    _babyId = babyId;
    await reload();
  }

  /// Toggles a filter on/off and reloads data.
  Future<void> toggleFilter(BabyActionKind kind) async {
    if (_selectedFilters.contains(kind)) {
      _selectedFilters.remove(kind);
    } else {
      _selectedFilters.add(kind);
    }
    notifyListeners();
    await reload();
  }

  /// Clears all filters and reloads data.
  Future<void> clearFilters() async {
    _selectedFilters.clear();
    notifyListeners();
    await reload();
  }

  /// Toggles the expanded state of a day group.
  void toggleDayGroup(DateTime date) {
    final group = _dayGroups.firstWhere(
      (g) => g.date == date,
      orElse: () => throw StateError('Day group not found'),
    );
    group.isExpanded = !group.isExpanded;
    notifyListeners();
  }

  /// Reloads all data from scratch.
  Future<void> reload() async {
    _currentOffset = 0;
    _hasMoreData = true;
    _allActions.clear();
    _dayGroups.clear();

    // Calculate start date (30 days ago)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day).subtract(
      const Duration(days: _initialDaysToLoad),
    );
    _endDate = null;

    await _loadMoreActions();
  }

  /// Loads the next page of actions.
  Future<void> loadMore() async {
    if (_isLoading || !_hasMoreData) return;
    await _loadMoreActions();
  }

  Future<void> _loadMoreActions() async {
    if (_babyId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final kinds = _selectedFilters.isEmpty ? null : _selectedFilters.toList();
      final newActions = await _repository.fetchFilteredActions(
        _babyId!,
        kinds: kinds,
        startDate: _startDate,
        endDate: _endDate,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (newActions.isEmpty) {
        _hasMoreData = false;
      } else {
        _allActions.addAll(newActions);
        _currentOffset += newActions.length;
        _rebuildDayGroups();
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _rebuildDayGroups() {
    final groupMap = <DateTime, List<BabyAction>>{};

    for (final action in _allActions) {
      final date = DateTime(
        action.occurredAt.year,
        action.occurredAt.month,
        action.occurredAt.day,
      );
      groupMap.putIfAbsent(date, () => []).add(action);
    }

    // Preserve existing expanded states
    final expandedStates = <DateTime, bool>{};
    for (final group in _dayGroups) {
      expandedStates[group.date] = group.isExpanded;
    }

    _dayGroups = groupMap.entries.map((entry) {
      return ActionDayGroup(
        date: entry.key,
        actions: entry.value,
        isExpanded: expandedStates[entry.key] ?? true,
      );
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }
}
