import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('fr'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Chahriyti'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @resetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting...'**
  String get resetting;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterNumber;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50000'**
  String get amountHint;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @importantWarning.
  ///
  /// In en, this message translates to:
  /// **'Important Warning'**
  String get importantWarning;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneDesc.
  ///
  /// In en, this message translates to:
  /// **'These actions cannot be undone. Make sure before continuing.'**
  String get dangerZoneDesc;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Before you increase your salary, know where it goes.'**
  String get splashTagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @valuePropTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits of Chahriyti'**
  String get valuePropTitle;

  /// No description provided for @valuePropSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What will you gain from Chahriyti?'**
  String get valuePropSubtitle;

  /// No description provided for @benefit1.
  ///
  /// In en, this message translates to:
  /// **'Track your daily expenses easily'**
  String get benefit1;

  /// No description provided for @benefit2.
  ///
  /// In en, this message translates to:
  /// **'Know your balance at any moment'**
  String get benefit2;

  /// No description provided for @benefit3.
  ///
  /// In en, this message translates to:
  /// **'Calculate the safe amount to spend daily'**
  String get benefit3;

  /// No description provided for @benefit4.
  ///
  /// In en, this message translates to:
  /// **'Smart statistics on your financial habits'**
  String get benefit4;

  /// No description provided for @benefit5.
  ///
  /// In en, this message translates to:
  /// **'Weekly challenges to save more'**
  String get benefit5;

  /// No description provided for @benefit6.
  ///
  /// In en, this message translates to:
  /// **'Manage your debts and savings goals'**
  String get benefit6;

  /// No description provided for @benefit7.
  ///
  /// In en, this message translates to:
  /// **'Smart alerts before your balance runs out'**
  String get benefit7;

  /// No description provided for @valuePropQuote.
  ///
  /// In en, this message translates to:
  /// **'\"Money you don\'t manage, manages you\"'**
  String get valuePropQuote;

  /// No description provided for @financialSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Financial Situation'**
  String get financialSetupTitle;

  /// No description provided for @financialSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Takes only 2 minutes.\nYou can edit it anytime later.'**
  String get financialSetupSubtitle;

  /// No description provided for @balanceStepTitle.
  ///
  /// In en, this message translates to:
  /// **'How much money do you have now?'**
  String get balanceStepTitle;

  /// No description provided for @balanceStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your bank account, wallet, and cash.'**
  String get balanceStepDesc;

  /// No description provided for @balanceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your balance'**
  String get balanceRequired;

  /// No description provided for @savingsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Money saved for the future?'**
  String get savingsStepTitle;

  /// No description provided for @savingsStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Emergency fund, savings goals, or any side amount.'**
  String get savingsStepDesc;

  /// No description provided for @debtsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Who do you owe money to?'**
  String get debtsStepTitle;

  /// No description provided for @debtsStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Bank loans, personal debts, or any amount you owe.'**
  String get debtsStepDesc;

  /// No description provided for @lendingsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Who owes you money?'**
  String get lendingsStepTitle;

  /// No description provided for @lendingsStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Amounts you lent to friends or family.'**
  String get lendingsStepDesc;

  /// No description provided for @summaryStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Financial Summary'**
  String get summaryStepTitle;

  /// No description provided for @summaryStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Review your data before confirming.'**
  String get summaryStepDesc;

  /// No description provided for @noDebts.
  ///
  /// In en, this message translates to:
  /// **'No debts'**
  String get noDebts;

  /// No description provided for @noLendings.
  ///
  /// In en, this message translates to:
  /// **'No lendings'**
  String get noLendings;

  /// No description provided for @addFirstDebt.
  ///
  /// In en, this message translates to:
  /// **'Add first debt'**
  String get addFirstDebt;

  /// No description provided for @addAnotherDebt.
  ///
  /// In en, this message translates to:
  /// **'Add another debt'**
  String get addAnotherDebt;

  /// No description provided for @addFirstLending.
  ///
  /// In en, this message translates to:
  /// **'Add first lending'**
  String get addFirstLending;

  /// No description provided for @addAnotherLending.
  ///
  /// In en, this message translates to:
  /// **'Add another lending'**
  String get addAnotherLending;

  /// No description provided for @confirmAndStart.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Start Using'**
  String get confirmAndStart;

  /// No description provided for @balanceSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceSummaryLabel;

  /// No description provided for @savingsSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savingsSummaryLabel;

  /// No description provided for @debtsSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsSummaryLabel;

  /// No description provided for @lendingsSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Lendings'**
  String get lendingsSummaryLabel;

  /// No description provided for @salarySplitSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary Savings'**
  String get salarySplitSummaryLabel;

  /// No description provided for @noSalarySplit.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noSalarySplit;

  /// No description provided for @inBalance.
  ///
  /// In en, this message translates to:
  /// **'in balance'**
  String get inBalance;

  /// No description provided for @activationTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate App'**
  String get activationTitle;

  /// No description provided for @editData.
  ///
  /// In en, this message translates to:
  /// **'Edit Data'**
  String get editData;

  /// No description provided for @chahriytiNumber.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti Number'**
  String get chahriytiNumber;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your Data'**
  String get yourData;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @wilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get wilaya;

  /// No description provided for @haveActivationKey.
  ///
  /// In en, this message translates to:
  /// **'Do you have an activation key?'**
  String get haveActivationKey;

  /// No description provided for @activationKeyDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code or enter the key manually to activate the app.'**
  String get activationKeyDesc;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @enterKeyManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Key Manually'**
  String get enterKeyManually;

  /// No description provided for @copiedChahriytiNumber.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti number copied'**
  String get copiedChahriytiNumber;

  /// No description provided for @scanQrForLicense.
  ///
  /// In en, this message translates to:
  /// **'Scan QR for license'**
  String get scanQrForLicense;

  /// No description provided for @scanQrHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code on the license card.'**
  String get scanQrHint;

  /// No description provided for @licenseAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'This license is used on another device'**
  String get licenseAlreadyUsed;

  /// No description provided for @cannotOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Could not open page'**
  String get cannotOpenPage;

  /// No description provided for @getChahriyti.
  ///
  /// In en, this message translates to:
  /// **'Get Chahriyti'**
  String get getChahriyti;

  /// No description provided for @buyBookLink.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti Book + Lifetime activation code '**
  String get buyBookLink;

  /// No description provided for @buyBookLinkHere.
  ///
  /// In en, this message translates to:
  /// **'here'**
  String get buyBookLinkHere;

  /// No description provided for @enterActivationKey.
  ///
  /// In en, this message translates to:
  /// **'Enter Activation Key'**
  String get enterActivationKey;

  /// No description provided for @keyRequired.
  ///
  /// In en, this message translates to:
  /// **'Key is required'**
  String get keyRequired;

  /// No description provided for @keyIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Key is incomplete'**
  String get keyIncomplete;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseTitle;

  /// No description provided for @selectExpenseType.
  ///
  /// In en, this message translates to:
  /// **'Select expense type'**
  String get selectExpenseType;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @whatDidYouBuy.
  ///
  /// In en, this message translates to:
  /// **'What did you buy?'**
  String get whatDidYouBuy;

  /// No description provided for @buyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. bread, chicken, drinks...'**
  String get buyHint;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Any additional details...'**
  String get additionalDetails;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price'**
  String get priceRequired;

  /// No description provided for @pricePositive.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than zero'**
  String get pricePositive;

  /// No description provided for @insufficientSavings.
  ///
  /// In en, this message translates to:
  /// **'Insufficient savings balance'**
  String get insufficientSavings;

  /// No description provided for @insufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance and savings'**
  String get insufficientFunds;

  /// No description provided for @spend.
  ///
  /// In en, this message translates to:
  /// **'Spend'**
  String get spend;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @expenseHistory.
  ///
  /// In en, this message translates to:
  /// **'Expense History'**
  String get expenseHistory;

  /// No description provided for @newDebt.
  ///
  /// In en, this message translates to:
  /// **'New Debt'**
  String get newDebt;

  /// No description provided for @editDebt.
  ///
  /// In en, this message translates to:
  /// **'Edit Debt'**
  String get editDebt;

  /// No description provided for @creditorName.
  ///
  /// In en, this message translates to:
  /// **'Creditor Name'**
  String get creditorName;

  /// No description provided for @creditorNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mohammed Ahmed'**
  String get creditorNameHint;

  /// No description provided for @creditorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Creditor name is required'**
  String get creditorNameRequired;

  /// No description provided for @totalDebtAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Debt Amount'**
  String get totalDebtAmount;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @addDebtNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about the debt...'**
  String get addDebtNoteHint;

  /// No description provided for @saveDebt.
  ///
  /// In en, this message translates to:
  /// **'Save Debt'**
  String get saveDebt;

  /// No description provided for @saveEdit.
  ///
  /// In en, this message translates to:
  /// **'Save Edit'**
  String get saveEdit;

  /// No description provided for @debtCreated.
  ///
  /// In en, this message translates to:
  /// **'Debt created successfully'**
  String get debtCreated;

  /// No description provided for @debtUpdated.
  ///
  /// In en, this message translates to:
  /// **'Debt updated successfully'**
  String get debtUpdated;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get newGoal;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal'**
  String get editGoal;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal Name'**
  String get goalName;

  /// No description provided for @goalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Buy a phone'**
  String get goalNameHint;

  /// No description provided for @goalNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get goalNameRequired;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @goalDescOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get goalDescOptional;

  /// No description provided for @goalDescHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes...'**
  String get goalDescHint;

  /// No description provided for @saveGoal.
  ///
  /// In en, this message translates to:
  /// **'Save Goal'**
  String get saveGoal;

  /// No description provided for @goalCreated.
  ///
  /// In en, this message translates to:
  /// **'Goal created successfully'**
  String get goalCreated;

  /// No description provided for @goalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated successfully'**
  String get goalUpdated;

  /// No description provided for @newLending.
  ///
  /// In en, this message translates to:
  /// **'New Lending'**
  String get newLending;

  /// No description provided for @editLending.
  ///
  /// In en, this message translates to:
  /// **'Edit Lending'**
  String get editLending;

  /// No description provided for @borrowerName.
  ///
  /// In en, this message translates to:
  /// **'Borrower Name'**
  String get borrowerName;

  /// No description provided for @borrowerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ahmed'**
  String get borrowerNameHint;

  /// No description provided for @borrowerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Borrower name is required'**
  String get borrowerNameRequired;

  /// No description provided for @lendingAmount.
  ///
  /// In en, this message translates to:
  /// **'Lending Amount'**
  String get lendingAmount;

  /// No description provided for @addLendingNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about the lending...'**
  String get addLendingNoteHint;

  /// No description provided for @saveLending.
  ///
  /// In en, this message translates to:
  /// **'Register Lending'**
  String get saveLending;

  /// No description provided for @lendingCreated.
  ///
  /// In en, this message translates to:
  /// **'Lending registered successfully'**
  String get lendingCreated;

  /// No description provided for @lendingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Lending updated successfully'**
  String get lendingUpdated;

  /// No description provided for @savingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savingsTitle;

  /// No description provided for @withdrawToBalance.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to Balance'**
  String get withdrawToBalance;

  /// No description provided for @depositFromBalance.
  ///
  /// In en, this message translates to:
  /// **'Deposit from Balance'**
  String get depositFromBalance;

  /// No description provided for @totalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings'**
  String get totalSavings;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noSavingsYet.
  ///
  /// In en, this message translates to:
  /// **'No savings transactions yet'**
  String get noSavingsYet;

  /// No description provided for @savingsAutoHint.
  ///
  /// In en, this message translates to:
  /// **'Savings will be added automatically at the end of the financial cycle.'**
  String get savingsAutoHint;

  /// No description provided for @depositToSavings.
  ///
  /// In en, this message translates to:
  /// **'Deposit to Savings'**
  String get depositToSavings;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @availableSavings.
  ///
  /// In en, this message translates to:
  /// **'Available Savings'**
  String get availableSavings;

  /// No description provided for @confirmDeposit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deposit'**
  String get confirmDeposit;

  /// No description provided for @confirmWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Confirm Withdrawal'**
  String get confirmWithdrawal;

  /// No description provided for @amountExceedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds available'**
  String get amountExceedsAvailable;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @dataClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data cleared successfully'**
  String get dataClearedSuccess;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @notActivated.
  ///
  /// In en, this message translates to:
  /// **'Not Activated'**
  String get notActivated;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary'**
  String get monthlySalary;

  /// No description provided for @fromNextCycle.
  ///
  /// In en, this message translates to:
  /// **'From next cycle'**
  String get fromNextCycle;

  /// No description provided for @salaryDay.
  ///
  /// In en, this message translates to:
  /// **'Salary Day'**
  String get salaryDay;

  /// No description provided for @dayN.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayN(int day);

  /// No description provided for @goalsAndDebts.
  ///
  /// In en, this message translates to:
  /// **'Goals & Debts'**
  String get goalsAndDebts;

  /// No description provided for @goalsAndDebtsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your financial goals and debts'**
  String get goalsAndDebtsDesc;

  /// No description provided for @viewGoals.
  ///
  /// In en, this message translates to:
  /// **'View Goals'**
  String get viewGoals;

  /// No description provided for @viewDebts.
  ///
  /// In en, this message translates to:
  /// **'View Debts'**
  String get viewDebts;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @manageCycle.
  ///
  /// In en, this message translates to:
  /// **'Manage Financial Cycle'**
  String get manageCycle;

  /// No description provided for @manageCycleDesc.
  ///
  /// In en, this message translates to:
  /// **'Cycle starts automatically on your salary day each month.'**
  String get manageCycleDesc;

  /// No description provided for @cycleHistory.
  ///
  /// In en, this message translates to:
  /// **'Cycle History'**
  String get cycleHistory;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti - Version 1.0.0'**
  String get appVersion;

  /// No description provided for @yesDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete everything'**
  String get yesDeleteEverything;

  /// No description provided for @editSalaryDay.
  ///
  /// In en, this message translates to:
  /// **'Edit Salary Day'**
  String get editSalaryDay;

  /// No description provided for @chooseDayHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a day from 1 to 28'**
  String get chooseDayHint;

  /// No description provided for @selectedDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected day: {day} of each month'**
  String selectedDayLabel(int day);

  /// No description provided for @sliderDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String sliderDayLabel(int day);

  /// No description provided for @appliesFromNextCycle.
  ///
  /// In en, this message translates to:
  /// **'Will apply from next cycle'**
  String get appliesFromNextCycle;

  /// No description provided for @confirmEditSalaryDay.
  ///
  /// In en, this message translates to:
  /// **'Confirm salary day change'**
  String get confirmEditSalaryDay;

  /// No description provided for @newSalaryDayConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The new salary day (Day {day}) will apply from your next cycle.\nThe current cycle will not be affected.'**
  String newSalaryDayConfirmBody(int day);

  /// No description provided for @editMonthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Edit Monthly Salary'**
  String get editMonthlySalary;

  /// No description provided for @enterNewSalary.
  ///
  /// In en, this message translates to:
  /// **'Enter new salary'**
  String get enterNewSalary;

  /// No description provided for @salaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Salary is required'**
  String get salaryRequired;

  /// No description provided for @salaryMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Salary must be greater than zero'**
  String get salaryMustBePositive;

  /// No description provided for @confirmEditSalary.
  ///
  /// In en, this message translates to:
  /// **'Confirm salary change'**
  String get confirmEditSalary;

  /// No description provided for @newSalaryConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The new salary ({amount} DA) will apply from your next cycle.\nThe current cycle will not be affected.'**
  String newSalaryConfirmBody(int amount);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageAr.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageAr;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @resetWarningBody.
  ///
  /// In en, this message translates to:
  /// **'You will delete all your financial data including:\n\n• All expenses\n• All debts and payments\n• All lendings\n• All goals and savings\n• Financial cycle history\n\nOnly your salary and salary day will be kept.\n\nThis action cannot be undone.'**
  String get resetWarningBody;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to recover any data after this step.\n\nDo you want to continue?'**
  String get cannotBeUndone;

  /// No description provided for @noCancel.
  ///
  /// In en, this message translates to:
  /// **'No, cancel'**
  String get noCancel;

  /// No description provided for @catEssentials.
  ///
  /// In en, this message translates to:
  /// **'Essentials'**
  String get catEssentials;

  /// No description provided for @catHomeFamily.
  ///
  /// In en, this message translates to:
  /// **'Home & Family'**
  String get catHomeFamily;

  /// No description provided for @catLuxuries.
  ///
  /// In en, this message translates to:
  /// **'Luxuries'**
  String get catLuxuries;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get catClothing;

  /// No description provided for @catRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get catRestaurants;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @subFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get subFood;

  /// No description provided for @subTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get subTransport;

  /// No description provided for @subBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get subBills;

  /// No description provided for @subMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get subMedicine;

  /// No description provided for @subHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get subHousehold;

  /// No description provided for @subChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get subChildren;

  /// No description provided for @subGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get subGifts;

  /// No description provided for @subRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get subRestaurants;

  /// No description provided for @subCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get subCoffee;

  /// No description provided for @subClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get subClothing;

  /// No description provided for @subEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get subEntertainment;

  /// No description provided for @subDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get subDoctor;

  /// No description provided for @subPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get subPharmacy;

  /// No description provided for @subHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get subHospital;

  /// No description provided for @subLabTests.
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get subLabTests;

  /// No description provided for @subFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get subFuel;

  /// No description provided for @subCarMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Car Maintenance'**
  String get subCarMaintenance;

  /// No description provided for @subTaxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get subTaxi;

  /// No description provided for @subTransportTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get subTransportTicket;

  /// No description provided for @subMenClothing.
  ///
  /// In en, this message translates to:
  /// **'Men\'s Clothing'**
  String get subMenClothing;

  /// No description provided for @subWomenClothing.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Clothing'**
  String get subWomenClothing;

  /// No description provided for @subKidsClothing.
  ///
  /// In en, this message translates to:
  /// **'Kids\' Clothing'**
  String get subKidsClothing;

  /// No description provided for @subShoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get subShoes;

  /// No description provided for @subRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get subRestaurant;

  /// No description provided for @subFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get subFastFood;

  /// No description provided for @subCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get subCafe;

  /// No description provided for @subDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get subDelivery;

  /// No description provided for @subSchoolUniversity.
  ///
  /// In en, this message translates to:
  /// **'School & University'**
  String get subSchoolUniversity;

  /// No description provided for @subTutoring.
  ///
  /// In en, this message translates to:
  /// **'Tutoring'**
  String get subTutoring;

  /// No description provided for @subBooksStationery.
  ///
  /// In en, this message translates to:
  /// **'Books & Stationery'**
  String get subBooksStationery;

  /// No description provided for @subTrainingCourses.
  ///
  /// In en, this message translates to:
  /// **'Training Courses'**
  String get subTrainingCourses;

  /// No description provided for @subOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get subOther;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @deleteExpenseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this expense?'**
  String get deleteExpenseConfirm;

  /// No description provided for @addIncomeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncomeTooltip;

  /// No description provided for @debtsLabel.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsLabel;

  /// No description provided for @debtPaymentsThisCycle.
  ///
  /// In en, this message translates to:
  /// **'Payments this cycle'**
  String get debtPaymentsThisCycle;

  /// No description provided for @fromSavingsThisCycle.
  ///
  /// In en, this message translates to:
  /// **'From savings this cycle'**
  String get fromSavingsThisCycle;

  /// No description provided for @lendingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lendings'**
  String get lendingsLabel;

  /// No description provided for @lendingsThisCycle.
  ///
  /// In en, this message translates to:
  /// **'Lendings this cycle'**
  String get lendingsThisCycle;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Expense'**
  String get recordExpense;

  /// No description provided for @financialGoals.
  ///
  /// In en, this message translates to:
  /// **'Financial Goals'**
  String get financialGoals;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'No goals set yet'**
  String get noGoalsYet;

  /// No description provided for @noDebtsNow.
  ///
  /// In en, this message translates to:
  /// **'No debts currently'**
  String get noDebtsNow;

  /// No description provided for @noLendingsNow.
  ///
  /// In en, this message translates to:
  /// **'No lendings currently'**
  String get noLendingsNow;

  /// No description provided for @financialInsights.
  ///
  /// In en, this message translates to:
  /// **'Financial Insights'**
  String get financialInsights;

  /// No description provided for @financialLeaks.
  ///
  /// In en, this message translates to:
  /// **'Financial Leaks'**
  String get financialLeaks;

  /// No description provided for @monthlyTrends.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trends'**
  String get monthlyTrends;

  /// No description provided for @noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get noInsightsYet;

  /// No description provided for @insightsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Leaks and trends will appear when there is enough data'**
  String get insightsEmptyDesc;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get noExpenses;

  /// No description provided for @startRecordingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Start recording your daily expenses'**
  String get startRecordingExpenses;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent Expenses'**
  String get recentExpenses;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String timeDaysAgo(int days);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks} wk ago'**
  String timeWeeksAgo(int weeks);

  /// No description provided for @nameOrOrganization.
  ///
  /// In en, this message translates to:
  /// **'Name / Organization'**
  String get nameOrOrganization;

  /// No description provided for @creditorNameHint2.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bank, friend'**
  String get creditorNameHint2;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountMustBePositive;

  /// No description provided for @debtIsSpentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Has this amount been spent?'**
  String get debtIsSpentQuestion;

  /// No description provided for @debtIsSpentDesc.
  ///
  /// In en, this message translates to:
  /// **'Amount has been spent and is no longer in your balance'**
  String get debtIsSpentDesc;

  /// No description provided for @debtNotSpentDesc.
  ///
  /// In en, this message translates to:
  /// **'Amount is still in your balance'**
  String get debtNotSpentDesc;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @cycleBalance.
  ///
  /// In en, this message translates to:
  /// **'Cycle: {amount}'**
  String cycleBalance(String amount);

  /// No description provided for @expensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesLabel;

  /// No description provided for @expensesSavingsThisCycle.
  ///
  /// In en, this message translates to:
  /// **'From savings: {amount}'**
  String expensesSavingsThisCycle(String amount);

  /// No description provided for @consumptionRate.
  ///
  /// In en, this message translates to:
  /// **'Consumption Rate'**
  String get consumptionRate;

  /// No description provided for @daysRemainingLabel.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get daysRemainingLabel;

  /// No description provided for @salaryDayExclamation.
  ///
  /// In en, this message translates to:
  /// **'Salary Day!'**
  String get salaryDayExclamation;

  /// No description provided for @dayUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get dayUnit;

  /// No description provided for @dailyAverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverageLabel;

  /// No description provided for @safeDailyLabel.
  ///
  /// In en, this message translates to:
  /// **'Safe Daily Spending'**
  String get safeDailyLabel;

  /// No description provided for @canSpendPrefix.
  ///
  /// In en, this message translates to:
  /// **'You can spend'**
  String get canSpendPrefix;

  /// No description provided for @dailySuffix.
  ///
  /// In en, this message translates to:
  /// **'daily'**
  String get dailySuffix;

  /// No description provided for @tierLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get tierLegendary;

  /// No description provided for @tierSmart.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get tierSmart;

  /// No description provided for @tierBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get tierBalanced;

  /// No description provided for @tierSpender.
  ///
  /// In en, this message translates to:
  /// **'Spender'**
  String get tierSpender;

  /// No description provided for @tierDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger'**
  String get tierDanger;

  /// No description provided for @tierEarlyBankrupt.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get tierEarlyBankrupt;

  /// No description provided for @tierLegendaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Exceptional performance! You saved more than 30%'**
  String get tierLegendaryDesc;

  /// No description provided for @tierSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart money management. You saved between 15% and 30%'**
  String get tierSmartDesc;

  /// No description provided for @tierBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced spending. You saved between 5% and 15%'**
  String get tierBalancedDesc;

  /// No description provided for @tierSpenderDesc.
  ///
  /// In en, this message translates to:
  /// **'High spending. Try to save more'**
  String get tierSpenderDesc;

  /// No description provided for @tierDangerDesc.
  ///
  /// In en, this message translates to:
  /// **'You exceeded your budget! Review your expenses'**
  String get tierDangerDesc;

  /// No description provided for @tierEarlyBankruptDesc.
  ///
  /// In en, this message translates to:
  /// **'Very fast spending at the start of the month'**
  String get tierEarlyBankruptDesc;

  /// No description provided for @spendingTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrendTitle;

  /// No description provided for @cumulativeVsBudget.
  ///
  /// In en, this message translates to:
  /// **'Cumulative spending vs budget'**
  String get cumulativeVsBudget;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @chartDayShort.
  ///
  /// In en, this message translates to:
  /// **'{day}'**
  String chartDayShort(int day);

  /// No description provided for @actualSpendingLegend.
  ///
  /// In en, this message translates to:
  /// **'Actual Spending'**
  String get actualSpendingLegend;

  /// No description provided for @budgetCeilingLegend.
  ///
  /// In en, this message translates to:
  /// **'Budget Ceiling'**
  String get budgetCeilingLegend;

  /// No description provided for @categoryBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get categoryBreakdownTitle;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @monthlyComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison'**
  String get monthlyComparisonTitle;

  /// No description provided for @insufficientDataForComparison.
  ///
  /// In en, this message translates to:
  /// **'Insufficient data for comparison'**
  String get insufficientDataForComparison;

  /// No description provided for @addIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncomeTitle;

  /// No description provided for @incomeSource.
  ///
  /// In en, this message translates to:
  /// **'Income Source'**
  String get incomeSource;

  /// No description provided for @editIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncomeTitle;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @incomeSourceRequired.
  ///
  /// In en, this message translates to:
  /// **'Income source is required'**
  String get incomeSourceRequired;

  /// No description provided for @incomeSaved.
  ///
  /// In en, this message translates to:
  /// **'Income saved successfully'**
  String get incomeSaved;

  /// No description provided for @incomeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Income updated successfully'**
  String get incomeUpdated;

  /// No description provided for @incomeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Income deleted'**
  String get incomeDeleted;

  /// No description provided for @deleteIncome.
  ///
  /// In en, this message translates to:
  /// **'Delete Income'**
  String get deleteIncome;

  /// No description provided for @deleteIncomeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteIncomeConfirm(String name);

  /// No description provided for @additionalIncomes.
  ///
  /// In en, this message translates to:
  /// **'Additional Incomes'**
  String get additionalIncomes;

  /// No description provided for @addAnotherIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Another Income'**
  String get addAnotherIncome;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and Continue'**
  String get saveAndContinue;

  /// No description provided for @additionalIncomePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Incomes'**
  String get additionalIncomePageTitle;

  /// No description provided for @addAdditionalIncomes.
  ///
  /// In en, this message translates to:
  /// **'Add your additional incomes'**
  String get addAdditionalIncomes;

  /// No description provided for @additionalIncomeExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. extra work, rent, scholarship...'**
  String get additionalIncomeExample;

  /// No description provided for @incomeNumber.
  ///
  /// In en, this message translates to:
  /// **'Income {n}'**
  String incomeNumber(int n);

  /// No description provided for @incomeSourceHint.
  ///
  /// In en, this message translates to:
  /// **'Source (e.g. extra work)'**
  String get incomeSourceHint;

  /// No description provided for @activeTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// No description provided for @completedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// No description provided for @settledTab.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settledTab;

  /// No description provided for @collectedTab.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collectedTab;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingAmount;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paidAmount;

  /// No description provided for @collectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Collected Amount'**
  String get collectedAmount;

  /// No description provided for @amountSaved.
  ///
  /// In en, this message translates to:
  /// **'Amount Saved'**
  String get amountSaved;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal:'**
  String get goalLabel;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @fromSavings.
  ///
  /// In en, this message translates to:
  /// **'From savings'**
  String get fromSavings;

  /// No description provided for @fromBalance.
  ///
  /// In en, this message translates to:
  /// **'From balance'**
  String get fromBalance;

  /// No description provided for @toSavings.
  ///
  /// In en, this message translates to:
  /// **'To savings'**
  String get toSavings;

  /// No description provided for @toBalance.
  ///
  /// In en, this message translates to:
  /// **'To balance'**
  String get toBalance;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @amountInDZD.
  ///
  /// In en, this message translates to:
  /// **'Amount (in DA)'**
  String get amountInDZD;

  /// No description provided for @amountExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds remaining ({amount} DA)'**
  String amountExceedsRemaining(String amount);

  /// No description provided for @addAmountTo.
  ///
  /// In en, this message translates to:
  /// **'Add amount to'**
  String get addAmountTo;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @financialGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Goals'**
  String get financialGoalsTitle;

  /// No description provided for @goalDetails.
  ///
  /// In en, this message translates to:
  /// **'Goal Details'**
  String get goalDetails;

  /// No description provided for @noCompletedGoals.
  ///
  /// In en, this message translates to:
  /// **'No completed goals'**
  String get noCompletedGoals;

  /// No description provided for @completedGoalsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Goals you purchase will appear here'**
  String get completedGoalsEmptyDesc;

  /// No description provided for @activeGoalsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your financial journey by creating a new goal'**
  String get activeGoalsEmptyDesc;

  /// No description provided for @deleteGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Goal'**
  String get deleteGoalTitle;

  /// No description provided for @deleteGoalBody.
  ///
  /// In en, this message translates to:
  /// **'The goal will be deleted. Your contributions will remain saved.'**
  String get deleteGoalBody;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed successfully!'**
  String get purchaseSuccess;

  /// No description provided for @goalDeletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Goal deleted'**
  String get goalDeletedMsg;

  /// No description provided for @confirmPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get confirmPurchaseTitle;

  /// No description provided for @confirmPurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to purchase \"{name}\"?\n{amount} DA will be deducted from savings.'**
  String confirmPurchaseBody(String name, int amount);

  /// No description provided for @debtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsTitle;

  /// No description provided for @debtDetails.
  ///
  /// In en, this message translates to:
  /// **'Debt Details'**
  String get debtDetails;

  /// No description provided for @noSettledDebts.
  ///
  /// In en, this message translates to:
  /// **'No settled debts'**
  String get noSettledDebts;

  /// No description provided for @settledDebtsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Debts that have been fully paid will appear here'**
  String get settledDebtsEmptyDesc;

  /// No description provided for @activeDebtsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your debts easily and manage your payments'**
  String get activeDebtsEmptyDesc;

  /// No description provided for @totalDebtsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Total Remaining Debts'**
  String get totalDebtsRemaining;

  /// No description provided for @debtDeletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Debt deleted successfully'**
  String get debtDeletedMsg;

  /// No description provided for @deleteDebtTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Debt'**
  String get deleteDebtTitle;

  /// No description provided for @deleteDebtBody.
  ///
  /// In en, this message translates to:
  /// **'The debt and all related payments will be deleted. Do you want to continue?'**
  String get deleteDebtBody;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @percentPaid.
  ///
  /// In en, this message translates to:
  /// **'{percent}% paid'**
  String percentPaid(String percent);

  /// No description provided for @lendingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lendings'**
  String get lendingsTitle;

  /// No description provided for @lendingDetails.
  ///
  /// In en, this message translates to:
  /// **'Lending Details'**
  String get lendingDetails;

  /// No description provided for @noCollectedLendings.
  ///
  /// In en, this message translates to:
  /// **'No collected lendings'**
  String get noCollectedLendings;

  /// No description provided for @collectedLendingsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Lendings that have been fully collected will appear here'**
  String get collectedLendingsEmptyDesc;

  /// No description provided for @activeLendingsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your lendings easily and manage your collections'**
  String get activeLendingsEmptyDesc;

  /// No description provided for @totalLendingsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Total Remaining Lendings'**
  String get totalLendingsRemaining;

  /// No description provided for @lendingDeletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Lending deleted'**
  String get lendingDeletedMsg;

  /// No description provided for @collectionAddedMsg.
  ///
  /// In en, this message translates to:
  /// **'Collection recorded successfully'**
  String get collectionAddedMsg;

  /// No description provided for @deleteLendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Lending'**
  String get deleteLendingTitle;

  /// No description provided for @deleteLendingBody.
  ///
  /// In en, this message translates to:
  /// **'The lending and all related recoveries will be deleted. Do you want to continue?'**
  String get deleteLendingBody;

  /// No description provided for @addCollection.
  ///
  /// In en, this message translates to:
  /// **'Record Collection'**
  String get addCollection;

  /// No description provided for @remainingAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String remainingAmountLabel(String amount);

  /// No description provided for @collectedAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Collected amount'**
  String get collectedAmountHint;

  /// No description provided for @collectionHistory.
  ///
  /// In en, this message translates to:
  /// **'Collection History'**
  String get collectionHistory;

  /// No description provided for @percentCollected.
  ///
  /// In en, this message translates to:
  /// **'{percent}% collected'**
  String percentCollected(String percent);

  /// No description provided for @noPreviousCycles.
  ///
  /// In en, this message translates to:
  /// **'No previous cycles'**
  String get noPreviousCycles;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @totalExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpensesLabel;

  /// No description provided for @finalBalance.
  ///
  /// In en, this message translates to:
  /// **'Final Balance'**
  String get finalBalance;

  /// No description provided for @challengeDetails.
  ///
  /// In en, this message translates to:
  /// **'Challenge Details'**
  String get challengeDetails;

  /// No description provided for @challengeDescription.
  ///
  /// In en, this message translates to:
  /// **'Challenge Description'**
  String get challengeDescription;

  /// No description provided for @weekStart.
  ///
  /// In en, this message translates to:
  /// **'Week Start'**
  String get weekStart;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @challengeMotivation.
  ///
  /// In en, this message translates to:
  /// **'Try to achieve this goal this week!'**
  String get challengeMotivation;

  /// No description provided for @challengeCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Amazing! You completed this challenge 🎉'**
  String get challengeCompletedMsg;

  /// Currency symbol for Algerian Dinar
  ///
  /// In en, this message translates to:
  /// **'DA'**
  String get currencySymbol;

  /// No description provided for @totalSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Salary'**
  String get totalSalaryLabel;

  /// No description provided for @savingsAllocationLabel.
  ///
  /// In en, this message translates to:
  /// **'For Savings'**
  String get savingsAllocationLabel;

  /// No description provided for @remainingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalanceLabel;

  /// No description provided for @balanceWillBeZeroWarning.
  ///
  /// In en, this message translates to:
  /// **'Your balance will be 0 DA'**
  String get balanceWillBeZeroWarning;

  /// No description provided for @paymentSource.
  ///
  /// In en, this message translates to:
  /// **'Payment Source'**
  String get paymentSource;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @availableLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableLabel;

  /// No description provided for @incomeBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Income Sources'**
  String get incomeBreakdownTitle;

  /// No description provided for @totalAdditionalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total: {total}'**
  String totalAdditionalIncome(String total);

  /// No description provided for @noAdditionalIncomeYet.
  ///
  /// In en, this message translates to:
  /// **'No additional income this cycle'**
  String get noAdditionalIncomeYet;

  /// No description provided for @incomeVsSpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Income vs Spending'**
  String get incomeVsSpendingTitle;

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @spendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spendingLabel;

  /// No description provided for @totalIncomeThisCycle.
  ///
  /// In en, this message translates to:
  /// **'Total income this cycle'**
  String get totalIncomeThisCycle;

  /// No description provided for @savingsRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get savingsRateLabel;

  /// No description provided for @savingsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings balance history'**
  String get savingsHistoryTitle;

  /// No description provided for @savingsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your savings balance across cycles'**
  String get savingsHistorySubtitle;

  /// No description provided for @filterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get filterWeek;

  /// No description provided for @filterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get filterMonth;

  /// No description provided for @filterThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get filterThreeMonths;

  /// No description provided for @filterCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get filterCustom;

  /// No description provided for @statsDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Period: {start} — {end}'**
  String statsDateRangeLabel(String start, String end);

  /// No description provided for @dailyBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily remaining'**
  String get dailyBudgetTitle;

  /// No description provided for @perDayLabel.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get perDayLabel;

  /// No description provided for @monthForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle-end forecast'**
  String get monthForecastTitle;

  /// No description provided for @overBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get overBudgetLabel;

  /// No description provided for @nearBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Near limit'**
  String get nearBudgetLabel;

  /// No description provided for @underBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get underBudgetLabel;

  /// No description provided for @forecastFromLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get forecastFromLabel;

  /// No description provided for @customCategory.
  ///
  /// In en, this message translates to:
  /// **'Custom category'**
  String get customCategory;

  /// No description provided for @weekChallenge.
  ///
  /// In en, this message translates to:
  /// **'Week {n} Challenge'**
  String weekChallenge(int n);

  /// No description provided for @challengeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get challengeCompleted;

  /// No description provided for @deleteOperation.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteOperation;

  /// No description provided for @deleteOperationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction? This cannot be undone.'**
  String get deleteOperationConfirm;

  /// No description provided for @editOperation.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editOperation;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @chooseWilaya.
  ///
  /// In en, this message translates to:
  /// **'Choose your wilaya'**
  String get chooseWilaya;

  /// No description provided for @searchWilaya.
  ///
  /// In en, this message translates to:
  /// **'Search for your wilaya...'**
  String get searchWilaya;

  /// No description provided for @chooseCommune.
  ///
  /// In en, this message translates to:
  /// **'Choose your commune'**
  String get chooseCommune;

  /// No description provided for @searchCommune.
  ///
  /// In en, this message translates to:
  /// **'Search for your commune...'**
  String get searchCommune;

  /// No description provided for @salarySplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary Split'**
  String get salarySplitTitle;

  /// No description provided for @salarySplitQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much do you want to save from your salary?'**
  String get salarySplitQuestion;

  /// No description provided for @salarySplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Set the amount to transfer directly to savings'**
  String get salarySplitDesc;

  /// No description provided for @forgottenLending.
  ///
  /// In en, this message translates to:
  /// **'Forgotten lending (no deduction from balance)'**
  String get forgottenLending;

  /// No description provided for @classificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Financial Classification'**
  String get classificationTitle;

  /// No description provided for @classificationExplanationTitle.
  ///
  /// In en, this message translates to:
  /// **'Classification Explanation'**
  String get classificationExplanationTitle;

  /// No description provided for @classificationImprovementTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Improve'**
  String get classificationImprovementTitle;

  /// No description provided for @classificationStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Statistics'**
  String get classificationStatsTitle;

  /// No description provided for @explanationLegendary.
  ///
  /// In en, this message translates to:
  /// **'You are at the highest level! You manage your money efficiently and achieve your financial goals.'**
  String get explanationLegendary;

  /// No description provided for @explanationSmart.
  ///
  /// In en, this message translates to:
  /// **'You make smart financial decisions and achieve a good savings rate.'**
  String get explanationSmart;

  /// No description provided for @explanationBalanced.
  ///
  /// In en, this message translates to:
  /// **'Your expense management is balanced. Keep monitoring carefully.'**
  String get explanationBalanced;

  /// No description provided for @explanationSpendthrift.
  ///
  /// In en, this message translates to:
  /// **'You spend faster than necessary. Try to reduce optional expenses.'**
  String get explanationSpendthrift;

  /// No description provided for @explanationDanger.
  ///
  /// In en, this message translates to:
  /// **'You need to take better control. Beware of running out of balance.'**
  String get explanationDanger;

  /// No description provided for @explanationEarlyBankruptcy.
  ///
  /// In en, this message translates to:
  /// **'You have spent more than your income. Act now to fix the situation!'**
  String get explanationEarlyBankruptcy;

  /// No description provided for @suggestionLegendary.
  ///
  /// In en, this message translates to:
  /// **'Maintain the current level'**
  String get suggestionLegendary;

  /// No description provided for @suggestionSmart.
  ///
  /// In en, this message translates to:
  /// **'Increase your savings rate'**
  String get suggestionSmart;

  /// No description provided for @suggestionBalanced.
  ///
  /// In en, this message translates to:
  /// **'Maintain balance'**
  String get suggestionBalanced;

  /// No description provided for @suggestionSpendthrift.
  ///
  /// In en, this message translates to:
  /// **'Control your spending'**
  String get suggestionSpendthrift;

  /// No description provided for @suggestionDanger.
  ///
  /// In en, this message translates to:
  /// **'Reduce spending drastically'**
  String get suggestionDanger;

  /// No description provided for @suggestionEarlyBankruptcy.
  ///
  /// In en, this message translates to:
  /// **'Quick action required'**
  String get suggestionEarlyBankruptcy;

  /// No description provided for @tipInvestSurplus.
  ///
  /// In en, this message translates to:
  /// **'Invest your surplus money'**
  String get tipInvestSurplus;

  /// No description provided for @tipHelpOthers.
  ///
  /// In en, this message translates to:
  /// **'Help others financially'**
  String get tipHelpOthers;

  /// No description provided for @tipShareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with loved ones'**
  String get tipShareExperience;

  /// No description provided for @tipReduceOptional.
  ///
  /// In en, this message translates to:
  /// **'Reduce optional expenses'**
  String get tipReduceOptional;

  /// No description provided for @tipFindExtraIncome.
  ///
  /// In en, this message translates to:
  /// **'Find additional income sources'**
  String get tipFindExtraIncome;

  /// No description provided for @tipTrackWeekly.
  ///
  /// In en, this message translates to:
  /// **'Monitor spending weekly'**
  String get tipTrackWeekly;

  /// No description provided for @tipWatchExcess.
  ///
  /// In en, this message translates to:
  /// **'Watch excess expenses'**
  String get tipWatchExcess;

  /// No description provided for @tipPlanEmergency.
  ///
  /// In en, this message translates to:
  /// **'Plan for emergency periods'**
  String get tipPlanEmergency;

  /// No description provided for @tipSetClearGoals.
  ///
  /// In en, this message translates to:
  /// **'Set clear financial goals'**
  String get tipSetClearGoals;

  /// No description provided for @tipListBeforeShopping.
  ///
  /// In en, this message translates to:
  /// **'Make a list before shopping'**
  String get tipListBeforeShopping;

  /// No description provided for @tipAvoidImpulse.
  ///
  /// In en, this message translates to:
  /// **'Avoid impulse buying'**
  String get tipAvoidImpulse;

  /// No description provided for @tipSetDailyBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a daily budget'**
  String get tipSetDailyBudget;

  /// No description provided for @tipStopUnnecessary.
  ///
  /// In en, this message translates to:
  /// **'Stop unnecessary purchases'**
  String get tipStopUnnecessary;

  /// No description provided for @tipReviewDaily.
  ///
  /// In en, this message translates to:
  /// **'Review every daily expense'**
  String get tipReviewDaily;

  /// No description provided for @tipSeekHelp.
  ///
  /// In en, this message translates to:
  /// **'Seek financial help if needed'**
  String get tipSeekHelp;

  /// No description provided for @tipEssentialOnly.
  ///
  /// In en, this message translates to:
  /// **'Identify essential expenses only'**
  String get tipEssentialOnly;

  /// No description provided for @tipFindExtraIncome2.
  ///
  /// In en, this message translates to:
  /// **'Find additional income sources'**
  String get tipFindExtraIncome2;

  /// No description provided for @tipRestructureBudget.
  ///
  /// In en, this message translates to:
  /// **'Restructure your entire budget'**
  String get tipRestructureBudget;

  /// No description provided for @canSave.
  ///
  /// In en, this message translates to:
  /// **'You can save: '**
  String get canSave;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactions(int count);

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get lastMonth;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @savingsRateShort.
  ///
  /// In en, this message translates to:
  /// **'{rate}% savings rate'**
  String savingsRateShort(String rate);

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the \"{name}\" category?'**
  String deleteCategoryConfirm(String name);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @addCustomCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Category'**
  String get addCustomCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sports, Pets...'**
  String get categoryNameHint;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseIcon;

  /// No description provided for @hintEssentials.
  ///
  /// In en, this message translates to:
  /// **'e.g. bread, chicken, water, medicine...'**
  String get hintEssentials;

  /// No description provided for @hintHomeFamily.
  ///
  /// In en, this message translates to:
  /// **'e.g. household items, gift, household expense...'**
  String get hintHomeFamily;

  /// No description provided for @hintLuxuries.
  ///
  /// In en, this message translates to:
  /// **'e.g. coffee, t-shirt, entertainment...'**
  String get hintLuxuries;

  /// No description provided for @hintHealth.
  ///
  /// In en, this message translates to:
  /// **'e.g. medical visit, medicine, lab tests...'**
  String get hintHealth;

  /// No description provided for @hintTransport.
  ///
  /// In en, this message translates to:
  /// **'e.g. fuel, taxi, ticket...'**
  String get hintTransport;

  /// No description provided for @hintClothing.
  ///
  /// In en, this message translates to:
  /// **'e.g. shirt, shoes, pants...'**
  String get hintClothing;

  /// No description provided for @hintRestaurants.
  ///
  /// In en, this message translates to:
  /// **'e.g. pizza, burger, coffee...'**
  String get hintRestaurants;

  /// No description provided for @hintEducation.
  ///
  /// In en, this message translates to:
  /// **'e.g. book, tutoring, course...'**
  String get hintEducation;

  /// No description provided for @hintDefault.
  ///
  /// In en, this message translates to:
  /// **'e.g. describe what you bought...'**
  String get hintDefault;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpenseTitle;

  /// No description provided for @expenseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Expense not found'**
  String get expenseNotFound;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @insufficientBalanceDetail.
  ///
  /// In en, this message translates to:
  /// **'Your current balance is {balance} DA and savings {savings} DA — insufficient for this amount'**
  String insufficientBalanceDetail(int balance, int savings);

  /// No description provided for @allFromBalance.
  ///
  /// In en, this message translates to:
  /// **'All from balance'**
  String get allFromBalance;

  /// No description provided for @allFromSavings.
  ///
  /// In en, this message translates to:
  /// **'All from savings'**
  String get allFromSavings;

  /// No description provided for @payFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay from'**
  String get payFromLabel;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalanceLabel;

  /// No description provided for @savingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savingsLabel;

  /// No description provided for @splashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Chahriyti'**
  String get splashWelcome;

  /// No description provided for @splashBody.
  ///
  /// In en, this message translates to:
  /// **'Most people know how much they earn... but few know where their money goes.'**
  String get splashBody;

  /// No description provided for @splashBold.
  ///
  /// In en, this message translates to:
  /// **'Today you took a different step.'**
  String get splashBold;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @valuePropFromNow.
  ///
  /// In en, this message translates to:
  /// **'From now on...'**
  String get valuePropFromNow;

  /// No description provided for @valuePropContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get valuePropContinue;

  /// No description provided for @valuePropQuote2.
  ///
  /// In en, this message translates to:
  /// **'\"What gets measured gets improved.\"'**
  String get valuePropQuote2;

  /// No description provided for @vp1.
  ///
  /// In en, this message translates to:
  /// **'You\'ll know your real balance at any moment'**
  String get vp1;

  /// No description provided for @vp2.
  ///
  /// In en, this message translates to:
  /// **'You\'ll record your expenses easily without complexity'**
  String get vp2;

  /// No description provided for @vp3.
  ///
  /// In en, this message translates to:
  /// **'You\'ll discover where your salary actually goes'**
  String get vp3;

  /// No description provided for @vp4.
  ///
  /// In en, this message translates to:
  /// **'You\'ll monitor your financial goals step by step'**
  String get vp4;

  /// No description provided for @vp5.
  ///
  /// In en, this message translates to:
  /// **'You\'ll track your debts and loans without forgetting'**
  String get vp5;

  /// No description provided for @vp6.
  ///
  /// In en, this message translates to:
  /// **'You\'ll set a safe daily spending limit'**
  String get vp6;

  /// No description provided for @vp7.
  ///
  /// In en, this message translates to:
  /// **'You\'ll build your savings gradually and systematically'**
  String get vp7;

  /// No description provided for @vp8.
  ///
  /// In en, this message translates to:
  /// **'You\'ll record your additional income sources'**
  String get vp8;

  /// No description provided for @vp9.
  ///
  /// In en, this message translates to:
  /// **'You\'ll monitor your financial statistics clearly'**
  String get vp9;

  /// No description provided for @vp10.
  ///
  /// In en, this message translates to:
  /// **'You\'ll make financial decisions based on real numbers, not guesswork'**
  String get vp10;

  /// No description provided for @exclusiveSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get exclusiveSkip;

  /// No description provided for @exclusiveHeading.
  ///
  /// In en, this message translates to:
  /// **'You are among the few'**
  String get exclusiveHeading;

  /// No description provided for @exclusiveBody1.
  ///
  /// In en, this message translates to:
  /// **'Most people postpone organizing their finances to next month.'**
  String get exclusiveBody1;

  /// No description provided for @exclusiveBody2.
  ///
  /// In en, this message translates to:
  /// **'Then the month after.'**
  String get exclusiveBody2;

  /// No description provided for @exclusiveBody3.
  ///
  /// In en, this message translates to:
  /// **'Then years pass without change.'**
  String get exclusiveBody3;

  /// No description provided for @exclusiveHighlight.
  ///
  /// In en, this message translates to:
  /// **'Downloading this app means you decided to start today.'**
  String get exclusiveHighlight;

  /// No description provided for @exclusiveContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get exclusiveContinue;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up Chahriyti for you'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter some basic information to start setting up your personal experience'**
  String get profileSetupSubtitle;

  /// No description provided for @profileNameQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like us to call you?'**
  String get profileNameQuestion;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Write your full name'**
  String get profileNameHint;

  /// No description provided for @profileWhereQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where do you live?'**
  String get profileWhereQuestion;

  /// No description provided for @profileWilayaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your wilaya'**
  String get profileWilayaPlaceholder;

  /// No description provided for @profileCommuneLabel.
  ///
  /// In en, this message translates to:
  /// **'Commune'**
  String get profileCommuneLabel;

  /// No description provided for @profileCommunePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your commune'**
  String get profileCommunePlaceholder;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhoneLabel;

  /// No description provided for @profilePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'We use this information to create your account, save your data and secure access to the app.'**
  String get profilePrivacyNote;

  /// No description provided for @profileSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get profileSubmitButton;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get profileNameRequired;

  /// No description provided for @profileWilayaRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a wilaya'**
  String get profileWilayaRequired;

  /// No description provided for @profileCommuneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a commune'**
  String get profileCommuneRequired;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number — enter a valid Algerian number (05X / 06X / 07X)'**
  String get profilePhoneInvalid;

  /// No description provided for @ageGroupFewKnow.
  ///
  /// In en, this message translates to:
  /// **'Few people know where their money goes.'**
  String get ageGroupFewKnow;

  /// No description provided for @ageGroupDifferentStep.
  ///
  /// In en, this message translates to:
  /// **'Today you took a different step.'**
  String get ageGroupDifferentStep;

  /// No description provided for @ageGroupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which age group do you fall into?'**
  String get ageGroupQuestion;

  /// No description provided for @age20to30.
  ///
  /// In en, this message translates to:
  /// **'20 to 30 years'**
  String get age20to30;

  /// No description provided for @age31to40.
  ///
  /// In en, this message translates to:
  /// **'31 to 40 years'**
  String get age31to40;

  /// No description provided for @age41to50.
  ///
  /// In en, this message translates to:
  /// **'41 to 50 years'**
  String get age41to50;

  /// No description provided for @ageOver50.
  ///
  /// In en, this message translates to:
  /// **'Over 50 years'**
  String get ageOver50;

  /// No description provided for @celebrationWelcomeWithName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String celebrationWelcomeWithName(String name);

  /// No description provided for @celebrationWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Chahriyti!'**
  String get celebrationWelcome;

  /// No description provided for @celebrationTagline.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti is happy to have you'**
  String get celebrationTagline;

  /// No description provided for @celebrationBody.
  ///
  /// In en, this message translates to:
  /// **'We are now in contact with you. We will reach out soon to help you and complete the steps to get Chahriyti.'**
  String get celebrationBody;

  /// No description provided for @celebrationFooter.
  ///
  /// In en, this message translates to:
  /// **'Chahriyti — The first companion for the Algerian employee'**
  String get celebrationFooter;

  /// No description provided for @celebrationActivateButton.
  ///
  /// In en, this message translates to:
  /// **'I have the activation code'**
  String get celebrationActivateButton;

  /// No description provided for @financialProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your financial situation'**
  String get financialProfileTitle;

  /// No description provided for @financialProfileSalaryQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your monthly salary?'**
  String get financialProfileSalaryQuestion;

  /// No description provided for @financialProfileSalaryDayQuestion.
  ///
  /// In en, this message translates to:
  /// **'When do you receive your salary?'**
  String get financialProfileSalaryDayQuestion;

  /// No description provided for @financialProfileStartOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Start of month'**
  String get financialProfileStartOfMonth;

  /// No description provided for @financialProfileCustomDay.
  ///
  /// In en, this message translates to:
  /// **'Specific date'**
  String get financialProfileCustomDay;

  /// No description provided for @financialProfileDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of every month'**
  String financialProfileDayOfMonth(int day);

  /// No description provided for @financialProfileMaritalQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your marital status?'**
  String get financialProfileMaritalQuestion;

  /// No description provided for @financialProfileSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get financialProfileSingle;

  /// No description provided for @financialProfileMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get financialProfileMarried;

  /// No description provided for @financialProfileMarried1Child.
  ///
  /// In en, this message translates to:
  /// **'Married with 1 child'**
  String get financialProfileMarried1Child;

  /// No description provided for @financialProfileMarried2Children.
  ///
  /// In en, this message translates to:
  /// **'Married with 2 children'**
  String get financialProfileMarried2Children;

  /// No description provided for @financialProfileMarried3Children.
  ///
  /// In en, this message translates to:
  /// **'Married with 3 children'**
  String get financialProfileMarried3Children;

  /// No description provided for @financialProfileMarried4PlusChildren.
  ///
  /// In en, this message translates to:
  /// **'Married with 4 or more children'**
  String get financialProfileMarried4PlusChildren;

  /// No description provided for @financialProfileExpenseTrackQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you write down and track your expenses?'**
  String get financialProfileExpenseTrackQuestion;

  /// No description provided for @financialProfileTracksYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, I write down and track my expenses'**
  String get financialProfileTracksYes;

  /// No description provided for @financialProfileTracksNo.
  ///
  /// In en, this message translates to:
  /// **'No, I don\'t write down my expenses'**
  String get financialProfileTracksNo;

  /// No description provided for @financialProfileSalaryNegative.
  ///
  /// In en, this message translates to:
  /// **'Salary cannot be negative'**
  String get financialProfileSalaryNegative;

  /// No description provided for @goalsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to use Chahriyti?'**
  String get goalsPageTitle;

  /// No description provided for @goalsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get goalsPageSubtitle;

  /// No description provided for @goal1.
  ///
  /// In en, this message translates to:
  /// **'Know my real balance at any moment'**
  String get goal1;

  /// No description provided for @goal2.
  ///
  /// In en, this message translates to:
  /// **'Record my expenses easily'**
  String get goal2;

  /// No description provided for @goal3.
  ///
  /// In en, this message translates to:
  /// **'Know where my salary goes'**
  String get goal3;

  /// No description provided for @goal4.
  ///
  /// In en, this message translates to:
  /// **'Plan my financial goals step by step'**
  String get goal4;

  /// No description provided for @goal5.
  ///
  /// In en, this message translates to:
  /// **'Track my debts and obligations without forgetting'**
  String get goal5;

  /// No description provided for @goal6.
  ///
  /// In en, this message translates to:
  /// **'Set a safe daily spending limit'**
  String get goal6;

  /// No description provided for @goal7.
  ///
  /// In en, this message translates to:
  /// **'Build my savings gradually and systematically'**
  String get goal7;

  /// No description provided for @goal8.
  ///
  /// In en, this message translates to:
  /// **'Record my additional income sources'**
  String get goal8;

  /// No description provided for @goal9.
  ///
  /// In en, this message translates to:
  /// **'Monitor my financial statistics clearly'**
  String get goal9;

  /// No description provided for @goal10.
  ///
  /// In en, this message translates to:
  /// **'Make financial decisions based on my real numbers'**
  String get goal10;

  /// No description provided for @salarySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Setup'**
  String get salarySetupTitle;

  /// No description provided for @salarySetupFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get salarySetupFullName;

  /// No description provided for @salarySetupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mohammed Amine'**
  String get salarySetupNameHint;

  /// No description provided for @salarySetupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get salarySetupNameRequired;

  /// No description provided for @salarySetupPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get salarySetupPhone;

  /// No description provided for @salarySetupPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get salarySetupPhoneRequired;

  /// No description provided for @salarySetupWilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get salarySetupWilaya;

  /// No description provided for @salarySetupSalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly salary'**
  String get salarySetupSalary;

  /// No description provided for @salarySetupSalaryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50000'**
  String get salarySetupSalaryHint;

  /// No description provided for @salarySetupSalaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Salary is required'**
  String get salarySetupSalaryRequired;

  /// No description provided for @salarySetupSalaryPositive.
  ///
  /// In en, this message translates to:
  /// **'Salary must be greater than zero'**
  String get salarySetupSalaryPositive;

  /// No description provided for @salarySetupSalaryDay.
  ///
  /// In en, this message translates to:
  /// **'Salary receipt date'**
  String get salarySetupSalaryDay;

  /// No description provided for @salarySetupFirstOfMonth.
  ///
  /// In en, this message translates to:
  /// **'First of month (Day 1)'**
  String get salarySetupFirstOfMonth;

  /// No description provided for @salarySetupSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific date'**
  String get salarySetupSpecificDate;

  /// No description provided for @salarySetupDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of every month'**
  String salarySetupDayOfMonth(int day);

  /// No description provided for @salarySetupPickDayHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose salary receipt day'**
  String get salarySetupPickDayHelp;

  /// No description provided for @amountInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50000'**
  String get amountInputHint;

  /// No description provided for @appliesFromDate.
  ///
  /// In en, this message translates to:
  /// **'Will apply starting from {day} {month} {year}'**
  String appliesFromDate(int day, String month, int year);

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDec;

  /// No description provided for @deleteExpenseNamed.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteExpenseNamed(String name);

  /// Abbreviation for million in chart axis labels
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get amountMillionShort;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
