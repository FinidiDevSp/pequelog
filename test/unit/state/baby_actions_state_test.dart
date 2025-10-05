import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_draft.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';
import 'package:pequelog/domain/baby_actions/usecases/delete_baby_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/get_recent_baby_actions.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_bath_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_diaper_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_feed_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_vomit_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/update_feed_action.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';

class _InMemoryBabyActionRepository implements BabyActionRepository {
  final List<BabyAction> _actions = <BabyAction>[];
  int _nextId = 1;

  @override
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10}) async {
    final filtered = _actions
        .where((action) => action.babyId == babyId)
        .toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (filtered.length > limit) {
      return filtered.sublist(0, limit);
    }
    return filtered;
  }

  @override
  Future<BabyAction> logAction(BabyActionDraft draft) async {
    final action = BabyAction(
      id: _nextId++,
      babyId: draft.babyId,
      kind: draft.kind,
      occurredAt: draft.occurredAt,
      notes: draft.notes,
      details: draft.details,
    );
    _actions.add(action);
    return action;
  }

  @override
  Future<BabyAction> updateAction({
    required int id,
    required DateTime occurredAt,
    String? notes,
    required Map<String, Object?> details,
  }) async {
    final index = _actions.indexWhere((action) => action.id == id);
    if (index == -1) {
      throw StateError('Missing action with id $id');
    }
    final updated = BabyAction(
      id: id,
      babyId: _actions[index].babyId,
      kind: _actions[index].kind,
      occurredAt: occurredAt,
      notes: notes,
      details: details,
    );
    _actions[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteAction(int id) async {
    _actions.removeWhere((action) => action.id == id);
  }
}

void main() {
  group('BabyActionsState', () {
    test('loads recent actions when baby changes', () async {
      final repository = _InMemoryBabyActionRepository();
      final now = DateTime(2024, 7, 10, 10, 0);
      await repository.logAction(
        BabyActionDraft(
          babyId: 1,
          kind: BabyActionKind.feed,
          occurredAt: now,
          details: const {'method': 'bottle', 'amountMl': 90},
        ),
      );
      final state = BabyActionsState(
        getRecentActions: GetRecentBabyActions(repository: repository),
        logFeedAction: LogFeedAction(repository: repository),
        logBathAction: LogBathAction(repository: repository),
        logVomitAction: LogVomitAction(repository: repository),
        logDiaperAction: LogDiaperAction(repository: repository),
        updateFeedAction: UpdateFeedAction(repository: repository),
        deleteBabyAction: DeleteBabyAction(repository: repository),
      );

      state.updateBabyId(1);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(state.recentActions, hasLength(1));
      expect(state.recentActions.first.kind, BabyActionKind.feed);
    });

    test('logFeed adds a new entry at the start', () async {
      final repository = _InMemoryBabyActionRepository();
      final state = BabyActionsState(
        getRecentActions: GetRecentBabyActions(repository: repository),
        logFeedAction: LogFeedAction(repository: repository),
        logBathAction: LogBathAction(repository: repository),
        logVomitAction: LogVomitAction(repository: repository),
        logDiaperAction: LogDiaperAction(repository: repository),
        updateFeedAction: UpdateFeedAction(repository: repository),
        deleteBabyAction: DeleteBabyAction(repository: repository),
      );

      state.updateBabyId(7);
      await state.reload();

      final now = DateTime(2024, 7, 12, 9, 30);
      await state.logFeed(
        occurredAt: now,
        amountMl: 120,
        duration: const Duration(minutes: 5),
      );

      expect(state.recentActions, hasLength(1));
      expect(state.recentActions.first.details['amountMl'], 120);
      expect(state.recentActions.first.details['durationSeconds'], 300);
    });

    test('updateFeed replaces the existing entry', () async {
      final repository = _InMemoryBabyActionRepository();
      final state = BabyActionsState(
        getRecentActions: GetRecentBabyActions(repository: repository),
        logFeedAction: LogFeedAction(repository: repository),
        logBathAction: LogBathAction(repository: repository),
        logVomitAction: LogVomitAction(repository: repository),
        logDiaperAction: LogDiaperAction(repository: repository),
        updateFeedAction: UpdateFeedAction(repository: repository),
        deleteBabyAction: DeleteBabyAction(repository: repository),
      );

      state.updateBabyId(1);
      final original = await state.logFeed(
        occurredAt: DateTime(2024, 7, 12, 9, 30),
        amountMl: 90,
      );

      final updated = await state.updateFeed(
        actionId: original.id,
        occurredAt: DateTime(2024, 7, 12, 10, 0),
        amountMl: 110,
        duration: const Duration(minutes: 4),
      );

      expect(updated.details['amountMl'], 110);
      expect(state.recentActions.single.id, original.id);
      expect(state.recentActions.single.details['durationSeconds'], 240);
    });

    test('deleteAction removes the entry from the list', () async {
      final repository = _InMemoryBabyActionRepository();
      final state = BabyActionsState(
        getRecentActions: GetRecentBabyActions(repository: repository),
        logFeedAction: LogFeedAction(repository: repository),
        logBathAction: LogBathAction(repository: repository),
        logVomitAction: LogVomitAction(repository: repository),
        logDiaperAction: LogDiaperAction(repository: repository),
        updateFeedAction: UpdateFeedAction(repository: repository),
        deleteBabyAction: DeleteBabyAction(repository: repository),
      );

      state.updateBabyId(3);
      final action = await state.logFeed(
        occurredAt: DateTime(2024, 7, 12, 9, 30),
        amountMl: 120,
      );

      expect(state.recentActions, isNotEmpty);

      await state.deleteAction(action.id);

      expect(state.recentActions, isEmpty);
    });
  });
}
