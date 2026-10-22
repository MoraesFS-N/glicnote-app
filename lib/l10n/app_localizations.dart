import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get register;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your care, one reading at a time.'**
  String get tagline;

  /// No description provided for @splashFooter.
  ///
  /// In en, this message translates to:
  /// **'Your tracking, always close by.'**
  String get splashFooter;

  /// No description provided for @glucoseLevel.
  ///
  /// In en, this message translates to:
  /// **'Your glucose level'**
  String get glucoseLevel;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average reading'**
  String get average;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get measurements;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'readings'**
  String get records;

  /// No description provided for @newReading.
  ///
  /// In en, this message translates to:
  /// **'New reading'**
  String get newReading;

  /// No description provided for @recentReadings.
  ///
  /// In en, this message translates to:
  /// **'Recent readings'**
  String get recentReadings;

  /// No description provided for @noReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings recorded.'**
  String get noReadings;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'View all readings'**
  String get seeAll;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @emptyChart.
  ///
  /// In en, this message translates to:
  /// **'No readings'**
  String get emptyChart;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your readings over time.'**
  String get historySubtitle;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @emptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No readings found.'**
  String get emptyHistory;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A space for your personal details.'**
  String get profileSubtitle;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @profileTagline.
  ///
  /// In en, this message translates to:
  /// **'Your care starts with you.'**
  String get profileTagline;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameError.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get nameError;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get emailError;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated for this session.'**
  String get profileSaved;

  /// No description provided for @contactSaved.
  ///
  /// In en, this message translates to:
  /// **'Contact updated for this session.'**
  String get contactSaved;

  /// No description provided for @sessionNotice.
  ///
  /// In en, this message translates to:
  /// **'Your data is kept for this session and cleared when the app restarts.'**
  String get sessionNotice;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get emergencyContact;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. Add someone you trust.'**
  String get contactSubtitle;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactName;

  /// No description provided for @contactNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter the contact’s name.'**
  String get contactNameError;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone with area code'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 202 555 0123'**
  String get phoneHint;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number with area code.'**
  String get phoneError;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship (optional)'**
  String get relationship;

  /// No description provided for @relationshipHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. parent, friend, partner'**
  String get relationshipHint;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save contact'**
  String get saveContact;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @readingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record a new blood glucose reading.'**
  String get readingSubtitle;

  /// No description provided for @glucoseField.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose (mg/dL)'**
  String get glucoseField;

  /// No description provided for @valueError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid value.'**
  String get valueError;

  /// No description provided for @readingMoment.
  ///
  /// In en, this message translates to:
  /// **'Reading time'**
  String get readingMoment;

  /// No description provided for @insulinField.
  ///
  /// In en, this message translates to:
  /// **'Insulin used (IU) — optional'**
  String get insulinField;

  /// No description provided for @insulinHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. 2.5'**
  String get insulinHint;

  /// No description provided for @insulinError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount in IU.'**
  String get insulinError;

  /// No description provided for @saveReading.
  ///
  /// In en, this message translates to:
  /// **'Save reading'**
  String get saveReading;

  /// No description provided for @memoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Data is only kept in memory in this version.'**
  String get memoryNotice;

  /// No description provided for @readingSaved.
  ///
  /// In en, this message translates to:
  /// **'Reading added for this session.'**
  String get readingSaved;

  /// No description provided for @filterDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filterDate;

  /// No description provided for @selectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get selectPeriod;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clearPeriod.
  ///
  /// In en, this message translates to:
  /// **'Clear date range'**
  String get clearPeriod;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More filters to the right'**
  String get moreFilters;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'GlicNote icon'**
  String get iconLabel;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @fasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get fasting;

  /// No description provided for @afterBreakfast.
  ///
  /// In en, this message translates to:
  /// **'After breakfast'**
  String get afterBreakfast;

  /// No description provided for @afterLunch.
  ///
  /// In en, this message translates to:
  /// **'After lunch'**
  String get afterLunch;

  /// No description provided for @afterSnack.
  ///
  /// In en, this message translates to:
  /// **'After snack'**
  String get afterSnack;

  /// No description provided for @afterDinner.
  ///
  /// In en, this message translates to:
  /// **'After dinner'**
  String get afterDinner;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @insulinUnit.
  ///
  /// In en, this message translates to:
  /// **'IU'**
  String get insulinUnit;

  /// No description provided for @lastReading.
  ///
  /// In en, this message translates to:
  /// **'Last reading: {date} at {time}'**
  String lastReading(String date, String time);

  /// No description provided for @readingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reading} other{{count} readings}}'**
  String readingCount(int count);

  /// No description provided for @insulinAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} IU'**
  String insulinAmount(String amount);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Your care starts here'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account to access GlicNote.'**
  String get loginSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Please try again.'**
  String get loginError;

  /// No description provided for @accountLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your account. Check your connection and try again.'**
  String get accountLoadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @noReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first reading'**
  String get noReadingsTitle;

  /// No description provided for @noReadingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Record a reading to start tracking your glucose.'**
  String get noReadingsDescription;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your data. Tap refresh to try again.'**
  String get syncError;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Check your connection and try again.'**
  String get saveError;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your profile. Check the details and username availability.'**
  String get profileSaveError;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameError.
  ///
  /// In en, this message translates to:
  /// **'Use 3–30 lowercase letters, numbers or _.'**
  String get usernameError;

  /// No description provided for @internationalPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Include the country code, for example +1 202 555-0123.'**
  String get internationalPhoneError;

  /// No description provided for @duplicateReading.
  ///
  /// In en, this message translates to:
  /// **'A reading already exists for this moment on this day. Check your history before adding another.'**
  String get duplicateReading;

  /// No description provided for @duplicateOtherReading.
  ///
  /// In en, this message translates to:
  /// **'An “Other” reading already exists at this exact time. Check your history before adding another.'**
  String get duplicateOtherReading;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyVersion.
  ///
  /// In en, this message translates to:
  /// **'Draft version 0.3 • October 22, 2026'**
  String get privacyVersion;

  /// No description provided for @privacyDraft.
  ///
  /// In en, this message translates to:
  /// **'This policy is under review. The contact channel, retention periods and legal grounds must be defined before the final version is published.'**
  String get privacyDraft;

  /// No description provided for @privacyResponsibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is responsible'**
  String get privacyResponsibleTitle;

  /// No description provided for @privacyResponsibleBody.
  ///
  /// In en, this message translates to:
  /// **'Tech Mow is responsible for GlicNote. A privacy contact email will be added to this policy.'**
  String get privacyResponsibleBody;

  /// No description provided for @privacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data we use'**
  String get privacyDataTitle;

  /// No description provided for @privacyDataBody.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in provides an identifier, name, email and profile photo URL. You may provide a username, an optional full date of birth and diabetes type, glucose readings, insulin, measurement moment and time, and an emergency contact. The server stores each reading’s time zone and local date. Health information is sensitive personal data. Provide third-party details, such as your emergency contact, with that person’s knowledge.'**
  String get privacyDataBody;

  /// No description provided for @privacyPurposeTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we use data'**
  String get privacyPurposeTitle;

  /// No description provided for @privacyPurposeBody.
  ///
  /// In en, this message translates to:
  /// **'We use data to identify your account, maintain your session, organize your history, calculate averages and your age and display your profile and emergency contact. The service does not access your Google password, Gmail or Drive. This app version includes no advertising or analytics tools.'**
  String get privacyPurposeBody;

  /// No description provided for @privacySessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session and profile photo'**
  String get privacySessionTitle;

  /// No description provided for @privacySessionBody.
  ///
  /// In en, this message translates to:
  /// **'Your session is saved on your device so you do not need to sign in each time. Signing out removes the local session but keeps server data. Your photo loads from the URL supplied by Google; this request may send your IP address and technical information to the image server.'**
  String get privacySessionBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy and sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'Your history and emergency contact are private. Readings are never published automatically. Planned social features let you share selected content with people approved to follow you; these screens are not yet available in this app version.'**
  String get privacySharingBody;

  /// No description provided for @privacyProvidersTitle.
  ///
  /// In en, this message translates to:
  /// **'Services and storage'**
  String get privacyProvidersTitle;

  /// No description provided for @privacyProvidersBody.
  ///
  /// In en, this message translates to:
  /// **'Google provides authentication and the photo. Supabase hosts authentication and the database; the current project uses a region in the United States. Render hosts the GlicNote API. These services may process data in other countries according to their configuration and terms.'**
  String get privacyProvidersBody;

  /// No description provided for @privacyRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Retention and security'**
  String get privacyRetentionTitle;

  /// No description provided for @privacyRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'We use authentication, API access controls and protected database connections. Readings remain on the server after closing the app or signing out. Tech Mow still needs to define and document retention periods, backup handling and deletion procedures. Absolute security cannot be guaranteed.'**
  String get privacyRetentionBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your rights and requests'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You may request information about data use, access, correction and, where applicable, deletion, portability and withdrawal of consent. A contact channel will be listed here. This version has no in-app export or automatic account deletion; signing out does not delete your account or readings. Reading this policy or signing in with Google does not replace specific consent where required.'**
  String get privacyRightsBody;

  /// No description provided for @privacyUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get privacyUpdatesTitle;

  /// No description provided for @privacyUpdatesBody.
  ///
  /// In en, this message translates to:
  /// **'This policy will change as GlicNote evolves. Changes to purposes, sharing, providers, retention or contact details must appear here and in the public version. GlicNote supports personal organization and does not replace professional healthcare.'**
  String get privacyUpdatesBody;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeRegistration;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional details'**
  String get additionalDetails;

  /// No description provided for @registrationHint.
  ///
  /// In en, this message translates to:
  /// **'Username, date of birth and diabetes type'**
  String get registrationHint;

  /// No description provided for @registrationDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your username and optionally add your date of birth and diabetes type. These details stay on your private profile.'**
  String get registrationDescription;

  /// No description provided for @googleIdentityHint.
  ///
  /// In en, this message translates to:
  /// **'Your name and email come from your Google account and cannot be edited here.'**
  String get googleIdentityHint;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth — optional'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In en, this message translates to:
  /// **'Used to show your age and recognize your birthday.'**
  String get birthDateHint;

  /// No description provided for @clearBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Remove date of birth'**
  String get clearBirthDate;

  /// No description provided for @timeZone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get timeZone;

  /// No description provided for @timeZoneHint.
  ///
  /// In en, this message translates to:
  /// **'Filled in according to your device.'**
  String get timeZoneHint;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, =1{1 year old} other{{age} years old}}'**
  String ageYears(int age);

  /// No description provided for @diabetesType.
  ///
  /// In en, this message translates to:
  /// **'Diabetes type'**
  String get diabetesType;

  /// No description provided for @diabetesTypeField.
  ///
  /// In en, this message translates to:
  /// **'Diabetes type — optional'**
  String get diabetesTypeField;

  /// No description provided for @diabetesTypeOne.
  ///
  /// In en, this message translates to:
  /// **'Type 1'**
  String get diabetesTypeOne;

  /// No description provided for @diabetesTypeTwo.
  ///
  /// In en, this message translates to:
  /// **'Type 2'**
  String get diabetesTypeTwo;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

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
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
