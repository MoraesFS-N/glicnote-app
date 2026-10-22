// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get register => 'Registrar';

  @override
  String get history => 'Historial';

  @override
  String get profile => 'Perfil';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get tagline => 'Tu cuidado, una medición a la vez.';

  @override
  String get splashFooter => 'Tu seguimiento, siempre cerca.';

  @override
  String get glucoseLevel => 'Tu nivel de glucosa';

  @override
  String get average => 'Promedio de mediciones';

  @override
  String get measurements => 'Mediciones';

  @override
  String get records => 'registros';

  @override
  String get newReading => 'Nueva medición';

  @override
  String get recentReadings => 'Últimas mediciones';

  @override
  String get noReadings => 'No hay mediciones registradas.';

  @override
  String get seeAll => 'Ver todas las mediciones';

  @override
  String get morning => 'Mañana';

  @override
  String get afternoon => 'Tarde';

  @override
  String get night => 'Noche';

  @override
  String get emptyChart => 'Sin mediciones';

  @override
  String get historySubtitle => 'Sigue la evolución de tus mediciones.';

  @override
  String get overview => 'Resumen';

  @override
  String get emptyHistory => 'No se encontraron registros.';

  @override
  String get profileSubtitle => 'Un espacio para tus datos personales.';

  @override
  String get yourProfile => 'Tu perfil';

  @override
  String get profileTagline => 'Tu cuidado comienza contigo.';

  @override
  String get personalDetails => 'Datos personales';

  @override
  String get name => 'Nombre';

  @override
  String get nameError => 'Introduce tu nombre.';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailError => 'Introduce un correo válido.';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil actualizado en esta sesión.';

  @override
  String get contactSaved => 'Contacto actualizado en esta sesión.';

  @override
  String get sessionNotice =>
      'Tus datos se guardan solo en esta sesión y se borran al reiniciar la app.';

  @override
  String get emergencyContact => 'Contacto de emergencia';

  @override
  String get addContact => 'Añadir contacto';

  @override
  String get contactSubtitle => 'Opcional. Añade a alguien de confianza.';

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get contactNameError => 'Introduce el nombre del contacto.';

  @override
  String get phone => 'Teléfono con prefijo';

  @override
  String get phoneHint => '+34 612 345 678';

  @override
  String get phoneError => 'Introduce un teléfono válido con prefijo.';

  @override
  String get relationship => 'Relación (opcional)';

  @override
  String get relationshipHint => 'Ej.: madre, amigo, pareja';

  @override
  String get saveContact => 'Guardar contacto';

  @override
  String get cancel => 'Cancelar';

  @override
  String get readingSubtitle => 'Registra una nueva medición de glucosa.';

  @override
  String get glucoseField => 'Glucosa (mg/dL)';

  @override
  String get valueError => 'Introduce un valor válido.';

  @override
  String get readingMoment => 'Momento de la medición';

  @override
  String get insulinField => 'Insulina utilizada (UI) — opcional';

  @override
  String get insulinHint => 'Ej.: 2,5';

  @override
  String get insulinError => 'Introduce una cantidad válida en UI.';

  @override
  String get saveReading => 'Guardar medición';

  @override
  String get memoryNotice =>
      'En esta versión los datos solo se guardan en memoria.';

  @override
  String get readingSaved => 'Medición añadida en esta sesión.';

  @override
  String get filterDate => 'Filtrar por fecha';

  @override
  String get selectPeriod => 'Selecciona el período';

  @override
  String get apply => 'Aplicar';

  @override
  String get clearPeriod => 'Borrar período';

  @override
  String get moreFilters => 'Más filtros a la derecha';

  @override
  String get iconLabel => 'Icono de GlicNote';

  @override
  String get all => 'Todos';

  @override
  String get fasting => 'En ayunas';

  @override
  String get afterBreakfast => 'Después del desayuno';

  @override
  String get afterLunch => 'Después del almuerzo';

  @override
  String get afterSnack => 'Después de la merienda';

  @override
  String get afterDinner => 'Después de la cena';

  @override
  String get other => 'Otro';

  @override
  String get insulinUnit => 'UI';

  @override
  String lastReading(String date, String time) {
    return 'Última medición: $date a las $time';
  }

  @override
  String readingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String insulinAmount(String amount) {
    return '$amount UI';
  }

  @override
  String get loginTitle => 'Tu cuidado comienza aquí';

  @override
  String get loginSubtitle =>
      'Inicia sesión con tu cuenta Google para acceder a GlicNote.';

  @override
  String get signInWithGoogle => 'Continuar con Google';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get loginError => 'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get accountLoadError =>
      'No se pudo cargar tu cuenta. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get retry => 'Intentar de nuevo';

  @override
  String get noReadingsTitle => 'Tu primera medición';

  @override
  String get noReadingsDescription =>
      'Registra una medición para comenzar tu seguimiento.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get loading => 'Cargando…';

  @override
  String get syncError =>
      'No se pudieron cargar los datos. Pulsa actualizar para reintentar.';

  @override
  String get saveError =>
      'No se pudo guardar. Revisa tu conexión y vuelve a intentarlo.';

  @override
  String get profileSaveError =>
      'No se pudo guardar el perfil. Revisa los datos y la disponibilidad del nombre de usuario.';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameError => 'Usa de 3 a 30 letras minúsculas, números o _.';

  @override
  String get internationalPhoneError =>
      'Incluye el código del país, por ejemplo +34 612 345 678.';

  @override
  String get duplicateReading =>
      'Ya existe una medición para este momento en este día. Revisa el historial antes de registrar otra.';

  @override
  String get duplicateOtherReading =>
      'Ya existe una medición de “Otro” en este instante exacto. Revisa el historial antes de registrar otra.';

  @override
  String get today => 'Hoy';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyVersion => 'Versión preliminar 0.3 • 22/10/2026';

  @override
  String get privacyDraft =>
      'Esta política está en revisión. El canal de contacto, los plazos de conservación y las bases legales deben definirse antes de publicar la versión definitiva.';

  @override
  String get privacyResponsibleTitle => 'Quién es responsable';

  @override
  String get privacyResponsibleBody =>
      'Tech Mow es responsable de GlicNote. El correo para asuntos de privacidad se añadirá a esta política.';

  @override
  String get privacyDataTitle => 'Datos que utilizamos';

  @override
  String get privacyDataBody =>
      'El acceso con Google proporciona identificador, nombre, correo y URL de la foto de perfil. Puedes indicar nombre de usuario, fecha de nacimiento completa y tipo de diabetes (opcionales), mediciones de glucosa, insulina, momento y hora de medición y un contacto de emergencia. El servidor guarda la zona horaria y la fecha local. La información de salud es un dato personal sensible. Facilita datos de terceros, como el contacto de emergencia, con conocimiento de esa persona.';

  @override
  String get privacyPurposeTitle => 'Para qué usamos los datos';

  @override
  String get privacyPurposeBody =>
      'Utilizamos los datos para identificar tu cuenta, mantener tu sesión, organizar el historial, calcular promedios y tu edad y mostrar el perfil y contacto de emergencia. El servicio no accede a tu contraseña de Google, Gmail ni Drive. Esta versión no incluye publicidad ni herramientas de analítica en la app.';

  @override
  String get privacySessionTitle => 'Sesión y foto de perfil';

  @override
  String get privacySessionBody =>
      'La sesión se guarda en el dispositivo para evitar iniciar sesión en cada apertura. Salir elimina la sesión local y conserva los datos del servidor. La foto se carga desde la URL proporcionada por Google; esta petición puede transmitir tu dirección IP e información técnica al servidor de imágenes.';

  @override
  String get privacySharingTitle => 'Privacidad y uso compartido';

  @override
  String get privacySharingBody =>
      'Tu historial y contacto de emergencia son privados. Ninguna medición se publica automáticamente. Las funciones sociales previstas permitirán compartir contenido elegido con personas aprobadas para seguirte; estas pantallas aún no están disponibles en esta versión.';

  @override
  String get privacyProvidersTitle => 'Servicios y almacenamiento';

  @override
  String get privacyProvidersBody =>
      'Google participa en la autenticación y proporciona la foto. Supabase aloja la autenticación y la base de datos; el proyecto actual utiliza una región de Estados Unidos. Render aloja la API de GlicNote. Estos servicios pueden tratar datos en otros países según su configuración y condiciones.';

  @override
  String get privacyRetentionTitle => 'Conservación y seguridad';

  @override
  String get privacyRetentionBody =>
      'Utilizamos autenticación, controles de acceso en la API y conexiones protegidas con la base de datos. Las mediciones permanecen en el servidor al cerrar la app o salir de la cuenta. Tech Mow aún debe definir y documentar plazos de conservación, gestión de copias de seguridad y procedimientos de eliminación. No se puede garantizar una seguridad absoluta.';

  @override
  String get privacyRightsTitle => 'Tus derechos y solicitudes';

  @override
  String get privacyRightsBody =>
      'Puedes solicitar información sobre el uso de tus datos, acceso, corrección y, cuando corresponda, eliminación, portabilidad y retirada del consentimiento. El canal de contacto se indicará aquí. Esta versión no ofrece exportación ni eliminación automática de la cuenta en la app; salir no elimina la cuenta ni las mediciones. Leer esta política o entrar con Google no sustituye el consentimiento específico cuando sea necesario.';

  @override
  String get privacyUpdatesTitle => 'Actualizaciones';

  @override
  String get privacyUpdatesBody =>
      'Esta política se actualizará al evolucionar GlicNote. Los cambios de fines, uso compartido, proveedores, conservación o contacto deben reflejarse aquí y en la versión pública. GlicNote sirve para organización personal y no sustituye la atención profesional de salud.';

  @override
  String get completeRegistration => 'Completa tu perfil';

  @override
  String get additionalDetails => 'Datos complementarios';

  @override
  String get registrationHint =>
      'Nombre de usuario, nacimiento y tipo de diabetes';

  @override
  String get registrationDescription =>
      'Elige tu nombre de usuario y, si quieres, añade tu fecha de nacimiento y tipo de diabetes. Estos datos permanecen en tu perfil privado.';

  @override
  String get googleIdentityHint =>
      'El nombre y correo vienen de tu cuenta de Google y no se pueden editar aquí.';

  @override
  String get birthDate => 'Fecha de nacimiento — opcional';

  @override
  String get birthDateHint =>
      'Se usa para mostrar tu edad y reconocer tu cumpleaños.';

  @override
  String get clearBirthDate => 'Eliminar fecha de nacimiento';

  @override
  String get timeZone => 'Zona horaria';

  @override
  String get timeZoneHint => 'Se completa según tu dispositivo.';

  @override
  String ageYears(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age años',
      one: '1 año',
    );
    return '$_temp0';
  }

  @override
  String get diabetesType => 'Tipo de diabetes';

  @override
  String get diabetesTypeField => 'Tipo de diabetes — opcional';

  @override
  String get diabetesTypeOne => 'Tipo 1';

  @override
  String get diabetesTypeTwo => 'Tipo 2';

  @override
  String get notProvided => 'No informado';
}
