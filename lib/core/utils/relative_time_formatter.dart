import 'package:pequelog/l10n/app_localizations.dart';

/// Utility functions for formatting DateTime as relative time strings.
class RelativeTimeFormatter {
  RelativeTimeFormatter._();

  /// Formats a [DateTime] as a relative time string like "Hace 2h 15min" or "Hace 1 día".
  /// 
  /// Returns localized strings based on the provided [localizations].
  static String format(DateTime dateTime, AppLocalizations localizations) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      // Future dates should not happen, but handle gracefully
      return localizations.timelineJustNow;
    }

    // Less than 1 minute
    if (difference.inMinutes < 1) {
      return localizations.timelineJustNow;
    }

    // Less than 1 hour (show minutes)
    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return localizations.timelineMinutesAgo(minutes);
    }

    // Less than 24 hours (show hours and minutes)
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      
      if (minutes == 0) {
        return localizations.timelineHoursAgo(hours);
      }
      return localizations.timelineHoursMinutesAgo(hours, minutes);
    }

    // Less than 7 days (show days)
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return localizations.timelineDaysAgo(days);
    }

    // Less than 30 days (show weeks)
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return localizations.timelineWeeksAgo(weeks);
    }

    // Less than 365 days (show months)
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return localizations.timelineMonthsAgo(months);
    }

    // More than 365 days (show years)
    final years = (difference.inDays / 365).floor();
    return localizations.timelineYearsAgo(years);
  }
}
