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
  String get babyHomeHighlightsTitle => 'Últimos momentos clave';

  @override
  String get babyHomeHighlightsFeed => 'Último biberón';

  @override
  String get babyHomeHighlightsDiaper => 'Última caca';

  @override
  String get babyHomeHighlightsBath => 'Último baño';

  @override
  String get babyHomeHighlightsVomit => 'Último vómito';

  @override
  String get babyHomeHighlightsNoData => 'Sin registros aún';

  @override
  String babyHomeHighlightsEntry(Object date, Object time, Object elapsed) {
    return '$date a las $time · hace $elapsed';
  }

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
  String get babyActionHistory => 'Historial';

  @override
  String get babyActionStatistics => 'Estadísticas';

  @override
  String get babyActionAskPediatrician => 'Preguntas al pediatra';

  @override
  String get babyActionMedicalAgenda => 'Agenda médica';

  @override
  String get babyActionGrowth => 'Crecimiento';

  @override
  String babyHomeFeatureComingSoon(Object feature) {
    return 'La sección $feature estará disponible pronto.';
  }

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
  String get actionDayPrevious => 'Día anterior';

  @override
  String get actionDayNext => 'Día siguiente';

  @override
  String get actionDayPickerTooltip => 'Elegir día';

  @override
  String get actionDayToday => 'HOY';

  @override
  String get actionDayYesterday => 'AYER';

  @override
  String get feedDaySelectorLabel => 'Día de la toma';

  @override
  String get feedDayPrevious => 'Día anterior';

  @override
  String get feedDayNext => 'Día siguiente';

  @override
  String get feedDayPickerTooltip => 'Elegir día';

  @override
  String get feedTimePickerTooltip => 'Elegir hora';

  @override
  String get feedTimeRequired => 'Indica la hora de la toma';

  @override
  String get feedTimeInvalid => 'Usa el formato HH:MM (24 h)';

  @override
  String get feedTimerTitle => 'Cronómetro';

  @override
  String get feedTimerStart => 'Iniciar toma';

  @override
  String feedTimerRunningLabel(Object elapsed) {
    return 'Tiempo transcurrido: $elapsed';
  }

  @override
  String get feedTimerPause => 'Pausar';

  @override
  String get feedTimerResume => 'Reanudar';

  @override
  String get feedTimerStop => 'Terminar toma';

  @override
  String feedTimerRecordedDuration(Object duration) {
    return 'Duración registrada: $duration';
  }

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
  String get feedActionUpdate => 'Actualizar toma';

  @override
  String get feedActionSuccess => 'Toma guardada';

  @override
  String get feedActionUpdateSuccess => 'Toma actualizada';

  @override
  String get feedActionError =>
      'No pudimos guardar la toma. Inténtalo de nuevo.';

  @override
  String get feedActionEditTitle => 'Editar toma';

  @override
  String get feedTimelineTitle => 'Tomas del día';

  @override
  String get feedTimelineEmpty => 'Aún no registraste tomas en este día.';

  @override
  String feedTimelineGapLabel(Object duration) {
    return '$duration entre tomas';
  }

  @override
  String get feedTimelineGapShort => 'menos de un minuto';

  @override
  String feedTimelineAmountLabel(Object amount) {
    return 'Cantidad: $amount ml';
  }

  @override
  String feedTimelineDurationLabel(Object duration) {
    return 'Duración: $duration';
  }

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
  String get recentActionDeleteLabel => 'Eliminar';

  @override
  String get recentActionEditLabel => 'Editar';

  @override
  String recentActionFeed(Object amount, Object time) {
    return '$time · $amount';
  }

  @override
  String recentActionFeedDuration(Object duration) {
    return 'Duración: $duration';
  }

  @override
  String get recentActionFeedInProgressTitle => 'Toma en curso';

  @override
  String recentActionFeedInProgressSubtitle(Object elapsed) {
    return 'Tiempo transcurrido: $elapsed';
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
  String get recentActionDeleteConfirmTitle => 'Eliminar registro';

  @override
  String get recentActionDeleteConfirmMessage =>
      '¿Seguro que quieres eliminar esta acción?';

  @override
  String get recentActionDeleteConfirmCancel => 'Cancelar';

  @override
  String get recentActionDeleteConfirmAccept => 'Eliminar';

  @override
  String get recentActionDeleteSuccess => 'Registro eliminado';

  @override
  String get recentActionDeleteError =>
      'No pudimos eliminar la acción. Inténtalo de nuevo.';

  @override
  String get recentActionEditUnsupported =>
      'Esta acción todavía no se puede editar.';

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
  String get configurationPaletteHint => 'Elige los tonos suaves que prefieras';

  @override
  String get configurationChangeConfirmation => 'Actualizado';

  @override
  String get configurationImportLegacyButton => 'Importar CSV legado';

  @override
  String get configurationImportLegacyLoading => 'Importando registros...';

  @override
  String get configurationImportNoBaby =>
      'Selecciona un bebé antes de importar.';

  @override
  String get configurationImportEmpty =>
      'No encontramos registros válidos en el archivo.';

  @override
  String configurationImportSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count registros.',
      one: 'Se importó 1 registro.',
      zero: 'No se importaron registros.',
    );
    return '$_temp0';
  }

  @override
  String get configurationImportFailure =>
      'No se pudo importar el archivo. Revisa el formato e inténtalo de nuevo.';

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

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyFilterAll => 'Todos';

  @override
  String get historyFilterFeed => 'Tomas';

  @override
  String get historyFilterDiaper => 'Pañales';

  @override
  String get historyFilterBath => 'Baños';

  @override
  String get historyFilterVomit => 'Vómitos';

  @override
  String get historyEmptyTitle => 'No hay registros';

  @override
  String get historyEmptyMessage => 'Aún no has registrado ninguna acción.';

  @override
  String get historyEmptyFilterMessage =>
      'No hay registros con los filtros seleccionados.';

  @override
  String get historyDayToday => 'HOY';

  @override
  String get historyDayYesterday => 'AYER';

  @override
  String historyDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String get historyLoadingMore => 'Cargando más registros...';

  @override
  String get historyActionFeed => 'Toma';

  @override
  String get historyActionDiaper => 'Pañal';

  @override
  String get historyActionBath => 'Baño';

  @override
  String get historyActionVomit => 'Vómito';

  @override
  String get timelineRecentActions => 'Últimas acciones';

  @override
  String timelineShowCount(int count) {
    return 'Mostrar $count';
  }

  @override
  String get timelineShowAll => 'Ver todas';

  @override
  String get timelineViewFullHistory => 'Ver historial completo';

  @override
  String get timelineNoActions => 'Aún no hay acciones registradas';

  @override
  String timelineTimeAgo(String time) {
    return 'Hace $time';
  }

  @override
  String get timelineJustNow => 'Ahora mismo';

  @override
  String timelineMinutesShort(int count) {
    return '${count}min';
  }

  @override
  String timelineHoursShort(int count) {
    return '${count}h';
  }

  @override
  String timelineDaysShort(int count) {
    return '${count}d';
  }

  @override
  String timelineMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return 'Hace $_temp0';
  }

  @override
  String timelineHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return 'Hace $_temp0';
  }

  @override
  String timelineHoursMinutesAgo(int hours, int minutes) {
    return 'Hace ${hours}h ${minutes}min';
  }

  @override
  String timelineDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return 'Hace $_temp0';
  }

  @override
  String timelineWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
    );
    return 'Hace $_temp0';
  }

  @override
  String timelineMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return 'Hace $_temp0';
  }

  @override
  String timelineYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count años',
      one: '1 año',
    );
    return 'Hace $_temp0';
  }

  @override
  String get statisticsTitle => 'Estadísticas';

  @override
  String get statisticsRefresh => 'Actualizar';

  @override
  String get statisticsDailySummary => 'Resumen del día';

  @override
  String get statisticsPeriodSummary => 'Resumen del periodo';

  @override
  String get statisticsFeedingTitle => 'Alimentación';

  @override
  String statisticsFeedingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomas',
      one: '1 toma',
    );
    return '$_temp0';
  }

  @override
  String get statisticsAverage => 'Promedio';

  @override
  String get statisticsDiapersTitle => 'Pañales';

  @override
  String get statisticsDiapersLabel => 'cambios';

  @override
  String get statisticsFeces => 'cacas';

  @override
  String get statisticsUrine => 'pipís';

  @override
  String get statisticsBathsTitle => 'Baños';

  @override
  String get statisticsBathSingular => 'baño';

  @override
  String get statisticsBathPlural => 'baños';

  @override
  String statisticsVomitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vómitos',
      one: '1 vómito',
    );
    return '$_temp0';
  }

  @override
  String get statisticsIntervalsTitle => 'Intervalos';

  @override
  String get statisticsAverageInterval => 'promedio';

  @override
  String get statisticsRange => 'Rango';

  @override
  String statisticsRangeLabel(String range) {
    return 'Rango seleccionado: $range';
  }

  @override
  String get statisticsRangeLast7Days => 'Últimos 7 días';

  @override
  String get statisticsRangeLast14Days => 'Últimos 14 días';

  @override
  String get statisticsRangeLast30Days => 'Último mes';

  @override
  String get statisticsRangeCustom => 'Personalizado';

  @override
  String get statisticsSelectStartDate => 'Elegir fecha de inicio';

  @override
  String statisticsCustomStartLabel(String date) {
    return 'Desde $date';
  }

  @override
  String get statisticsWeeklyChartTitle => 'Últimos 7 días';

  @override
  String get statisticsTrendChartTitle => 'Tendencia del periodo';

  @override
  String get statisticsVolume => 'Volumen (ml)';

  @override
  String get statisticsFeeds => 'Tomas';

  @override
  String get statisticsComparisonTitle => 'Periodo actual vs anterior';

  @override
  String get statisticsAveragePerFeed => 'Promedio por toma';

  @override
  String get statisticsToday => 'Hoy';

  @override
  String get statisticsYesterday => 'Ayer';

  @override
  String get statisticsCurrentPeriod => 'Periodo actual';

  @override
  String get statisticsPreviousPeriod => 'Periodo anterior';

  @override
  String get statisticsEmptyTitle => 'Aún no hay registros hoy';

  @override
  String get statisticsEmptyMessage =>
      'Comienza registrando la primera acción del día';
}
