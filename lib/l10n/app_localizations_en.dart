// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get register => 'Record';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My profile';

  @override
  String get tagline => 'Your care, one reading at a time.';

  @override
  String get splashFooter => 'Your tracking, always close by.';

  @override
  String get glucoseLevel => 'Your glucose level';

  @override
  String get average => 'Average reading';

  @override
  String get measurements => 'Readings';

  @override
  String get records => 'readings';

  @override
  String get newReading => 'New reading';

  @override
  String get recentReadings => 'Recent readings';

  @override
  String get noReadings => 'No readings recorded.';

  @override
  String get seeAll => 'View all readings';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get night => 'Night';

  @override
  String get emptyChart => 'No readings';

  @override
  String get historySubtitle => 'Track your readings over time.';

  @override
  String get overview => 'Overview';

  @override
  String get emptyHistory => 'No readings found.';

  @override
  String get profileSubtitle => 'A space for your personal details.';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get profileTagline => 'Your care starts with you.';

  @override
  String get personalDetails => 'Personal details';

  @override
  String get name => 'Name';

  @override
  String get nameError => 'Enter your name.';

  @override
  String get email => 'Email';

  @override
  String get emailError => 'Enter a valid email.';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile updated for this session.';

  @override
  String get contactSaved => 'Contact updated for this session.';

  @override
  String get sessionNotice =>
      'Your data is kept for this session and cleared when the app restarts.';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get addContact => 'Add contact';

  @override
  String get contactSubtitle => 'Optional. Add someone you trust.';

  @override
  String get contactName => 'Contact name';

  @override
  String get contactNameError => 'Enter the contact’s name.';

  @override
  String get phone => 'Phone with area code';

  @override
  String get phoneHint => '+1 202 555 0123';

  @override
  String get phoneError => 'Enter a valid phone number with area code.';

  @override
  String get relationship => 'Relationship (optional)';

  @override
  String get relationshipHint => 'E.g. parent, friend, partner';

  @override
  String get saveContact => 'Save contact';

  @override
  String get cancel => 'Cancel';

  @override
  String get readingSubtitle => 'Record a new blood glucose reading.';

  @override
  String get glucoseField => 'Blood glucose (mg/dL)';

  @override
  String get valueError => 'Enter a valid value.';

  @override
  String get readingMoment => 'Reading time';

  @override
  String get insulinField => 'Insulin used (IU) — optional';

  @override
  String get insulinHint => 'E.g. 2.5';

  @override
  String get insulinError => 'Enter a valid amount in IU.';

  @override
  String get saveReading => 'Save reading';

  @override
  String get memoryNotice => 'Data is only kept in memory in this version.';

  @override
  String get readingSaved => 'Reading added for this session.';

  @override
  String get filterDate => 'Filter by date';

  @override
  String get selectPeriod => 'Select a date range';

  @override
  String get apply => 'Apply';

  @override
  String get clearPeriod => 'Clear date range';

  @override
  String get moreFilters => 'More filters to the right';

  @override
  String get iconLabel => 'GlicNote icon';

  @override
  String get all => 'All';

  @override
  String get fasting => 'Fasting';

  @override
  String get afterBreakfast => 'After breakfast';

  @override
  String get afterLunch => 'After lunch';

  @override
  String get afterSnack => 'After snack';

  @override
  String get afterDinner => 'After dinner';

  @override
  String get other => 'Other';

  @override
  String get insulinUnit => 'IU';

  @override
  String lastReading(String date, String time) {
    return 'Last reading: $date at $time';
  }

  @override
  String readingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
    );
    return '$_temp0';
  }

  @override
  String insulinAmount(String amount) {
    return '$amount IU';
  }

  @override
  String get loginTitle => 'Your care starts here';

  @override
  String get loginSubtitle =>
      'Sign in with your Google account to access GlicNote.';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signOut => 'Sign out';

  @override
  String get loginError => 'Unable to sign in. Please try again.';

  @override
  String get accountLoadError =>
      'Unable to load your account. Check your connection and try again.';

  @override
  String get retry => 'Try again';

  @override
  String get noReadingsTitle => 'Your first reading';

  @override
  String get noReadingsDescription =>
      'Record a reading to start tracking your glucose.';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading…';

  @override
  String get syncError => 'Could not load your data. Tap refresh to try again.';

  @override
  String get saveError =>
      'Could not save. Check your connection and try again.';

  @override
  String get profileSaveError =>
      'Could not save your profile. Check the details and username availability.';

  @override
  String get username => 'Username';

  @override
  String get usernameError => 'Use 3–30 lowercase letters, numbers or _.';

  @override
  String get internationalPhoneError =>
      'Include the country code, for example +1 202 555-0123.';

  @override
  String get duplicateReading =>
      'A reading already exists for this moment on this day. Check your history before adding another.';

  @override
  String get duplicateOtherReading =>
      'An “Other” reading already exists at this exact time. Check your history before adding another.';

  @override
  String get today => 'Today';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyVersion => 'Draft version 0.3 • October 22, 2026';

  @override
  String get privacyDraft =>
      'This policy is under review. The contact channel, retention periods and legal grounds must be defined before the final version is published.';

  @override
  String get privacyResponsibleTitle => 'Who is responsible';

  @override
  String get privacyResponsibleBody =>
      'Tech Mow is responsible for GlicNote. A privacy contact email will be added to this policy.';

  @override
  String get privacyDataTitle => 'Data we use';

  @override
  String get privacyDataBody =>
      'Google sign-in provides an identifier, name, email and profile photo URL. You may provide a username, an optional full date of birth and diabetes type, glucose readings, insulin, measurement moment and time, and an emergency contact. The server stores each reading’s time zone and local date. Health information is sensitive personal data. Provide third-party details, such as your emergency contact, with that person’s knowledge.';

  @override
  String get privacyPurposeTitle => 'Why we use data';

  @override
  String get privacyPurposeBody =>
      'We use data to identify your account, maintain your session, organize your history, calculate averages and your age and display your profile and emergency contact. The service does not access your Google password, Gmail or Drive. This app version includes no advertising or analytics tools.';

  @override
  String get privacySessionTitle => 'Session and profile photo';

  @override
  String get privacySessionBody =>
      'Your session is saved on your device so you do not need to sign in each time. Signing out removes the local session but keeps server data. Your photo loads from the URL supplied by Google; this request may send your IP address and technical information to the image server.';

  @override
  String get privacySharingTitle => 'Privacy and sharing';

  @override
  String get privacySharingBody =>
      'Your history and emergency contact are private. Readings are never published automatically. Planned social features let you share selected content with people approved to follow you; these screens are not yet available in this app version.';

  @override
  String get privacyProvidersTitle => 'Services and storage';

  @override
  String get privacyProvidersBody =>
      'Google provides authentication and the photo. Supabase hosts authentication and the database; the current project uses a region in the United States. Render hosts the GlicNote API. These services may process data in other countries according to their configuration and terms.';

  @override
  String get privacyRetentionTitle => 'Retention and security';

  @override
  String get privacyRetentionBody =>
      'We use authentication, API access controls and protected database connections. Readings remain on the server after closing the app or signing out. Tech Mow still needs to define and document retention periods, backup handling and deletion procedures. Absolute security cannot be guaranteed.';

  @override
  String get privacyRightsTitle => 'Your rights and requests';

  @override
  String get privacyRightsBody =>
      'You may request information about data use, access, correction and, where applicable, deletion, portability and withdrawal of consent. A contact channel will be listed here. This version has no in-app export or automatic account deletion; signing out does not delete your account or readings. Reading this policy or signing in with Google does not replace specific consent where required.';

  @override
  String get privacyUpdatesTitle => 'Updates';

  @override
  String get privacyUpdatesBody =>
      'This policy will change as GlicNote evolves. Changes to purposes, sharing, providers, retention or contact details must appear here and in the public version. GlicNote supports personal organization and does not replace professional healthcare.';

  @override
  String get completeRegistration => 'Complete your profile';

  @override
  String get additionalDetails => 'Additional details';

  @override
  String get registrationHint => 'Username, date of birth and diabetes type';

  @override
  String get registrationDescription =>
      'Choose your username and optionally add your date of birth and diabetes type. These details stay on your private profile.';

  @override
  String get googleIdentityHint =>
      'Your name and email come from your Google account and cannot be edited here.';

  @override
  String get birthDate => 'Date of birth — optional';

  @override
  String get birthDateHint =>
      'Used to show your age and recognize your birthday.';

  @override
  String get clearBirthDate => 'Remove date of birth';

  @override
  String get timeZone => 'Time zone';

  @override
  String get timeZoneHint => 'Filled in according to your device.';

  @override
  String ageYears(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years old',
      one: '1 year old',
    );
    return '$_temp0';
  }

  @override
  String get diabetesType => 'Diabetes type';

  @override
  String get diabetesTypeField => 'Diabetes type — optional';

  @override
  String get diabetesTypeOne => 'Type 1';

  @override
  String get diabetesTypeTwo => 'Type 2';

  @override
  String get notProvided => 'Not provided';
}
