# Spec 010 — App Localization (AR / FR / EN)

## Goal

Add full French and English support alongside existing Arabic. User can switch language in Settings. All UI strings, categories, notifications, and validators are localized. App defaults to device locale with fallback to Arabic.

---

## Tech Stack

- Flutter's built-in `flutter_localizations` (already in pubspec)
- `intl` package (already in pubspec)
- ARB files + `flutter gen-l10n` codegen
- `AppLocalizations` class auto-generated
- `LocaleCubit` for runtime language switching persisted via `flutter_secure_storage`

---

## Architecture

```
lib/
├── l10n/
│   ├── app_ar.arb          ← Arabic (existing content)
│   ├── app_en.arb          ← English (template file)
│   └── app_fr.arb          ← French
├── presentation/
│   └── settings/
│       └── cubits/
│           ├── locale_cubit.dart
│           └── locale_state.dart
l10n.yaml                   ← codegen config
```

Generated output: `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`

---

## Phase 1 — Scaffolding

### 1.1 `pubspec.yaml` — enable codegen

```yaml
flutter:
  generate: true   # ADD THIS LINE
  uses-material-design: true
  assets: ...
```

### 1.2 Create `l10n.yaml` at `chahriyti/`

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
preferred-supported-locales: ["ar", "fr", "en"]
```

### 1.3 Wire `app.dart`

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Remove: locale: const Locale('ar')
// Remove: supportedLocales: const [Locale('ar')]

// Add:
localizationsDelegates: AppLocalizations.localizationsDelegates,
supportedLocales: AppLocalizations.supportedLocales,
locale: context.watch<LocaleCubit>().state.locale,
```

### 1.4 `LocaleCubit`

```dart
// locale_state.dart
class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);
  @override List<Object> get props => [locale];
}

// locale_cubit.dart
class LocaleCubit extends Cubit<LocaleState> {
  static const _key = 'app_locale';

  LocaleCubit() : super(const LocaleState(Locale('ar')));

  Future<void> load() async {
    final stored = await secureStorage.read(key: _key);
    if (stored != null) emit(LocaleState(Locale(stored)));
  }

  Future<void> setLocale(Locale locale) async {
    await secureStorage.write(key: _key, value: locale.languageCode);
    emit(LocaleState(locale));
  }
}
```

Provide `LocaleCubit` above `MaterialApp` in `main.dart`.

### 1.5 Convenience extension

```dart
// lib/core/extensions/l10n_extension.dart
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

---

## Phase 2 — ARB Key Definitions

All keys defined in `app_en.arb` (template). `app_ar.arb` and `app_fr.arb` must contain identical keys with translated values.

### 2.1 Common / Shared

| Key | EN | FR | AR |
|-----|----|----|-----|
| `appName` | Chahriyti | Chahriyti | شهريتي |
| `cancel` | Cancel | Annuler | إلغاء |
| `save` | Save | Enregistrer | حفظ |
| `confirm` | Confirm | Confirmer | تأكيد |
| `delete` | Delete | Supprimer | حذف |
| `edit` | Edit | Modifier | تعديل |
| `retry` | Retry | Réessayer | إعادة المحاولة |
| `yes` | Yes | Oui | نعم |
| `no` | No | Non | لا |
| `amount` | Amount | Montant | المبلغ |
| `notes` | Notes | Notes | ملاحظات |
| `notesOptional` | Notes (optional) | Notes (optionnel) | ملاحظات (اختياري) |
| `enterValidAmount` | Enter a valid amount | Entrez un montant valide | أدخل مبلغاً صحيحاً |
| `amountRequired` | Amount is required | Montant requis | المبلغ مطلوب |
| `enterNumber` | Enter a valid number | Entrez un nombre valide | أدخل رقماً صحيحاً |
| `amountHint` | e.g. 50000 | ex. 50000 | مثال: 50000 |
| `unknown` | Unknown | Inconnu | غير معروف |
| `dangerZone` | Danger Zone | Zone de danger | منطقة الخطر |
| `importantWarning` | Important Warning | Avertissement | تحذير مهم |
| `areYouSure` | Are you sure? | Êtes-vous sûr ? | هل أنت متأكد تماماً؟ |
| `loading` | Loading... | Chargement... | جاري التحميل... |

### 2.2 Onboarding

| Key | EN | FR | AR |
|-----|----|----|-----|
| `splashTagline` | Before you increase your salary, know where it goes. | Avant d'augmenter votre salaire, sachez où il va. | قبل ما تزيد في راتبك، لازم تعرف وين راه يروح. |
| `getStarted` | Get Started | Commencer | ابدأ الآن |
| `valuePropTitle` | Benefits of Chahriyti | Avantages de Chahriyti | مزايا شهريتي |
| `valuePropSubtitle` | What will you gain from Chahriyti? | Que gagnerez-vous avec Chahriyti ? | ماذا ستستفيد من شهريتي؟ |
| `benefit1` | Track your daily expenses easily | Suivez vos dépenses quotidiennes | تتبع مصاريفك اليومية بسهولة |
| `benefit2` | Know your balance at any moment | Connaître votre solde à tout moment | معرفة رصيدك المتبقي في أي لحظة |
| `benefit3` | Calculate the safe amount to spend daily | Calculer le montant sûr à dépenser | حساب المبلغ الآمن للصرف يومياً |
| `benefit4` | Smart statistics on your financial habits | Statistiques intelligentes sur vos habitudes | إحصائيات ذكية لعاداتك المالية |
| `benefit5` | Weekly challenges to save more | Défis hebdomadaires pour économiser plus | تحديات أسبوعية لتوفير أكثر |
| `benefit6` | Manage your debts and savings goals | Gérez vos dettes et objectifs d'épargne | إدارة ديونك وأهدافك الادخارية |
| `benefit7` | Smart alerts before your balance runs out | Alertes intelligentes avant épuisement | تنبيهات ذكية قبل نفاد الرصيد |
| `valuePropQuote` | "Money you don't manage, manages you" | "L'argent que vous ne gérez pas vous gère" | "المال الذي لا تديره، يديرك" |
| `next` | Next | Suivant | متابعة |

### 2.3 Financial Setup

| Key | EN | FR | AR |
|-----|----|----|-----|
| `financialSetupTitle` | Set Up Your Financial Situation | Configurez votre situation financière | إعداد وضعك المالي |
| `financialSetupSubtitle` | Takes only 2 minutes.\nYou can edit it anytime later. | Prend 2 minutes seulement.\nModifiable à tout moment. | سيستغرق دقيقتين فقط.\nيمكنك التعديل لاحقًا في أي وقت. |
| `start` | Start | Démarrer | ابدأ |
| `balanceStepTitle` | How much money do you have now? | Combien d'argent avez-vous maintenant ? | كم من المال لديك الآن؟ |
| `balanceStepDesc` | Check your bank account, wallet, and cash. | Vérifiez votre compte bancaire et votre portefeuille. | تحقق من حسابك البنكي، محفظتك، والنقد المتوفر. |
| `balanceRequired` | Please enter your balance | Veuillez saisir votre solde | يرجى إدخال الرصيد |
| `savingsStepTitle` | How much do you have in savings? | Combien avez-vous en épargne ? | كم من المال لديك في المدخرات؟ |
| `debtsStepTitle` | Do you have any debts? | Avez-vous des dettes ? | هل لديك ديون؟ |
| `lendingsStepTitle` | Have you lent money to anyone? | Avez-vous prêté de l'argent ? | هل أقرضت أحداً مالاً؟ |
| `summaryStepTitle` | Summary | Récapitulatif | الملخص |
| `addDebt` | Add Debt | Ajouter une dette | إضافة دين |
| `addLending` | Add Lending | Ajouter un prêt | إضافة سلفة |
| `noDebts` | No debts added | Aucune dette ajoutée | لا توجد ديون |
| `noLendings` | No lendings added | Aucun prêt ajouté | لا توجد سلفات |
| `completeSetup` | Complete Setup | Terminer la configuration | إتمام الإعداد |

### 2.4 Activation

| Key | EN | FR | AR |
|-----|----|----|-----|
| `activationTitle` | Activate App | Activer l'application | تفعيل التطبيق |
| `editData` | Edit Data | Modifier les données | تعديل البيانات |
| `chahriytiNumber` | Chahriyti Number | Numéro Chahriyti | رقم شهريتي |
| `yourData` | Your Data | Vos données | بياناتك |
| `name` | Name | Nom | الاسم |
| `phone` | Phone | Téléphone | الهاتف |
| `wilaya` | Wilaya | Wilaya | الولاية |
| `haveActivationKey` | Do you have an activation key? | Avez-vous une clé d'activation ? | هل لديك مفتاح التفعيل؟ |
| `activationKeyDesc` | Scan the QR code or enter the key manually to activate the app. | Scannez le QR code ou entrez la clé manuellement. | امسح رمز QR أو أدخل المفتاح يدوياً لتفعيل التطبيق |
| `scanQrCode` | Scan QR Code | Scanner le QR Code | مسح رمز QR |
| `enterKeyManually` | Enter Key Manually | Saisir la clé manuellement | إدخال المفتاح يدوياً |
| `copiedChahriytiNumber` | Chahriyti number copied | Numéro Chahriyti copié | تم نسخ رقم شهريتي |
| `scanQrForLicense` | Scan QR for license | Scanner le QR de licence | امسح رمز QR للترخيص |
| `scanQrHint` | Point the camera at the QR code on the license card. | Pointez la caméra vers le QR code sur la carte de licence. | وجّه الكاميرا نحو رمز QR الموجود على بطاقة الترخيص |
| `licenseAlreadyUsed` | This license is used on another device | Cette licence est utilisée sur un autre appareil | هذا الترخيص مستخدم على جهاز آخر |
| `cannotOpenPage` | Could not open page | Impossible d'ouvrir la page | تعذر فتح الصفحة |
| `enterActivationKey` | Enter Activation Key | Saisir la clé d'activation | إدخال مفتاح التفعيل |
| `keyRequired` | Key is required | Clé requise | المفتاح مطلوب |
| `keyIncomplete` | Key is incomplete | Clé incomplète | المفتاح غير مكتمل |
| `activate` | Activate | Activer | تفعيل |
| `getChahriyti` | Get Chahriyti | Obtenir Chahriyti | احصل على شهريتي |

### 2.5 Home / Dashboard

| Key | EN | FR | AR |
|-----|----|----|-----|
| `deleteExpense` | Delete Expense | Supprimer la dépense | حذف المصروف |
| `deleteExpenseConfirm` | Delete this expense? | Supprimer cette dépense ? | هل تريد حذف هذا المصروف؟ |
| `safeBalance` | Safe Balance | Solde sécurisé | الرصيد الآمن |
| `totalBalance` | Total Balance | Solde total | إجمالي الرصيد |
| `salary` | Salary | Salaire | الراتب |
| `expenses` | Expenses | Dépenses | المصاريف |
| `addExpense` | Add Expense | Ajouter une dépense | إضافة مصروف |
| `noExpenses` | No expenses yet | Aucune dépense | لا توجد مصاريف بعد |
| `expenseDetails` | Expense Details | Détails de la dépense | تفاصيل المصروف |
| `spend` | Spend | Dépenser | صرف |

### 2.6 Expense

| Key | EN | FR | AR |
|-----|----|----|-----|
| `expenseTitle` | Title | Titre | العنوان |
| `expenseTitleRequired` | Title is required | Titre requis | العنوان مطلوب |
| `category` | Category | Catégorie | التصنيف |
| `selectCategory` | Select category | Sélectionner une catégorie | اختر التصنيف |
| `date` | Date | Date | التاريخ |
| `addNote` | Add a note... | Ajouter une note... | أضف ملاحظة... |
| `expenseAdded` | Expense added | Dépense ajoutée | تم إضافة المصروف |
| `expenseDeleted` | Expense deleted | Dépense supprimée | تم حذف المصروف |
| `expenseUpdated` | Expense updated | Dépense modifiée | تم تعديل المصروف |

### 2.7 Debt

| Key | EN | FR | AR |
|-----|----|----|-----|
| `newDebt` | New Debt | Nouvelle dette | دين جديد |
| `editDebt` | Edit Debt | Modifier la dette | تعديل الدين |
| `creditorName` | Creditor Name | Nom du créancier | اسم الدائن |
| `creditorNameHint` | e.g. Mohammed Ahmed | ex. Mohammed Ahmed | مثال: محمد أحمد |
| `creditorNameRequired` | Creditor name is required | Nom du créancier requis | اسم الدائن مطلوب |
| `totalDebtAmount` | Total Debt Amount | Montant total de la dette | المبلغ الكلي للدين |
| `enterAmount` | Enter amount | Entrez le montant | أدخل المبلغ |
| `addDebtNoteHint` | Add notes about the debt... | Ajoutez des notes sur la dette... | أضف ملاحظات عن الدين... |
| `saveDebt` | Save Debt | Enregistrer la dette | حفظ الدين |
| `saveEdit` | Save Edit | Enregistrer la modification | حفظ التعديل |
| `debtCreated` | Debt created successfully | Dette créée avec succès | تم إنشاء الدين بنجاح |
| `debtUpdated` | Debt updated successfully | Dette modifiée avec succès | تم تعديل الدين بنجاح |
| `debtDeleted` | Debt deleted | Dette supprimée | تم حذف الدين |
| `makePayment` | Make Payment | Effectuer un paiement | تسجيل دفعة |
| `remainingAmount` | Remaining Amount | Montant restant | المبلغ المتبقي |
| `paidAmount` | Paid Amount | Montant payé | المبلغ المدفوع |
| `debtFullyPaid` | Debt fully paid | Dette entièrement remboursée | تم سداد الدين بالكامل |

### 2.8 Lending

| Key | EN | FR | AR |
|-----|----|----|-----|
| `newLending` | New Lending | Nouveau prêt | سلفة جديدة |
| `editLending` | Edit Lending | Modifier le prêt | تعديل السلفة |
| `borrowerName` | Borrower Name | Nom de l'emprunteur | اسم المقترض |
| `borrowerNameHint` | e.g. Ahmed | ex. Ahmed | مثال: أحمد |
| `borrowerNameRequired` | Borrower name is required | Nom de l'emprunteur requis | اسم المقترض مطلوب |
| `lendingAmount` | Lending Amount | Montant du prêt | مبلغ السلفة |
| `addLendingNoteHint` | Add notes about the lending... | Ajoutez des notes sur le prêt... | أضف ملاحظات عن السلفة... |
| `saveLending` | Register Lending | Enregistrer le prêt | تسجيل السلفة |
| `lendingCreated` | Lending registered successfully | Prêt enregistré avec succès | تم تسجيل السلفة بنجاح |
| `lendingUpdated` | Lending updated successfully | Prêt modifié avec succès | تم تعديل السلفة بنجاح |
| `lendingDeleted` | Lending deleted | Prêt supprimé | تم حذف السلفة |
| `insufficientFunds` | Insufficient balance and savings | Solde et épargne insuffisants | الرصيد والمدخرات غير كافية |
| `insufficientSavings` | Insufficient savings balance | Solde d'épargne insuffisant | رصيد المدخرات غير كافٍ |
| `collectPayment` | Collect Payment | Collecter un paiement | تسجيل تحصيل |
| `lendingFullyCollected` | Lending fully collected | Prêt entièrement collecté | تم تحصيل السلفة بالكامل |

### 2.9 Goal

| Key | EN | FR | AR |
|-----|----|----|-----|
| `newGoal` | New Goal | Nouvel objectif | هدف جديد |
| `editGoal` | Edit Goal | Modifier l'objectif | تعديل الهدف |
| `goalName` | Goal Name | Nom de l'objectif | اسم الهدف |
| `goalNameHint` | e.g. Buy a phone | ex. Acheter un téléphone | مثال: شراء هاتف |
| `goalNameRequired` | Name is required | Nom requis | الاسم مطلوب |
| `targetAmount` | Target Amount | Montant cible | المبلغ المستهدف |
| `goalDescHint` | Add notes... | Ajoutez des notes... | أضف ملاحظات... |
| `saveGoal` | Save Goal | Enregistrer l'objectif | حفظ الهدف |
| `goalCreated` | Goal created successfully | Objectif créé avec succès | تم إنشاء الهدف بنجاح |
| `goalUpdated` | Goal updated successfully | Objectif modifié avec succès | تم تعديل الهدف بنجاح |
| `goalDeleted` | Goal deleted | Objectif supprimé | تم حذف الهدف |
| `contributeToGoal` | Contribute to Goal | Contribuer à l'objectif | المساهمة في الهدف |
| `goalAchieved` | Goal achieved! | Objectif atteint ! | تم تحقيق الهدف! |
| `goalProgress` | Progress | Progression | التقدم |

### 2.10 Savings

| Key | EN | FR | AR |
|-----|----|----|-----|
| `savingsTitle` | Savings | Épargne | المدخرات |
| `withdrawToBalance` | Withdraw to Balance | Retirer vers solde | سحب للرصيد |
| `depositFromBalance` | Deposit from Balance | Déposer depuis solde | إيداع من الرصيد |
| `totalSavings` | Total Savings | Épargne totale | إجمالي المدخرات |
| `transactionHistory` | Transaction History | Historique | سجل العمليات |
| `noSavingsYet` | No savings transactions yet | Aucune transaction d'épargne | لا توجد عمليات ادخار بعد |
| `savingsAutoHint` | Savings will be added automatically at the end of the financial cycle. | L'épargne sera ajoutée automatiquement à la fin du cycle. | سيتم إضافة المدخرات تلقائياً عند انتهاء الدورة المالية |
| `depositToSavings` | Deposit to Savings | Déposer dans l'épargne | إيداع في المدخرات |
| `availableBalance` | Available Balance | Solde disponible | الرصيد المتاح |
| `availableSavings` | Available Savings | Épargne disponible | المدخرات المتاحة |
| `confirmDeposit` | Confirm Deposit | Confirmer le dépôt | تأكيد الإيداع |
| `confirmWithdrawal` | Confirm Withdrawal | Confirmer le retrait | تأكيد السحب |
| `amountExceedsAvailable` | Amount exceeds available | Montant dépasse le disponible | المبلغ يتجاوز المتاح |

### 2.11 History

| Key | EN | FR | AR |
|-----|----|----|-----|
| `historyTitle` | Expense History | Historique des dépenses | سجل المصاريف |
| `filterByCategory` | Filter by category | Filtrer par catégorie | تصفية حسب الفئة |
| `allCategories` | All Categories | Toutes les catégories | كل التصنيفات |
| `noHistory` | No expense history | Aucun historique | لا يوجد سجل |
| `totalSpent` | Total Spent | Total dépensé | إجمالي المنصرف |

### 2.12 Insights

| Key | EN | FR | AR |
|-----|----|----|-----|
| `insightsTitle` | Financial Insights | Perspectives financières | البصائر المالية |
| `financialLeaks` | Financial Leaks | Fuites financières | التسربات المالية |
| `monthlyTrends` | Monthly Trends | Tendances mensuelles | الاتجاهات الشهرية |
| `spendingByCategory` | Spending by Category | Dépenses par catégorie | المصاريف حسب التصنيف |
| `financialClassification` | Financial Classification | Classification financière | التصنيف المالي |
| `monthlyComparison` | Monthly Comparison | Comparaison mensuelle | المقارنة الشهرية |
| `noInsights` | No insights yet | Aucune perspective | لا توجد بيانات بعد |

### 2.13 Settings

| Key | EN | FR | AR |
|-----|----|----|-----|
| `settingsTitle` | Settings | Paramètres | الإعدادات |
| `dataClearedSuccess` | All data cleared successfully | Toutes les données supprimées | تم مسح جميع البيانات بنجاح |
| `resetting` | Resetting... | Réinitialisation... | جاري إعادة التعيين... |
| `activated` | Activated | Activée | مفعّل |
| `notActivated` | Not Activated | Non activée | غير مفعّل |
| `monthlySalary` | Monthly Salary | Salaire mensuel | الراتب الشهري |
| `fromNextCycle` | From next cycle | Dès le prochain cycle | من الدورة القادمة |
| `salaryDay` | Salary Day | Jour de salaire | يوم استلام الراتب |
| `dayN` | Day {day} | Jour {day} | اليوم {day} |
| `goalsAndDebts` | Goals & Debts | Objectifs & Dettes | الأهداف والديون |
| `goalsAndDebtsDesc` | Manage your financial goals and debts | Gérez vos objectifs financiers et vos dettes | إدارة أهدافك المالية والديون |
| `viewGoals` | View Goals | Voir les objectifs | عرض الأهداف |
| `viewDebts` | View Debts | Voir les dettes | عرض الديون |
| `savings` | Savings | Épargne | المدخرات |
| `manageCycle` | Manage Financial Cycle | Gérer le cycle financier | إدارة الدورة المالية |
| `manageCycleDesc` | Cycle starts automatically on your salary day each month. | Le cycle commence automatiquement le jour de votre salaire. | تبدأ الدورة تلقائياً في يوم استلام راتبك كل شهر |
| `cycleHistory` | Cycle History | Historique des cycles | سجل الدورات |
| `dangerZoneDesc` | These actions cannot be undone. Make sure before continuing. | Ces actions sont irréversibles. Assurez-vous avant de continuer. | هذه الإجراءات لا يمكن التراجع عنها. تأكد تماماً قبل المتابعة. |
| `clearAllData` | Clear All Data | Effacer toutes les données | مسح كل البيانات |
| `appVersion` | Chahriyti - Version 1.0.0 | Chahriyti - Version 1.0.0 | شهريتي - الإصدار 1.0.0 |
| `yesDeleteEverything` | Yes, delete everything | Oui, tout supprimer | نعم، امسح كل شيء |
| `editSalaryDay` | Edit Salary Day | Modifier le jour de salaire | تعديل يوم استلام الراتب |
| `chooseDayHint` | Choose a day from 1 to 28 | Choisissez un jour de 1 à 28 | اختر يوم من 1 إلى 28 |
| `selectedDay` | Selected day: {day} of each month | Jour sélectionné : {day} de chaque mois | اليوم المختار: {day} من كل شهر |
| `appliesFromNextCycle` | Will apply from next cycle | S'appliquera dès le prochain cycle | سيُطبَّق من الدورة القادمة |
| `confirmEditSalaryDay` | Confirm salary day change | Confirmer le changement du jour de salaire | تأكيد تعديل يوم الراتب |
| `editMonthlySalary` | Edit Monthly Salary | Modifier le salaire mensuel | تعديل الراتب الشهري |
| `enterNewSalary` | Enter new salary | Entrez le nouveau salaire | أدخل الراتب الجديد |
| `salaryRequired` | Salary is required | Salaire requis | الراتب مطلوب |
| `salaryMustBePositive` | Salary must be greater than zero | Le salaire doit être supérieur à zéro | يجب أن يكون الراتب أكبر من صفر |
| `confirmEditSalary` | Confirm salary change | Confirmer la modification du salaire | تأكيد تعديل الراتب |
| `language` | Language | Langue | اللغة |
| `languageAr` | العربية | العربية | العربية |
| `languageFr` | Français | Français | Français |
| `languageEn` | English | English | English |

### 2.14 Categories (50+ strings)

> Note: Category names must be localized. The `categories.dart` constant file must be refactored to remove hardcoded Arabic strings. Categories should use string keys, resolved via `AppLocalizations` at render time.

| Key | EN | FR | AR |
|-----|----|----|-----|
| `catEssentials` | Essentials | Essentiels | الضروريات |
| `catHomeFamily` | Home & Family | Maison & Famille | البيت والعائلة |
| `catLuxuries` | Luxuries | Luxes | الكماليات |
| `catHealth` | Health | Santé | الصحة |
| `catTransport` | Transport | Transport | التنقل |
| `catClothing` | Clothing | Vêtements | الملابس |
| `catRestaurants` | Restaurants | Restaurants | المطاعم |
| `catEducation` | Education | Éducation | التعليم |
| `catOther` | Other | Autre | أخرى |
| `catFood` | Food | Alimentation | الطعام |
| `catBills` | Bills | Factures | الفواتير |
| `catGroceries` | Groceries | Épicerie | البقالة |
| `catElectricity` | Electricity | Électricité | الكهرباء |
| `catWater` | Water | Eau | الماء |
| `catGas` | Gas | Gaz | الغاز |
| `catInternet` | Internet | Internet | الإنترنت |
| `catPhone` | Phone | Téléphone | الهاتف |
| `catRent` | Rent | Loyer | الإيجار |
| `catMedicine` | Medicine | Médicaments | الدواء |
| `catDoctor` | Doctor | Médecin | الطبيب |
| `catFuel` | Fuel | Carburant | الوقود |
| `catPublicTransport` | Public Transport | Transport en commun | المواصلات |
| `catSchool` | School | École | المدرسة |
| `catUniversity` | University | Université | الجامعة |
| `catBooks` | Books | Livres | الكتب |
| `catCoffee` | Coffee | Café | القهوة |
| `catFastFood` | Fast Food | Restauration rapide | الأكل السريع |
| `catEntertainment` | Entertainment | Divertissement | الترفيه |
| `catSubscriptions` | Subscriptions | Abonnements | الاشتراكات |
| `catSports` | Sports | Sport | الرياضة |
| `catPersonalCare` | Personal Care | Soin personnel | العناية الشخصية |
| `catGifts` | Gifts | Cadeaux | الهدايا |
| `catTravel` | Travel | Voyage | السفر |
| `catShopping` | Shopping | Shopping | التسوق |
| `catElectronics` | Electronics | Électronique | الإلكترونيات |
| `catMaintenance` | Maintenance | Entretien | الصيانة |
| `catChildcare` | Childcare | Garde d'enfants | رعاية الأطفال |

### 2.15 Notifications (52 strings)

All notification title/body strings in `notification_messages.dart` must be migrated to ARB keys and resolved before scheduling.

| Key | EN | FR | AR |
|-----|----|----|-----|
| `notifGoalCompletedTitle` | Goal Achieved! 🎉 | Objectif atteint ! 🎉 | تم تحقيق هدفك! 🎉 |
| `notifGoalCompletedBody` | You reached your goal: {name} | Vous avez atteint votre objectif : {name} | وصلت إلى هدفك: {name} |
| `notifGoalNearTitle` | Almost There! | Presque là ! | أوشكت على تحقيق هدفك! |
| `notifDebtPaidTitle` | Debt Cleared! 💪 | Dette remboursée ! 💪 | تم سداد الدين! 💪 |
| `notifDebtNearTitle` | Almost Debt-Free! | Presque sans dettes ! | أوشكت على سداد الدين! |
| `notifChallengeCompletedTitle` | Challenge Completed! 🏆 | Défi complété ! 🏆 | تم إنجاز التحدي! 🏆 |
| `notifChallengeNearTitle` | Challenge Almost Done! | Défi presque terminé ! | أوشكت على إتمام التحدي! |
| `notifWeeklySummaryTitle` | Weekly Summary | Résumé hebdomadaire | ملخص الأسبوع |
| `notifInsightTitle` | New Insight! 💡 | Nouvelle perspective ! 💡 | اكتشاف جديد! 💡 |
| `notifLowBalanceTitle` | Low Balance Warning ⚠️ | Alerte solde faible ⚠️ | تحذير: رصيد منخفض ⚠️ |
| `notifSavingsTitle` | Savings Achievement! 💰 | Succès d'épargne ! 💰 | إنجاز مدخرات! 💰 |
| `notifZeroDebtTitle` | Zero Debt! 🎊 | Zéro dette ! 🎊 | لا ديون! 🎊 |
| *(remaining pairs)* | *(translate similarly)* | | |

### 2.16 Wilayas (58 strings)

Wilayas are proper nouns — Arabic names are the official reference. English/French transliterations are used for non-Arabic locales.

Strategy: keep `wilayas.dart` but add a `wilayas_en.dart` and `wilayas_fr.dart` (or include in ARB as `wilaya_01` through `wilaya_58`). Render by index, not string key.

| Key pattern | AR | EN/FR |
|-------------|-----|-------|
| `wilaya_01` | أدرار | Adrar |
| `wilaya_02` | الشلف | Chlef |
| `wilaya_03` | الأغواط | Laghouat |
| `wilaya_16` | الجزائر | Algiers / Alger |
| `wilaya_31` | وهران | Oran |
| *(all 58)* | | |

---

## Phase 3 — Language Switcher UI

Add language selector to **Settings** page.

```
Settings
  └── Language / اللغة / Langue
        ├── العربية  ← radio
        ├── Français ← radio
        └── English  ← radio
```

On selection:
1. `LocaleCubit.setLocale(Locale(code))` 
2. Persist to secure storage
3. `MaterialApp` rebuilds with new locale
4. Text direction flips automatically for AR (RTL) vs FR/EN (LTR)

---

## Phase 4 — RTL / LTR Layout Audit

Arabic is RTL. French and English are LTR. Switching locale flips text direction automatically via Flutter's `Directionality` widget. However, manually-set layout widgets need review:

| Issue | Fix |
|-------|-----|
| Hardcoded `TextAlign.right` | Replace with `TextAlign.start` |
| Hardcoded `EdgeInsets.only(left:)` for icon padding | Replace with `EdgeInsetsDirectional.only(start:)` |
| Row children order assuming LTR | Wrap with `Directionality`-aware ordering |
| `Icon` + `Text` rows | Use `Row` with `MainAxisAlignment.start`, let direction handle it |

---

## Phase 5 — Number & Currency Formatting

Algerian Dinar (DZD). All money formatting via existing `money_extensions.dart`.

- Numbers: `intl` `NumberFormat` — already handles locale-specific separators
- Currency symbol: stays as `دج` for AR, `DA` for FR/EN (or configurable)
- Date format: `dd/MM/yyyy` stays consistent across locales

Update `money_extensions.dart` to accept locale or use `Intl.defaultLocale`.

---

## Phase 6 — Implementation Order (by file)

Work feature by feature. Mark each file done as strings are extracted.

### Batch 1 — Infrastructure
- [ ] `pubspec.yaml` — add `generate: true`
- [ ] `l10n.yaml` — create at project root
- [ ] `lib/l10n/app_en.arb` — create with all keys from Phase 2
- [ ] `lib/l10n/app_fr.arb` — translate all keys
- [ ] `lib/l10n/app_ar.arb` — move existing strings to keys
- [ ] `lib/presentation/settings/cubits/locale_cubit.dart` — create
- [ ] `lib/core/extensions/l10n_extension.dart` — create
- [ ] `lib/app.dart` — wire `LocaleCubit` + `AppLocalizations`
- [ ] `lib/main.dart` — provide `LocaleCubit` above `MaterialApp`

### Batch 2 — Onboarding & Activation
- [ ] `presentation/onboarding/pages/splash_page.dart`
- [ ] `presentation/onboarding/pages/value_proposition_page.dart`
- [ ] `presentation/activation/pages/activation_page.dart`
- [ ] `presentation/activation/widgets/license_key_dialog.dart`

### Batch 3 — Financial Setup
- [ ] `presentation/financial_setup/widgets/welcome_step_widget.dart`
- [ ] `presentation/financial_setup/widgets/balance_step_widget.dart`
- [ ] `presentation/financial_setup/widgets/savings_step_widget.dart`
- [ ] `presentation/financial_setup/widgets/debts_step_widget.dart`
- [ ] `presentation/financial_setup/widgets/lendings_step_widget.dart`
- [ ] `presentation/financial_setup/widgets/summary_step_widget.dart`

### Batch 4 — Core CRUD Features
- [ ] `presentation/expense/pages/add_expense_page.dart`
- [ ] `presentation/debt/pages/add_debt_page.dart`
- [ ] `presentation/goal/pages/add_goal_page.dart`
- [ ] `presentation/lending/pages/add_lending_page.dart`
- [ ] `presentation/savings/pages/savings_page.dart`

### Batch 5 — Secondary Screens
- [ ] `presentation/home/pages/home_page.dart`
- [ ] `presentation/history/pages/expense_history_page.dart`
- [ ] `presentation/insights/pages/insights_page.dart`

### Batch 6 — Settings
- [ ] `presentation/settings/pages/settings_page.dart`
- [ ] Add language switcher section

### Batch 7 — Constants Refactor
- [ ] `core/constants/categories.dart` — replace Arabic strings with l10n keys
- [ ] `core/constants/notification_messages.dart` — parameterize with locale
- [ ] `core/constants/wilayas.dart` — add indexed multilingual map

### Batch 8 — Layout & Polish
- [ ] RTL/LTR audit (replace hardcoded `left`/`right` with directional equivalents)
- [ ] Money formatting locale-aware update
- [ ] Test language switch persists across app restarts

---

## ARB File Structure Example

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appName": "Chahriyti",
  "@appName": { "description": "Application name" },

  "cancel": "Cancel",
  "@cancel": { "description": "Cancel button label" },

  "dayN": "Day {day}",
  "@dayN": {
    "description": "Dynamic day label",
    "placeholders": {
      "day": { "type": "int" }
    }
  },

  "notifGoalCompletedBody": "You reached your goal: {name}",
  "@notifGoalCompletedBody": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
}
```

---

## Testing Checklist

- [ ] All 3 locales render without missing keys
- [ ] Language switch in settings persists after app restart
- [ ] RTL (AR) layout correct — no clipped text, no misaligned icons
- [ ] LTR (FR/EN) layout correct — no RTL artifacts
- [ ] Categories display translated names
- [ ] Notifications use correct language at time of scheduling
- [ ] Validators show translated error messages
- [ ] Dynamic strings with placeholders render correctly (salary day, goal names)
- [ ] Number formatting correct per locale
- [ ] No hardcoded Arabic strings remain in widget tree

---

## Estimated String Count

| Source | Keys |
|--------|------|
| Common/Shared | 21 |
| Onboarding | 14 |
| Financial Setup | 15 |
| Activation | 22 |
| Home/Dashboard | 10 |
| Expense | 9 |
| Debt | 17 |
| Lending | 16 |
| Goal | 14 |
| Savings | 13 |
| History | 5 |
| Insights | 7 |
| Settings | 30 |
| Categories | 37 |
| Notifications | 26 |
| Wilayas | 58 |
| **Total** | **~314 keys** |
