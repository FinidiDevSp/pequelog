import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_draft.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/entities/feed_method.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';
import 'package:pequelog/domain/baby_actions/usecases/get_recent_baby_actions.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_bath_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_diaper_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_feed_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_vomit_action.dart';
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
      );

      state.updateBabyId(7);
      await state.reload();

      final now = DateTime(2024, 7, 12, 9, 30);
      await state.logFeed(
        occurredAt: now,
        method: FeedMethod.breast,
        amountMl: 120,
      );

      expect(state.recentActions, hasLength(1));
      expect(state.recentActions.first.details['amountMl'], 120);
      expect(state.recentActions.first.details['method'], 'breast');
    });
  });
}
