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
  String get configurationTitle => 'Configuración';

  @override
  String get configurationPlaceholder =>
      'Aquí podrás personalizar la app muy pronto.';

  @override
  String get errorLoadingMessage => 'Ups, algo salió mal al cargar.';

  @override
  String get retryButton => 'Reintentar';
}
