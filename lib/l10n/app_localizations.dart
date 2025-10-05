import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'PequeLog'**
  String get appTitle;

  /// No description provided for @onboardingLogoDescription.
  ///
  /// In es, this message translates to:
  /// **'Logotipo de PequeLog'**
  String get onboardingLogoDescription;

  /// No description provided for @onboardingDescription.
  ///
  /// In es, this message translates to:
  /// **'Tu bitácora diaria para tus peques. Registra tomas, cambios y momentos clave en segundos.'**
  String get onboardingDescription;

  /// No description provided for @onboardingCta.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get onboardingCta;

  /// No description provided for @setupSnackMessage.
  ///
  /// In es, this message translates to:
  /// **'Registra un bebé para empezar'**
  String get setupSnackMessage;

  /// No description provided for @setupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prepara la app para tu primer registro.'**
  String get setupSubtitle;

  /// No description provided for @setupConfigure.
  ///
  /// In es, this message translates to:
  /// **'Configurar App'**
  String get setupConfigure;

  /// No description provided for @setupNewBaby.
  ///
  /// In es, this message translates to:
  /// **'Nuevo bebé'**
  String get setupNewBaby;

  /// No description provided for @newBabyTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo bebé'**
  String get newBabyTitle;

  /// No description provided for @newBabyNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get newBabyNameLabel;

  /// No description provided for @newBabyNameError.
  ///
  /// In es, this message translates to:
  /// **'Introduce un nombre'**
  String get newBabyNameError;

  /// No description provided for @newBabyBirthDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get newBabyBirthDateLabel;

  /// No description provided for @newBabyBirthDateHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona en el calendario'**
  String get newBabyBirthDateHint;

  /// No description provided for @newBabyBirthDatePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de nacimiento'**
  String get newBabyBirthDatePickerHelp;

  /// No description provided for @newBabyBirthDateError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de nacimiento'**
  String get newBabyBirthDateError;

  /// No description provided for @newBabyBirthTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora de nacimiento'**
  String get newBabyBirthTimeLabel;

  /// No description provided for @newBabyBirthTimeHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora'**
  String get newBabyBirthTimeHint;

  /// No description provided for @newBabyBirthTimePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora de nacimiento'**
  String get newBabyBirthTimePickerHelp;

  /// No description provided for @newBabyBirthTimeError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora de nacimiento'**
  String get newBabyBirthTimeError;

  /// No description provided for @newBabySexLabel.
  ///
  /// In es, this message translates to:
  /// **'Sexo'**
  String get newBabySexLabel;

  /// No description provided for @newBabySexFemale.
  ///
  /// In es, this message translates to:
  /// **'Niña'**
  String get newBabySexFemale;

  /// No description provided for @newBabySexMale.
  ///
  /// In es, this message translates to:
  /// **'Niño'**
  String get newBabySexMale;

  /// No description provided for @newBabySelectSexError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el sexo'**
  String get newBabySelectSexError;

  /// No description provided for @newBabyLengthLabel.
  ///
  /// In es, this message translates to:
  /// **'Estatura al nacer (cm)'**
  String get newBabyLengthLabel;

  /// No description provided for @newBabyLengthError.
  ///
  /// In es, this message translates to:
  /// **'Introduce la estatura'**
  String get newBabyLengthError;

  /// No description provided for @newBabyLengthInvalid.
  ///
  /// In es, this message translates to:
  /// **'Introduce un número válido'**
  String get newBabyLengthInvalid;

  /// No description provided for @newBabyWeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Peso al nacer (kg)'**
  String get newBabyWeightLabel;

  /// No description provided for @newBabyWeightError.
  ///
  /// In es, this message translates to:
  /// **'Introduce el peso'**
  String get newBabyWeightError;

  /// No description provided for @newBabyWeightInvalid.
  ///
  /// In es, this message translates to:
  /// **'Introduce un número válido'**
  String get newBabyWeightInvalid;

  /// No description provided for @newBabyPhotoButtonNoSelection.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar foto (opcional)'**
  String get newBabyPhotoButtonNoSelection;

  /// No description provided for @newBabyPhotoButtonSelected.
  ///
  /// In es, this message translates to:
  /// **'Foto seleccionada'**
  String get newBabyPhotoButtonSelected;

  /// No description provided for @newBabySave.
  ///
  /// In es, this message translates to:
  /// **'Guardar bebé'**
  String get newBabySave;

  /// No description provided for @newBabySaveError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar. Intenta de nuevo.'**
  String get newBabySaveError;

  /// No description provided for @babyHomeUpcomingActionTitle.
  ///
  /// In es, this message translates to:
  /// **'Próxima acción'**
  String get babyHomeUpcomingActionTitle;

  /// No description provided for @babyHomeUpcomingActionDescription.
  ///
  /// In es, this message translates to:
  /// **'Muy pronto podrás registrar tomas, siestas y momentos clave aquí mismo.'**
  String get babyHomeUpcomingActionDescription;

  /// No description provided for @babyHomeBirthSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Nacimiento'**
  String get babyHomeBirthSectionTitle;

  /// No description provided for @babyHomeBirthSummary.
  ///
  /// In es, this message translates to:
  /// **'Nació el {birthDate} a las {birthTime}'**
  String babyHomeBirthSummary(Object birthDate, Object birthTime);

  /// No description provided for @configurationTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get configurationTitle;

  /// No description provided for @configurationPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Aquí podrás personalizar la app muy pronto.'**
  String get configurationPlaceholder;

  /// No description provided for @errorLoadingMessage.
  ///
  /// In es, this message translates to:
  /// **'Ups, algo salió mal al cargar.'**
  String get errorLoadingMessage;

  /// No description provided for @retryButton.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retryButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
