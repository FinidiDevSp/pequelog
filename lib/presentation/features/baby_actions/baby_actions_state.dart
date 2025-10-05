import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/domain/baby_actions/usecases/get_recent_baby_actions.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_bath_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_diaper_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_feed_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_vomit_action.dart';

/// Holds quick actions for the currently selected baby.
class BabyActionsState extends ChangeNotifier {
  /// Creates a state holder backed by the provided use cases.
  BabyActionsState({
    required GetRecentBabyActions getRecentActions,
    required LogFeedAction logFeedAction,
    required LogBathAction logBathAction,
    required LogVomitAction logVomitAction,
    required LogDiaperAction logDiaperAction,
    this.maxRecentActions = 6,
  })  : _getRecentActions = getRecentActions,
        _logFeedAction = logFeedAction,
        _logBathAction = logBathAction,
        _logVomitAction = logVomitAction,
        _logDiaperAction = logDiaperAction;

  final GetRecentBabyActions _getRecentActions;
  final LogFeedAction _logFeedAction;
  final LogBathAction _logBathAction;
  final LogVomitAction _logVomitAction;
  final LogDiaperAction _logDiaperAction;

  /// Maximum amount of actions kept in the in-memory list.
  final int maxRecentActions;

  List<BabyAction> _recentActions = const <BabyAction>[];
  bool _isLoading = false;
  Object? _error;
  int? _babyId;

  /// Recent actions formatted in reverse chronological order.
  List<BabyAction> get recentActions => List<BabyAction>.unmodifiable(_recentActions);

  /// Whether the state is currently fetching from persistence.
  bool get isLoading => _isLoading;

  /// Last error captured while fetching actions.
  Object? get error => _error;

  /// Identifier of the baby whose actions are being tracked.
  int? get babyId => _babyId;

  /// Updates the tracked [babyId] and reloads its actions when necessary.
  void updateBabyId(int? babyId) {
    if (_babyId == babyId) {
      return;
    }
    _babyId = babyId;
    if (babyId == null) {
      _recentActions = const <BabyAction>[];
      notifyListeners();
      return;
    }
    unawaited(_loadRecent());
  }

  /// Forces a refresh of the recent actions for the current baby.
  Future<void> reload() => _loadRecent(force: true);

  /// Logs a feeding action and updates the in-memory list.
  Future<BabyAction> logFeed({
    required DateTime occurredAt,
    required double amountMl,
    String? notes,
    Duration? duration,
  }) async {
    final id = _ensureBabyId();
    final action = await _logFeedAction(
      babyId: id,
      occurredAt: occurredAt,
      amountMl: amountMl,
      notes: notes,
      duration: duration,
    );
    _insertAction(action);
    return action;
  }

  /// Logs a bath action.
  Future<BabyAction> logBath({
    required DateTime occurredAt,
    int? durationMinutes,
    String? notes,
  }) async {
    final id = _ensureBabyId();
    final action = await _logBathAction(
      babyId: id,
      occurredAt: occurredAt,
      durationMinutes: durationMinutes,
      notes: notes,
    );
    _insertAction(action);
    return action;
  }

  /// Logs a vomit event.
  Future<BabyAction> logVomit({
    required DateTime occurredAt,
    required VomitSeverity severity,
    String? notes,
  }) async {
    final id = _ensureBabyId();
    final action = await _logVomitAction(
      babyId: id,
      occurredAt: occurredAt,
      severity: severity,
      notes: notes,
    );
    _insertAction(action);
    return action;
  }

  /// Logs a diaper change with stool.
  Future<BabyAction> logDiaper({
    required DateTime occurredAt,
    required StoolTexture texture,
    bool? hadPee,
    String? notes,
  }) async {
    final id = _ensureBabyId();
    final action = await _logDiaperAction(
      babyId: id,
      occurredAt: occurredAt,
      texture: texture,
      hadPee: hadPee,
      notes: notes,
    );
    _insertAction(action);
    return action;
  }

  int _ensureBabyId() {
    final id = _babyId;
    if (id == null) {
      throw StateError('Cannot log actions without selecting a baby');
    }
    return id;
  }

  Future<void> _loadRecent({bool force = false}) async {
    final id = _babyId;
    if (id == null) {
      _recentActions = const <BabyAction>[];
      _error = null;
      notifyListeners();
      return;
    }
    if (_isLoading && !force) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final actions = await _getRecentActions(id, limit: maxRecentActions);
      _recentActions = actions;
      _error = null;
    } catch (err) {
      _error = err;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _insertAction(BabyAction action) {
    final updated = <BabyAction>[action, ..._recentActions];
    updated.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (updated.length > maxRecentActions) {
      updated.removeRange(maxRecentActions, updated.length);
    }
    _recentActions = List<BabyAction>.unmodifiable(updated);
    _error = null;
    notifyListeners();
  }
}
