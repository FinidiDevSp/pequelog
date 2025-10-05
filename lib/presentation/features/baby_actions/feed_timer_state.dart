import 'dart:async';

import 'package:flutter/foundation.dart';

/// Snapshot describing the state of the feeding timer at a given moment.
class FeedTimerSnapshot {
  /// Builds a snapshot with the provided values.
  const FeedTimerSnapshot({
    required this.startedAt,
    required this.elapsed,
    required this.wasRunning,
    required this.babyId,
  });

  /// Moment when the timer was started.
  final DateTime startedAt;

  /// Total elapsed time recorded by the timer.
  final Duration elapsed;

  /// Whether the timer was actively running when captured.
  final bool wasRunning;

  /// Identifier of the baby associated with the timer.
  final int babyId;
}

/// Global controller that keeps the feeding timer alive across screens.
class FeedTimerState extends ChangeNotifier {
  int? _currentBabyId;
  int? _ownerBabyId;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  Timer? _ticker;
  DateTime? _lastTick;

  /// Updates the currently selected baby and clears orphan timers.
  void updateActiveBaby(int? babyId) {
    _currentBabyId = babyId;
    if (_ownerBabyId != null && _ownerBabyId != _currentBabyId) {
      reset();
    } else {
      notifyListeners();
    }
  }

  /// Whether there is a timer allocated to the current baby.
  bool get isVisible =>
      _startedAt != null && _ownerBabyId != null && _ownerBabyId == _currentBabyId;

  /// Whether the timer has been created.
  bool get isActive => _startedAt != null;

  /// Whether the timer is actively counting.
  bool get isRunning => _isRunning;

  /// Baby that owns the timer, if any.
  int? get babyId => _ownerBabyId;

  /// Instant when the timer started.
  DateTime? get startedAt => _startedAt;

  /// Elapsed duration captured by the timer.
  Duration get elapsed => _elapsed;

  /// Starts or restarts the timer for the provided [babyId].
  void start({required int babyId, DateTime? startTime}) {
    final now = DateTime.now();
    _ownerBabyId = babyId;
    _startedAt = startTime ?? now;
    _elapsed = Duration.zero;
    _isRunning = true;
    _lastTick = now;
    _restartTicker();
    notifyListeners();
  }

  /// Pauses the timer while keeping the elapsed value.
  void pause() {
    if (!_isRunning) {
      return;
    }
    _updateElapsed();
    _isRunning = false;
    _lastTick = null;
    notifyListeners();
  }

  /// Resumes the timer from the stored elapsed value.
  void resume() {
    if (_isRunning || _startedAt == null) {
      return;
    }
    _isRunning = true;
    _lastTick = DateTime.now();
    _restartTicker();
    notifyListeners();
  }

  /// Finalizes the timer and clears the state, returning a [FeedTimerSnapshot].
  FeedTimerSnapshot? finish() {
    if (_startedAt == null || _ownerBabyId == null) {
      return null;
    }
    _updateElapsed();
    final snapshot = FeedTimerSnapshot(
      startedAt: _startedAt!,
      elapsed: _elapsed,
      wasRunning: _isRunning,
      babyId: _ownerBabyId!,
    );
    reset();
    return snapshot;
  }

  /// Restores the timer to the provided [snapshot].
  void restore(FeedTimerSnapshot snapshot, {bool resume = false}) {
    _ticker?.cancel();
    _ownerBabyId = snapshot.babyId;
    _startedAt = snapshot.startedAt;
    _elapsed = snapshot.elapsed;
    _isRunning = resume;
    _lastTick = resume ? DateTime.now() : null;
    if (resume) {
      _restartTicker();
    }
    notifyListeners();
  }

  /// Clears any active timer.
  void reset() {
    _ticker?.cancel();
    _ticker = null;
    _startedAt = null;
    _elapsed = Duration.zero;
    _isRunning = false;
    _lastTick = null;
    _ownerBabyId = null;
    notifyListeners();
  }

  void _restartTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    if (!_isRunning) {
      return;
    }
    _updateElapsed();
    notifyListeners();
  }

  void _updateElapsed() {
    final previousTick = _lastTick;
    final now = DateTime.now();
    if (previousTick != null) {
      _elapsed += now.difference(previousTick);
    }
    _lastTick = now;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
