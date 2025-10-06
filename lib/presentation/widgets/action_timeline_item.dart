import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pequelog/core/utils/relative_time_formatter.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// A single timeline item displaying a baby action with visual timeline elements.
class ActionTimelineItem extends StatefulWidget {
  /// Creates a timeline item for a baby action.
  const ActionTimelineItem({
    required this.action,
    required this.isFirst,
    required this.isLast,
    this.previousAction,
    this.onTap,
    super.key,
  });

  /// The action to display.
  final BabyAction action;

  /// The previous action (chronologically earlier) for showing intervals.
  final BabyAction? previousAction;

  /// Whether this is the first item in the timeline.
  final bool isFirst;

  /// Whether this is the last item in the timeline.
  final bool isLast;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  @override
  State<ActionTimelineItem> createState() => _ActionTimelineItemState();
}

class _ActionTimelineItemState extends State<ActionTimelineItem> {
  Timer? _timer;
  String _relativeTime = '';
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateRelativeTime();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitialized) {
      _updateRelativeTime();
    } else {
      final l10n = AppLocalizations.of(context)!;
      _relativeTime =
          RelativeTimeFormatter.format(widget.action.occurredAt, l10n);
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRelativeTime() {
    if (mounted) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _relativeTime = RelativeTimeFormatter.format(widget.action.occurredAt, l10n);
      });
    }
  }

  String _formatInterval(Duration interval, AppLocalizations l10n) {
    if (interval.inMinutes < 60) {
      return '${interval.inMinutes}min';
    } else if (interval.inHours < 24) {
      final hours = interval.inHours;
      final minutes = interval.inMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h ${minutes}min';
    } else {
      final days = interval.inDays;
      if (days == 1) return '1 día';
      return '$days días';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final action = widget.action;

    final absoluteTime = intl.DateFormat.Hm().format(action.occurredAt);
    final now = DateTime.now();
    final minutesAgo = now.difference(action.occurredAt).inMinutes;
    final isVeryRecent = minutesAgo < 5;

    // Calculate interval to previous action
    Duration? interval;
    if (widget.previousAction != null) {
      interval = action.occurredAt.difference(widget.previousAction!.occurredAt);
    }

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline visual (line + node + interval)
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Top line with interval (hidden for first item)
                  if (!widget.isFirst)
                    SizedBox(
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Dashed line
                          CustomPaint(
                            size: const Size(2, 60),
                            painter: _DashedLinePainter(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          // Interval badge
                          if (interval != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _formatInterval(interval, l10n),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  // Node circle with pulse animation for very recent
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulse animation for very recent actions
                      if (isVeryRecent)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.5),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          onEnd: () {
                            if (mounted) setState(() {});
                          },
                          builder: (context, value, child) {
                            return Container(
                              width: 16 * value,
                              height: 16 * value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary.withOpacity(0.3 / value),
                              ),
                            );
                          },
                        ),
                      // Main node
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getKindColor(colorScheme, action.kind),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getKindIcon(action.kind),
                            size: 8,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Bottom line (hidden for last item)
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time relative label with animation and recent badge
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _relativeTime,
                          key: ValueKey(_relativeTime),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isVeryRecent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 10,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Reciente',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Card with action details
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Absolute time + action type
                          Row(
                            children: [
                              Text(
                                absoluteTime,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getKindLabel(l10n, action.kind),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Details (if any)
                          if (_getActionDetails(l10n, action).isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              _getActionDetails(l10n, action),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          // Notes (if any)
                          if (action.notes != null && action.notes!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              action.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getKindColor(ColorScheme colorScheme, BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return colorScheme.primaryContainer;
      case BabyActionKind.diaper:
        return colorScheme.secondaryContainer;
      case BabyActionKind.bath:
        return colorScheme.tertiaryContainer;
      case BabyActionKind.vomit:
        return colorScheme.errorContainer;
    }
  }

  IconData _getKindIcon(BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return Icons.restaurant;
      case BabyActionKind.diaper:
        return Icons.baby_changing_station;
      case BabyActionKind.bath:
        return Icons.bathtub;
      case BabyActionKind.vomit:
        return Icons.sick;
    }
  }

  String _getKindLabel(AppLocalizations l10n, BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return l10n.historyActionFeed;
      case BabyActionKind.diaper:
        return l10n.historyActionDiaper;
      case BabyActionKind.bath:
        return l10n.historyActionBath;
      case BabyActionKind.vomit:
        return l10n.historyActionVomit;
    }
  }

  String _getActionDetails(AppLocalizations l10n, BabyAction action) {
    final details = action.details;
    final parts = <String>[];

    switch (action.kind) {
      case BabyActionKind.feed:
        if (details['amountMl'] != null) {
          parts.add('${details['amountMl']} ml');
        }
        if (details['durationSeconds'] != null) {
          final duration = Duration(seconds: details['durationSeconds'] as int);
          final minutes = duration.inMinutes;
          if (minutes > 0) {
            parts.add('$minutes min');
          }
        }
        if (details['method'] != null) {
          parts.add(details['method'] as String);
        }
        break;
      case BabyActionKind.diaper:
        if (details['hasUrine'] == true) parts.add('💧 Orina');
        if (details['hasFeces'] == true) parts.add('💩 Heces');
        break;
      case BabyActionKind.bath:
        if (details['durationSeconds'] != null) {
          final duration = Duration(seconds: details['durationSeconds'] as int);
          final minutes = duration.inMinutes;
          if (minutes > 0) {
            parts.add('$minutes min');
          }
        }
        break;
      case BabyActionKind.vomit:
        if (details['severity'] != null) {
          parts.add(details['severity'] as String);
        }
        break;
    }

    return parts.join(' • ');
  }
}

/// Custom painter for dashed vertical line
class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
