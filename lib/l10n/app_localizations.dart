import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

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

  /// No description provided for @babyHomeBirthStatsTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos de nacimiento'**
  String get babyHomeBirthStatsTitle;

  /// No description provided for @babyHomeBirthWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso: {weight} kg'**
  String babyHomeBirthWeight(Object weight);

  /// No description provided for @babyHomeBirthLength.
  ///
  /// In es, this message translates to:
  /// **'Estatura: {length} cm'**
  String babyHomeBirthLength(Object length);

  /// No description provided for @babyHomePhotoPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Sin foto'**
  String get babyHomePhotoPlaceholder;

  /// No description provided for @babyHomeActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones rápidas'**
  String get babyHomeActionsTitle;

  /// No description provided for @babyHomeHighlightsTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimos momentos clave'**
  String get babyHomeHighlightsTitle;

  /// No description provided for @babyHomeHighlightsFeed.
  ///
  /// In es, this message translates to:
  /// **'Último biberón'**
  String get babyHomeHighlightsFeed;

  /// No description provided for @babyHomeHighlightsDiaper.
  ///
  /// In es, this message translates to:
  /// **'Última caca'**
  String get babyHomeHighlightsDiaper;

  /// No description provided for @babyHomeHighlightsBath.
  ///
  /// In es, this message translates to:
  /// **'Último baño'**
  String get babyHomeHighlightsBath;

  /// No description provided for @babyHomeHighlightsVomit.
  ///
  /// In es, this message translates to:
  /// **'Último vómito'**
  String get babyHomeHighlightsVomit;

  /// No description provided for @babyHomeHighlightsNoData.
  ///
  /// In es, this message translates to:
  /// **'Sin registros aún'**
  String get babyHomeHighlightsNoData;

  /// No description provided for @babyHomeHighlightsEntry.
  ///
  /// In es, this message translates to:
  /// **'{date} a las {time} · hace {elapsed}'**
  String babyHomeHighlightsEntry(Object date, Object time, Object elapsed);

  /// No description provided for @babyHomeMenuEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar bebé'**
  String get babyHomeMenuEdit;

  /// No description provided for @babyHomeMenuSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get babyHomeMenuSettings;

  /// No description provided for @babyActionFeed.
  ///
  /// In es, this message translates to:
  /// **'Registrar toma'**
  String get babyActionFeed;

  /// No description provided for @babyActionBath.
  ///
  /// In es, this message translates to:
  /// **'Registrar baño'**
  String get babyActionBath;

  /// No description provided for @babyActionVomited.
  ///
  /// In es, this message translates to:
  /// **'Registrar vómito'**
  String get babyActionVomited;

  /// No description provided for @babyActionDiaper.
  ///
  /// In es, this message translates to:
  /// **'Registrar caca'**
  String get babyActionDiaper;

  /// No description provided for @babyActionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get babyActionHistory;

  /// No description provided for @babyActionStatistics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get babyActionStatistics;

  /// No description provided for @babyActionAskPediatrician.
  ///
  /// In es, this message translates to:
  /// **'Preguntas al pediatra'**
  String get babyActionAskPediatrician;

  /// No description provided for @babyActionMedicalAgenda.
  ///
  /// In es, this message translates to:
  /// **'Agenda médica'**
  String get babyActionMedicalAgenda;

  /// No description provided for @babyActionGrowth.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento'**
  String get babyActionGrowth;

  /// No description provided for @babyHomeFeatureComingSoon.
  ///
  /// In es, this message translates to:
  /// **'La sección {feature} estará disponible pronto.'**
  String babyHomeFeatureComingSoon(Object feature);

  /// No description provided for @babyActionPlaceholderDescription.
  ///
  /// In es, this message translates to:
  /// **'Muy pronto podrás registrar esta actividad con todo detalle.'**
  String get babyActionPlaceholderDescription;

  /// No description provided for @actionDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get actionDateLabel;

  /// No description provided for @actionDateHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el día'**
  String get actionDateHint;

  /// No description provided for @actionTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get actionTimeLabel;

  /// No description provided for @actionTimeHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora'**
  String get actionTimeHint;

  /// No description provided for @actionNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get actionNotesLabel;

  /// No description provided for @actionNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Agrega detalles u observaciones'**
  String get actionNotesHint;

  /// No description provided for @actionDatePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Elige el día de la actividad'**
  String get actionDatePickerHelp;

  /// No description provided for @actionTimePickerHelp.
  ///
  /// In es, this message translates to:
  /// **'Elige la hora de la actividad'**
  String get actionTimePickerHelp;

  /// No description provided for @actionDayPrevious.
  ///
  /// In es, this message translates to:
  /// **'Día anterior'**
  String get actionDayPrevious;

  /// No description provided for @actionDayNext.
  ///
  /// In es, this message translates to:
  /// **'Día siguiente'**
  String get actionDayNext;

  /// No description provided for @actionDayPickerTooltip.
  ///
  /// In es, this message translates to:
  /// **'Elegir día'**
  String get actionDayPickerTooltip;

  /// No description provided for @actionDayToday.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get actionDayToday;

  /// No description provided for @actionDayYesterday.
  ///
  /// In es, this message translates to:
  /// **'AYER'**
  String get actionDayYesterday;

  /// No description provided for @feedDaySelectorLabel.
  ///
  /// In es, this message translates to:
  /// **'Día de la toma'**
  String get feedDaySelectorLabel;

  /// No description provided for @feedDayPrevious.
  ///
  /// In es, this message translates to:
  /// **'Día anterior'**
  String get feedDayPrevious;

  /// No description provided for @feedDayNext.
  ///
  /// In es, this message translates to:
  /// **'Día siguiente'**
  String get feedDayNext;

  /// No description provided for @feedDayPickerTooltip.
  ///
  /// In es, this message translates to:
  /// **'Elegir día'**
  String get feedDayPickerTooltip;

  /// No description provided for @feedTimePickerTooltip.
  ///
  /// In es, this message translates to:
  /// **'Elegir hora'**
  String get feedTimePickerTooltip;

  /// No description provided for @feedTimeRequired.
  ///
  /// In es, this message translates to:
  /// **'Indica la hora de la toma'**
  String get feedTimeRequired;

  /// No description provided for @feedTimeInvalid.
  ///
  /// In es, this message translates to:
  /// **'Usa el formato HH:MM (24 h)'**
  String get feedTimeInvalid;

  /// No description provided for @feedTimerTitle.
  ///
  /// In es, this message translates to:
  /// **'Cronómetro'**
  String get feedTimerTitle;

  /// No description provided for @feedTimerStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar toma'**
  String get feedTimerStart;

  /// No description provided for @feedTimerRunningLabel.
  ///
  /// In es, this message translates to:
  /// **'Tiempo transcurrido: {elapsed}'**
  String feedTimerRunningLabel(Object elapsed);

  /// No description provided for @feedTimerPause.
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get feedTimerPause;

  /// No description provided for @feedTimerResume.
  ///
  /// In es, this message translates to:
  /// **'Reanudar'**
  String get feedTimerResume;

  /// No description provided for @feedTimerStop.
  ///
  /// In es, this message translates to:
  /// **'Terminar toma'**
  String get feedTimerStop;

  /// No description provided for @feedTimerRecordedDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración registrada: {duration}'**
  String feedTimerRecordedDuration(Object duration);

  /// No description provided for @feedAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad (ml)'**
  String get feedAmountLabel;

  /// No description provided for @feedAmountHint.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: 120'**
  String get feedAmountHint;

  /// No description provided for @feedAmountRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una cantidad'**
  String get feedAmountRequired;

  /// No description provided for @feedAmountError.
  ///
  /// In es, this message translates to:
  /// **'Usa una cantidad válida mayor a cero'**
  String get feedAmountError;

  /// No description provided for @feedActionSubmit.
  ///
  /// In es, this message translates to:
  /// **'Guardar toma'**
  String get feedActionSubmit;

  /// No description provided for @feedActionUpdate.
  ///
  /// In es, this message translates to:
  /// **'Actualizar toma'**
  String get feedActionUpdate;

  /// No description provided for @feedActionSuccess.
  ///
  /// In es, this message translates to:
  /// **'Toma guardada'**
  String get feedActionSuccess;

  /// No description provided for @feedActionUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Toma actualizada'**
  String get feedActionUpdateSuccess;

  /// No description provided for @feedActionError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar la toma. Inténtalo de nuevo.'**
  String get feedActionError;

  /// No description provided for @feedActionEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar toma'**
  String get feedActionEditTitle;

  /// No description provided for @feedTimelineTitle.
  ///
  /// In es, this message translates to:
  /// **'Tomas del día'**
  String get feedTimelineTitle;

  /// No description provided for @feedTimelineEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no registraste tomas en este día.'**
  String get feedTimelineEmpty;

  /// No description provided for @feedTimelineGapLabel.
  ///
  /// In es, this message translates to:
  /// **'{duration} entre tomas'**
  String feedTimelineGapLabel(Object duration);

  /// No description provided for @feedTimelineGapShort.
  ///
  /// In es, this message translates to:
  /// **'menos de un minuto'**
  String get feedTimelineGapShort;

  /// No description provided for @feedTimelineAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad: {amount} ml'**
  String feedTimelineAmountLabel(Object amount);

  /// No description provided for @feedTimelineDurationLabel.
  ///
  /// In es, this message translates to:
  /// **'Duración: {duration}'**
  String feedTimelineDurationLabel(Object duration);

  /// No description provided for @bathDurationLabel.
  ///
  /// In es, this message translates to:
  /// **'Duración del baño'**
  String get bathDurationLabel;

  /// No description provided for @bathDurationHint.
  ///
  /// In es, this message translates to:
  /// **'Minutos'**
  String get bathDurationHint;

  /// No description provided for @bathDurationHelper.
  ///
  /// In es, this message translates to:
  /// **'Déjalo vacío si no quieres registrarlo'**
  String get bathDurationHelper;

  /// No description provided for @bathDurationError.
  ///
  /// In es, this message translates to:
  /// **'Usa minutos enteros mayores a cero'**
  String get bathDurationError;

  /// No description provided for @bathActionSubmit.
  ///
  /// In es, this message translates to:
  /// **'Guardar baño'**
  String get bathActionSubmit;

  /// No description provided for @bathActionSuccess.
  ///
  /// In es, this message translates to:
  /// **'Baño guardado'**
  String get bathActionSuccess;

  /// No description provided for @bathActionError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el baño. Inténtalo de nuevo.'**
  String get bathActionError;

  /// No description provided for @vomitSeverityLabel.
  ///
  /// In es, this message translates to:
  /// **'Intensidad'**
  String get vomitSeverityLabel;

  /// No description provided for @vomitSeverityMild.
  ///
  /// In es, this message translates to:
  /// **'Leve'**
  String get vomitSeverityMild;

  /// No description provided for @vomitSeverityModerate.
  ///
  /// In es, this message translates to:
  /// **'Moderada'**
  String get vomitSeverityModerate;

  /// No description provided for @vomitSeverityIntense.
  ///
  /// In es, this message translates to:
  /// **'Intensa'**
  String get vomitSeverityIntense;

  /// No description provided for @vomitActionSubmit.
  ///
  /// In es, this message translates to:
  /// **'Guardar vómito'**
  String get vomitActionSubmit;

  /// No description provided for @vomitActionSuccess.
  ///
  /// In es, this message translates to:
  /// **'Vómito guardado'**
  String get vomitActionSuccess;

  /// No description provided for @vomitActionError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el vómito. Inténtalo de nuevo.'**
  String get vomitActionError;

  /// No description provided for @diaperTextureLabel.
  ///
  /// In es, this message translates to:
  /// **'Textura'**
  String get diaperTextureLabel;

  /// No description provided for @diaperTextureLiquid.
  ///
  /// In es, this message translates to:
  /// **'Líquida'**
  String get diaperTextureLiquid;

  /// No description provided for @diaperTextureSoft.
  ///
  /// In es, this message translates to:
  /// **'Blanda'**
  String get diaperTextureSoft;

  /// No description provided for @diaperTextureSolid.
  ///
  /// In es, this message translates to:
  /// **'Firme'**
  String get diaperTextureSolid;

  /// No description provided for @diaperPeeLabel.
  ///
  /// In es, this message translates to:
  /// **'También hubo pipí'**
  String get diaperPeeLabel;

  /// No description provided for @diaperPeeTag.
  ///
  /// In es, this message translates to:
  /// **'con pipí'**
  String get diaperPeeTag;

  /// No description provided for @diaperActionSubmit.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambio'**
  String get diaperActionSubmit;

  /// No description provided for @diaperActionSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cambio guardado'**
  String get diaperActionSuccess;

  /// No description provided for @diaperActionError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el cambio. Inténtalo de nuevo.'**
  String get diaperActionError;

  /// No description provided for @recentActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimas acciones'**
  String get recentActionsTitle;

  /// No description provided for @recentActionsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay registros. Usa los accesos rápidos para comenzar.'**
  String get recentActionsEmpty;

  /// No description provided for @recentActionDeleteLabel.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get recentActionDeleteLabel;

  /// No description provided for @recentActionEditLabel.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get recentActionEditLabel;

  /// No description provided for @recentActionFeed.
  ///
  /// In es, this message translates to:
  /// **'{time} · {amount}'**
  String recentActionFeed(Object amount, Object time);

  /// No description provided for @recentActionFeedDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración: {duration}'**
  String recentActionFeedDuration(Object duration);

  /// No description provided for @recentActionFeedInProgressTitle.
  ///
  /// In es, this message translates to:
  /// **'Toma en curso'**
  String get recentActionFeedInProgressTitle;

  /// No description provided for @recentActionFeedInProgressSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tiempo transcurrido: {elapsed}'**
  String recentActionFeedInProgressSubtitle(Object elapsed);

  /// No description provided for @recentActionBath.
  ///
  /// In es, this message translates to:
  /// **'{time} · Baño'**
  String recentActionBath(Object time);

  /// No description provided for @recentActionBathWithDuration.
  ///
  /// In es, this message translates to:
  /// **'{time} · Baño de {duration}'**
  String recentActionBathWithDuration(Object duration, Object time);

  /// No description provided for @recentActionVomit.
  ///
  /// In es, this message translates to:
  /// **'{time} · Vómito {severity}'**
  String recentActionVomit(Object severity, Object time);

  /// No description provided for @recentActionDiaper.
  ///
  /// In es, this message translates to:
  /// **'{time} · {texture}'**
  String recentActionDiaper(Object texture, Object time);

  /// No description provided for @recentActionDiaperWithPee.
  ///
  /// In es, this message translates to:
  /// **'{time} · {texture} · {pee}'**
  String recentActionDiaperWithPee(Object pee, Object texture, Object time);

  /// No description provided for @recentActionNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas: {notes}'**
  String recentActionNotes(Object notes);

  /// No description provided for @recentActionDeleteConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar registro'**
  String get recentActionDeleteConfirmTitle;

  /// No description provided for @recentActionDeleteConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar esta acción?'**
  String get recentActionDeleteConfirmMessage;

  /// No description provided for @recentActionDeleteConfirmCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get recentActionDeleteConfirmCancel;

  /// No description provided for @recentActionDeleteConfirmAccept.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get recentActionDeleteConfirmAccept;

  /// No description provided for @recentActionDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get recentActionDeleteSuccess;

  /// No description provided for @recentActionDeleteError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos eliminar la acción. Inténtalo de nuevo.'**
  String get recentActionDeleteError;

  /// No description provided for @recentActionEditUnsupported.
  ///
  /// In es, this message translates to:
  /// **'Esta acción todavía no se puede editar.'**
  String get recentActionEditUnsupported;

  /// No description provided for @editBabyTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar bebé'**
  String get editBabyTitle;

  /// No description provided for @editBabySave.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get editBabySave;

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

  /// No description provided for @configurationLanguageLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma de la aplicación'**
  String get configurationLanguageLabel;

  /// No description provided for @configurationLanguageHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu idioma preferido'**
  String get configurationLanguageHint;

  /// No description provided for @configurationLanguageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get configurationLanguageSpanish;

  /// No description provided for @configurationLanguageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get configurationLanguageEnglish;

  /// No description provided for @configurationThemeModeLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo de tema'**
  String get configurationThemeModeLabel;

  /// No description provided for @configurationThemeModeHint.
  ///
  /// In es, this message translates to:
  /// **'Elige cómo se adapta la app a la luz y oscuridad'**
  String get configurationThemeModeHint;

  /// No description provided for @configurationThemeModeSystem.
  ///
  /// In es, this message translates to:
  /// **'Igual que el dispositivo'**
  String get configurationThemeModeSystem;

  /// No description provided for @configurationThemeModeLight.
  ///
  /// In es, this message translates to:
  /// **'Siempre claro'**
  String get configurationThemeModeLight;

  /// No description provided for @configurationThemeModeDark.
  ///
  /// In es, this message translates to:
  /// **'Siempre oscuro'**
  String get configurationThemeModeDark;

  /// No description provided for @configurationPaletteLabel.
  ///
  /// In es, this message translates to:
  /// **'Paleta de color'**
  String get configurationPaletteLabel;

  /// No description provided for @configurationPaletteHint.
  ///
  /// In es, this message translates to:
  /// **'Elige los tonos suaves que prefieras'**
  String get configurationPaletteHint;

  /// No description provided for @configurationPaletteDawnBlush.
  ///
  /// In es, this message translates to:
  /// **'Amanecer rosado'**
  String get configurationPaletteDawnBlush;

  /// No description provided for @configurationPaletteMintWhisper.
  ///
  /// In es, this message translates to:
  /// **'Brisa de menta'**
  String get configurationPaletteMintWhisper;

  /// No description provided for @configurationPaletteSkyBreeze.
  ///
  /// In es, this message translates to:
  /// **'Cielo suave'**
  String get configurationPaletteSkyBreeze;

  /// No description provided for @configurationPaletteLavenderField.
  ///
  /// In es, this message translates to:
  /// **'Campo de lavanda'**
  String get configurationPaletteLavenderField;

  /// No description provided for @configurationPalettePreviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Vista previa de la paleta'**
  String get configurationPalettePreviewTitle;

  /// No description provided for @configurationPalettePreviewLightLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo claro'**
  String get configurationPalettePreviewLightLabel;

  /// No description provided for @configurationPalettePreviewDarkLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get configurationPalettePreviewDarkLabel;

  /// No description provided for @configurationPalettePreviewMockupLabel.
  ///
  /// In es, this message translates to:
  /// **'Vista previa en miniatura'**
  String get configurationPalettePreviewMockupLabel;

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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
