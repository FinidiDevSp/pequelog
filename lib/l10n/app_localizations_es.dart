// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PequeLog';

  @override
  String get onboardingLogoDescription => 'Logotipo de PequeLog';

  @override
  String get onboardingDescription =>
      'Tu bitácora diaria para tus peques. Registra tomas, cambios y momentos clave en segundos.';

  @override
  String get onboardingCta => 'Comenzar';

  @override
  String get setupSnackMessage => 'Registra un bebé para empezar';

  @override
  String get setupSubtitle => 'Prepara la app para tu primer registro.';

  @override
  String get setupConfigure => 'Configurar App';

  @override
  String get setupNewBaby => 'Nuevo bebé';

  @override
  String get newBabyTitle => 'Nuevo bebé';

  @override
  String get newBabyNameLabel => 'Nombre';

  @override
  String get newBabyNameError => 'Introduce un nombre';

  @override
  String get newBabyBirthDateLabel => 'Fecha de nacimiento';

  @override
  String get newBabyBirthDateHint => 'Selecciona en el calendario';

  @override
  String get newBabyBirthDatePickerHelp => 'Selecciona la fecha de nacimiento';

  @override
  String get newBabyBirthDateError => 'Selecciona la fecha de nacimiento';

  @override
  String get newBabyBirthTimeLabel => 'Hora de nacimiento';

  @override
  String get newBabyBirthTimeHint => 'Selecciona la hora';

  @override
  String get newBabyBirthTimePickerHelp => 'Selecciona la hora de nacimiento';

  @override
  String get newBabyBirthTimeError => 'Selecciona la hora de nacimiento';

  @override
  String get newBabySexLabel => 'Sexo';

  @override
  String get newBabySexFemale => 'Niña';

  @override
  String get newBabySexMale => 'Niño';

  @override
  String get newBabySelectSexError => 'Selecciona el sexo';

  @override
  String get newBabyLengthLabel => 'Estatura al nacer (cm)';

  @override
  String get newBabyLengthError => 'Introduce la estatura';

  @override
  String get newBabyLengthInvalid => 'Introduce un número válido';

  @override
  String get newBabyWeightLabel => 'Peso al nacer (kg)';

  @override
  String get newBabyWeightError => 'Introduce el peso';

  @override
  String get newBabyWeightInvalid => 'Introduce un número válido';

  @override
  String get newBabyPhotoButtonNoSelection => 'Adjuntar foto (opcional)';

  @override
  String get newBabyPhotoButtonSelected => 'Foto seleccionada';

  @override
  String get newBabySave => 'Guardar bebé';

  @override
  String get newBabySaveError => 'No se pudo guardar. Intenta de nuevo.';

  @override
  String get babyHomeUpcomingActionTitle => 'Próxima acción';

  @override
  String get babyHomeUpcomingActionDescription =>
      'Muy pronto podrás registrar tomas, siestas y momentos clave aquí mismo.';

  @override
  String get babyHomeBirthSectionTitle => 'Nacimiento';

  @override
  String babyHomeBirthSummary(Object birthDate, Object birthTime) {
    return 'Nació el $birthDate a las $birthTime';
  }

  @override
  String get babyHomeBirthStatsTitle => 'Datos de nacimiento';

  @override
  String babyHomeBirthWeight(Object weight) {
    return 'Peso: $weight kg';
  }

  @override
  String babyHomeBirthLength(Object length) {
    return 'Estatura: $length cm';
  }

  @override
  String get babyHomePhotoPlaceholder => 'Sin foto';

  @override
  String get babyHomeActionsTitle => 'Acciones rápidas';

  @override
  String get babyHomeMenuEdit => 'Editar bebé';

  @override
  String get babyHomeMenuSettings => 'Configuración';

  @override
  String get babyActionFeed => 'Registrar toma';

  @override
  String get babyActionBath => 'Registrar baño';

  @override
  String get babyActionVomited => 'Registrar vómito';

  @override
  String get babyActionDiaper => 'Registrar caca';

  @override
  String get babyActionPlaceholderDescription =>
      'Muy pronto podrás registrar esta actividad con todo detalle.';

  @override
  String get actionDateLabel => 'Fecha';

  @override
  String get actionDateHint => 'Selecciona el día';

  @override
  String get actionTimeLabel => 'Hora';

  @override
  String get actionTimeHint => 'Selecciona la hora';

  @override
  String get actionNotesLabel => 'Notas';

  @override
  String get actionNotesHint => 'Agrega detalles u observaciones';

  @override
  String get actionDatePickerHelp => 'Elige el día de la actividad';

  @override
  String get actionTimePickerHelp => 'Elige la hora de la actividad';

  @override
  String get feedMethodLabel => 'Método de alimentación';

  @override
  String get feedMethodError => 'Selecciona un método';

  @override
  String get feedMethodBreast => 'Pecho';

  @override
  String get feedMethodBottle => 'Biberón';

  @override
  String get feedMethodMixed => 'Mixto';

  @override
  String get feedAmountLabel => 'Cantidad (ml)';

  @override
  String get feedAmountHint => 'Ejemplo: 120';

  @override
  String get feedAmountRequired => 'Ingresa una cantidad';

  @override
  String get feedAmountError => 'Usa una cantidad válida mayor a cero';

  @override
  String get feedActionSubmit => 'Guardar toma';

  @override
  String get feedActionSuccess => 'Toma guardada';

  @override
  String get feedActionError =>
      'No pudimos guardar la toma. Inténtalo de nuevo.';

  @override
  String get bathDurationLabel => 'Duración del baño';

  @override
  String get bathDurationHint => 'Minutos';

  @override
  String get bathDurationHelper => 'Déjalo vacío si no quieres registrarlo';

  @override
  String get bathDurationError => 'Usa minutos enteros mayores a cero';

  @override
  String get bathActionSubmit => 'Guardar baño';

  @override
  String get bathActionSuccess => 'Baño guardado';

  @override
  String get bathActionError =>
      'No pudimos guardar el baño. Inténtalo de nuevo.';

  @override
  String get vomitSeverityLabel => 'Intensidad';

  @override
  String get vomitSeverityMild => 'Leve';

  @override
  String get vomitSeverityModerate => 'Moderada';

  @override
  String get vomitSeverityIntense => 'Intensa';

  @override
  String get vomitActionSubmit => 'Guardar vómito';

  @override
  String get vomitActionSuccess => 'Vómito guardado';

  @override
  String get vomitActionError =>
      'No pudimos guardar el vómito. Inténtalo de nuevo.';

  @override
  String get diaperTextureLabel => 'Textura';

  @override
  String get diaperTextureLiquid => 'Líquida';

  @override
  String get diaperTextureSoft => 'Blanda';

  @override
  String get diaperTextureSolid => 'Firme';

  @override
  String get diaperPeeLabel => 'También hubo pipí';

  @override
  String get diaperPeeTag => 'con pipí';

  @override
  String get diaperActionSubmit => 'Guardar cambio';

  @override
  String get diaperActionSuccess => 'Cambio guardado';

  @override
  String get diaperActionError =>
      'No pudimos guardar el cambio. Inténtalo de nuevo.';

  @override
  String get recentActionsTitle => 'Últimas acciones';

  @override
  String get recentActionsEmpty =>
      'Aún no hay registros. Usa los accesos rápidos para comenzar.';

  @override
  String recentActionFeed(Object amount, Object method, Object time) {
    return '$time · $method · $amount';
  }

  @override
  String recentActionBath(Object time) {
    return '$time · Baño';
  }

  @override
  String recentActionBathWithDuration(Object duration, Object time) {
    return '$time · Baño de $duration';
  }

  @override
  String recentActionVomit(Object severity, Object time) {
    return '$time · Vómito $severity';
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
    return 'Notas: $notes';
  }

  @override
  String get editBabyTitle => 'Editar bebé';

  @override
  String get editBabySave => 'Guardar cambios';

  @override
  String get configurationTitle => 'Configuración';

  @override
  String get configurationPlaceholder =>
      'Aquí podrás personalizar la app muy pronto.';

  @override
  String get configurationLanguageLabel => 'Idioma de la aplicación';

  @override
  String get configurationLanguageHint => 'Selecciona tu idioma preferido';

  @override
  String get configurationLanguageSpanish => 'Español';

  @override
  String get configurationLanguageEnglish => 'Inglés';

  @override
  String get configurationThemeModeLabel => 'Modo de tema';

  @override
  String get configurationThemeModeHint =>
      'Elige cómo se adapta la app a la luz y oscuridad';

  @override
  String get configurationThemeModeSystem => 'Igual que el dispositivo';

  @override
  String get configurationThemeModeLight => 'Siempre claro';

  @override
  String get configurationThemeModeDark => 'Siempre oscuro';

  @override
  String get configurationPaletteLabel => 'Paleta de color';

  @override
  String get configurationPaletteHint =>
      'Elige los tonos suaves que prefieras';

  @override
  String get configurationPaletteDawnBlush => 'Amanecer rosado';

  @override
  String get configurationPaletteMintWhisper => 'Brisa de menta';

  @override
  String get configurationPaletteSkyBreeze => 'Cielo suave';

  @override
  String get configurationPaletteLavenderField => 'Campo de lavanda';

  @override
  String get configurationPalettePreviewTitle => 'Vista previa de la paleta';

  @override
  String get configurationPalettePreviewLightLabel => 'Modo claro';

  @override
  String get configurationPalettePreviewDarkLabel => 'Modo oscuro';

  @override
  String get configurationPalettePreviewMockupLabel =>
      'Vista previa en miniatura';

  @override
  String get errorLoadingMessage => 'Ups, algo salió mal al cargar.';

  @override
  String get retryButton => 'Reintentar';
}
