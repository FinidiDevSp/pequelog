import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_draft.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';

class _FakeBabyActionRepository implements BabyActionRepository {
  _FakeBabyActionRepository(this._actions);

  final List<BabyAction> _actions;

  @override
  Future<List<BabyAction>> fetchFilteredActions(
    int babyId, {
    List<BabyActionKind>? kinds,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
    int offset = 0,
  }) async {
    return _actions.where((action) {
      if (action.babyId != babyId) {
        return false;
      }
      if (kinds != null && kinds.isNotEmpty && !kinds.contains(action.kind)) {
        return false;
      }
      if (startDate != null && action.occurredAt.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && action.occurredAt.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }

  @override
  Future<BabyAction> logAction(BabyActionDraft draft) {
    throw UnimplementedError();
  }

  @override
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10}) {
    throw UnimplementedError();
  }

  @override
  Future<BabyAction> updateAction({
    required int id,
    required DateTime occurredAt,
    String? notes,
    required Map<String, Object?> details,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAction(int id) {
    throw UnimplementedError();
  }
}

void main() {
  group('StatisticsState', () {
    test('accumulates feed volume stored as double values', () async {
      final now = DateTime.now();
      final repository = _FakeBabyActionRepository([
        BabyAction(
          id: 1,
          babyId: 1,
          kind: BabyActionKind.feed,
          occurredAt: now.subtract(const Duration(hours: 1)),
          notes: null,
          details: const <String, Object?>{'amountMl': 80.5},
        ),
        BabyAction(
          id: 2,
          babyId: 1,
          kind: BabyActionKind.feed,
          occurredAt: now.subtract(const Duration(hours: 3)),
          notes: null,
          details: const <String, Object?>{'amountMl': 95},
        ),
      ]);

      final state = StatisticsState(
        repository: repository,
        babyId: '1',
      );

      await state.reload();

      expect(state.currentPeriodMetrics.feedCount, 2);
      expect(state.currentPeriodMetrics.totalMl, closeTo(175.5, 0.001));
      expect(state.currentPeriodMetrics.averageMl, closeTo(87.75, 0.001));

      expect(state.weeklyData, isNotEmpty);
      expect(state.weeklyData.first.totalMl, closeTo(95, 0.001));
    });
  });
}
