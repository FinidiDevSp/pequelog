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
  String get editBabyPlaceholderTitle => 'Edit baby';

  @override
  String get editBabyPlaceholderDescription =>
      'You\'ll be able to update this info soon.';

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
