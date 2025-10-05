import 'package:flutter/foundation.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';

/// Status of the startup flow based on stored babies.
enum BabyStatus { loading, missingBaby, ready, error }

/// Holds the startup state, exposing the selected baby when available.
class BabyState extends ChangeNotifier {
  /// Creates a state manager backed by the provided [BabyRepository].
  BabyState({required this.repository});

  /// Data access gateway for persistent babies.
  final BabyRepository repository;

  BabyStatus _status = BabyStatus.loading;
  Baby? _selectedBaby;
  Object? _error;

  /// Current status of the startup flow.
  BabyStatus get status => _status;

  /// Baby currently selected for the session, if any.
  Baby? get selectedBaby => _selectedBaby;

  /// Last error captured while loading babies.
  Object? get error => _error;

  /// Loads babies from persistence and updates listeners accordingly.
  Future<void> load() async {
    _status = BabyStatus.loading;
    notifyListeners();

    try {
      final babies = await repository.fetchBabies();
      if (babies.isEmpty) {
        _selectedBaby = null;
        _status = BabyStatus.missingBaby;
      } else {
        _selectedBaby = babies.first;
        _status = BabyStatus.ready;
      }
      _error = null;
    } catch (err) {
      _selectedBaby = null;
      _status = BabyStatus.error;
      _error = err;
    }

    notifyListeners();
  }
}
