// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PequeLog';

  @override
  String get onboardingLogoDescription => 'PequeLog logo';

  @override
  String get onboardingDescription =>
      'Your daily log for little ones. Track feeds, changes, and milestones in seconds.';

  @override
  String get onboardingCta => 'Get started';

  @override
  String get setupSnackMessage => 'Register a baby to begin';

  @override
  String get setupSubtitle => 'Set up the app for your first log.';

  @override
  String get setupConfigure => 'Configure App';

  @override
  String get setupNewBaby => 'New baby';

  @override
  String get newBabyTitle => 'New baby';

  @override
  String get newBabyNameLabel => 'Name';

  @override
  String get newBabyNameError => 'Enter a name';

  @override
  String get newBabyBirthDateLabel => 'Birth date';

  @override
  String get newBabyBirthDateHint => 'Pick it from the calendar';

  @override
  String get newBabyBirthDatePickerHelp => 'Select the birth date';

  @override
  String get newBabyBirthDateError => 'Select the birth date';

  @override
  String get newBabyBirthTimeLabel => 'Birth time';

  @override
  String get newBabyBirthTimeHint => 'Pick the time';

  @override
  String get newBabyBirthTimePickerHelp => 'Select the birth time';

  @override
  String get newBabyBirthTimeError => 'Select the birth time';

  @override
  String get newBabySexLabel => 'Sex';

  @override
  String get newBabySexFemale => 'Girl';

  @override
  String get newBabySexMale => 'Boy';

  @override
  String get newBabySelectSexError => 'Select a sex';

  @override
  String get newBabyLengthLabel => 'Birth length (cm)';

  @override
  String get newBabyLengthError => 'Enter the length';

  @override
  String get newBabyLengthInvalid => 'Enter a valid number';

  @override
  String get newBabyWeightLabel => 'Birth weight (kg)';

  @override
  String get newBabyWeightError => 'Enter the weight';

  @override
  String get newBabyWeightInvalid => 'Enter a valid number';

  @override
  String get newBabyPhotoButtonNoSelection => 'Attach photo (optional)';

  @override
  String get newBabyPhotoButtonSelected => 'Photo selected';

  @override
  String get newBabySave => 'Save baby';

  @override
  String get newBabySaveError => 'Could not save. Try again.';

  @override
  String get babyHomeUpcomingActionTitle => 'Next action';

  @override
  String get babyHomeUpcomingActionDescription =>
      'Soon you\'ll be able to log feeds, naps, and highlights right here.';

  @override
  String get babyHomeBirthSectionTitle => 'Birth';

  @override
  String babyHomeBirthSummary(Object birthDate, Object birthTime) {
    return 'Born on $birthDate at $birthTime';
  }

  @override
  String get babyHomeBirthStatsTitle => 'Birth stats';

  @override
  String babyHomeBirthWeight(Object weight) {
    return 'Weight: $weight kg';
  }

  @override
  String babyHomeBirthLength(Object length) {
    return 'Length: $length cm';
  }

  @override
  String get babyHomePhotoPlaceholder => 'No photo';

  @override
  String get babyHomeActionsTitle => 'Quick actions';

  @override
  String get babyHomeMenuEdit => 'Edit baby';

  @override
  String get babyHomeMenuSettings => 'Settings';

  @override
  String get babyActionFeed => 'Log feed';

  @override
  String get babyActionBath => 'Log bath';

  @override
  String get babyActionVomited => 'Log spit up';

  @override
  String get babyActionDiaper => 'Log diaper';

  @override
  String get babyActionPlaceholderDescription =>
      'You\'ll be able to record this activity very soon.';

  @override
  String get actionDateLabel => 'Date';

  @override
  String get actionDateHint => 'Select the day';

  @override
  String get actionTimeLabel => 'Time';

  @override
  String get actionTimeHint => 'Select the time';

  @override
  String get actionNotesLabel => 'Notes';

  @override
  String get actionNotesHint => 'Add details or observations';

  @override
  String get actionDatePickerHelp => 'Pick the day of the activity';

  @override
  String get actionTimePickerHelp => 'Pick the time of the activity';

  @override
  String get feedMethodLabel => 'Feeding method';

  @override
  String get feedMethodError => 'Select a method';

  @override
  String get feedMethodBreast => 'Breast';

  @override
  String get feedMethodBottle => 'Bottle';

  @override
  String get feedMethodMixed => 'Mixed';

  @override
  String get feedAmountLabel => 'Amount (ml)';

  @override
  String get feedAmountHint => 'Example: 120';

  @override
  String get feedAmountRequired => 'Enter an amount';

  @override
  String get feedAmountError => 'Use a valid amount greater than zero';

  @override
  String get feedActionSubmit => 'Save feed';

  @override
  String get feedActionSuccess => 'Feed saved';

  @override
  String get feedActionError => 'We couldn\'t save the feed. Try again.';

  @override
  String get bathDurationLabel => 'Bath duration';

  @override
  String get bathDurationHint => 'Minutes';

  @override
  String get bathDurationHelper => 'Leave empty if you don\'t want to track it';

  @override
  String get bathDurationError => 'Use whole minutes greater than zero';

  @override
  String get bathActionSubmit => 'Save bath';

  @override
  String get bathActionSuccess => 'Bath saved';

  @override
  String get bathActionError => 'We couldn\'t save the bath. Try again.';

  @override
  String get vomitSeverityLabel => 'Severity';

  @override
  String get vomitSeverityMild => 'Mild';

  @override
  String get vomitSeverityModerate => 'Moderate';

  @override
  String get vomitSeverityIntense => 'Intense';

  @override
  String get vomitActionSubmit => 'Save vomit';

  @override
  String get vomitActionSuccess => 'Vomit saved';

  @override
  String get vomitActionError => 'We couldn\'t save the vomit. Try again.';

  @override
  String get diaperTextureLabel => 'Texture';

  @override
  String get diaperTextureLiquid => 'Liquid';

  @override
  String get diaperTextureSoft => 'Soft';

  @override
  String get diaperTextureSolid => 'Firm';

  @override
  String get diaperPeeLabel => 'Also had pee';

  @override
  String get diaperPeeTag => 'with pee';

  @override
  String get diaperActionSubmit => 'Save diaper';

  @override
  String get diaperActionSuccess => 'Diaper saved';

  @override
  String get diaperActionError => 'We couldn\'t save the diaper. Try again.';

  @override
  String get recentActionsTitle => 'Latest actions';

  @override
  String get recentActionsEmpty =>
      'No actions yet. Use the shortcuts above to start logging.';

  @override
  String recentActionFeed(Object amount, Object method, Object time) {
    return '$time · $method · $amount';
  }

  @override
  String recentActionBath(Object time) {
    return '$time · Bath';
  }

  @override
  String recentActionBathWithDuration(Object duration, Object time) {
    return '$time · Bath of $duration';
  }

  @override
  String recentActionVomit(Object severity, Object time) {
    return '$time · $severity vomit';
  }

  @override
  String recentActionDiaper(Object texture, Object time) {
    return '$time · $texture';
  }

  @override
  String recentActionDiaperWithPee(Object pee, Object texture, Object time) {
    return '$time · $texture · $pee';
  }

  @override
  String recentActionNotes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get editBabyTitle => 'Edit baby';

  @override
  String get editBabySave => 'Save changes';

  @override
  String get configurationTitle => 'Settings';

  @override
  String get configurationPlaceholder =>
      'You will be able to customize the app very soon.';

  @override
  String get configurationLanguageLabel => 'App language';

  @override
  String get configurationLanguageHint => 'Choose your preferred language';

  @override
  String get configurationLanguageSpanish => 'Spanish';

  @override
  String get configurationLanguageEnglish => 'English';

  @override
  String get errorLoadingMessage => 'Oops, something went wrong while loading.';

  @override
  String get retryButton => 'Retry';
}
