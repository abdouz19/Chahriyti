import '../../infrastructure/database/app_database.dart';
import '../../infrastructure/database/daos/users_dao.dart';
import '../../infrastructure/database/daos/cycles_dao.dart';
import '../../infrastructure/database/daos/expenses_dao.dart';
import '../../infrastructure/database/daos/debts_dao.dart';
import '../../infrastructure/database/daos/goals_dao.dart';
import '../../infrastructure/database/daos/incomes_dao.dart';
import '../../infrastructure/database/daos/insights_dao.dart';
import '../../infrastructure/database/daos/challenges_dao.dart';
import '../../infrastructure/database/daos/lendings_dao.dart';
import '../../infrastructure/database/daos/savings_dao.dart';
import '../../infrastructure/repositories/lending_repository_impl.dart';
import '../../infrastructure/repositories/savings_repository_impl.dart';
import '../../domain/repositories/lending_repository.dart';
import '../../domain/repositories/savings_repository.dart';
import '../../application/use_cases/savings/get_savings_balance_use_case.dart';
import '../../application/use_cases/savings/get_savings_history_use_case.dart';
import '../../application/use_cases/savings/deposit_cycle_savings_use_case.dart';
import '../../application/use_cases/savings/withdraw_savings_use_case.dart';
import '../../application/use_cases/savings/deposit_salary_split_use_case.dart';
import '../../application/use_cases/savings/deposit_from_balance_use_case.dart';
import '../../application/use_cases/savings/withdraw_to_balance_use_case.dart';
import '../../infrastructure/repositories/user_repository_impl.dart';
import '../../infrastructure/repositories/cycle_repository_impl.dart';
import '../../infrastructure/repositories/expense_repository_impl.dart';
import '../../infrastructure/repositories/debt_repository_impl.dart';
import '../../infrastructure/repositories/goal_repository_impl.dart';
import '../../infrastructure/repositories/income_repository_impl.dart';
import '../../infrastructure/repositories/insight_repository_impl.dart';
import '../../infrastructure/repositories/challenge_repository_impl.dart';
import '../../infrastructure/services/device_info_service.dart';
import '../../infrastructure/services/secure_storage_service.dart';
import '../../infrastructure/services/license_service.dart';
import '../../infrastructure/services/notification_service.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../domain/repositories/income_repository.dart';
import '../../domain/repositories/insight_repository.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../application/use_cases/onboarding/add_initial_income_use_case.dart';
import '../../application/use_cases/activation/get_device_id_use_case.dart';
import '../../application/use_cases/activation/validate_license_use_case.dart';
import '../../application/use_cases/activation/compose_whatsapp_message_use_case.dart';
import '../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../application/use_cases/dashboard/get_safe_balance_use_case.dart';
import '../../application/use_cases/expense/add_expense_use_case.dart';
import '../../application/use_cases/expense/edit_expense_use_case.dart';
import '../../application/use_cases/expense/delete_expense_use_case.dart';
import '../../application/use_cases/expense/get_expenses_use_case.dart';
import '../../application/use_cases/income/add_income_use_case.dart';
import '../../application/use_cases/debt/add_debt_payment_use_case.dart';
import '../../application/use_cases/debt/calculate_remaining_balance_use_case.dart';
import '../../application/use_cases/debt/create_debt_use_case.dart';
import '../../application/use_cases/debt/delete_debt_use_case.dart';
import '../../application/use_cases/debt/get_debts_use_case.dart';
import '../../application/use_cases/debt/update_debt_use_case.dart';
import '../../application/use_cases/goal/calculate_goal_progress_use_case.dart';
import '../../application/use_cases/goal/create_goal_use_case.dart';
import '../../application/use_cases/goal/delete_goal_use_case.dart';
import '../../application/use_cases/goal/get_goals_use_case.dart';
import '../../application/use_cases/goal/update_goal_use_case.dart';
import '../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../application/use_cases/insights/calculate_financial_classification_use_case.dart' as insight_classification;
import '../../application/use_cases/insights/detect_financial_leaks_use_case.dart' as insight_leaks;
import '../../application/use_cases/insights/generate_spending_trends_use_case.dart';
import '../../application/use_cases/cycle/reset_app_data_use_case.dart';
import '../../application/use_cases/cycle/check_and_start_cycle_use_case.dart';
import '../../domain/entities/financial_cycle_entity.dart';
import '../../application/use_cases/challenge/generate_weekly_challenge_use_case.dart';
import '../../application/use_cases/challenge/get_active_challenge_use_case.dart';
import '../../application/use_cases/challenge/calculate_challenge_progress_use_case.dart';
import '../../application/use_cases/lending/create_lending_use_case.dart';
import '../../application/use_cases/lending/get_lendings_use_case.dart';
import '../../application/use_cases/lending/add_lending_collection_use_case.dart';
import '../../application/use_cases/lending/delete_lending_use_case.dart';
import '../../application/use_cases/lending/update_lending_use_case.dart';
import '../../application/use_cases/income/update_income_use_case.dart';
import '../../application/use_cases/income/delete_income_use_case.dart';
import '../../application/use_cases/financial_setup/add_initial_debt_use_case.dart';
import '../../application/use_cases/financial_setup/add_initial_lending_use_case.dart';
import '../../application/use_cases/financial_setup/complete_financial_setup_use_case.dart';
import '../../application/use_cases/financial_setup/delete_initial_debt_use_case.dart';
import '../../application/use_cases/financial_setup/delete_initial_lending_use_case.dart';
import '../../application/use_cases/financial_setup/edit_initial_debt_use_case.dart';
import '../../application/use_cases/financial_setup/edit_initial_lending_use_case.dart';
import '../../application/use_cases/financial_setup/get_financial_setup_step_use_case.dart';
import '../../application/use_cases/financial_setup/get_setup_summary_use_case.dart';
import '../../application/use_cases/financial_setup/set_initial_balance_use_case.dart';
import '../../application/use_cases/financial_setup/set_initial_savings_use_case.dart';
import '../../application/use_cases/notification/generate_notification_use_case.dart';
import '../../presentation/financial_setup/cubits/financial_setup_cubit.dart';

abstract final class Injection {
  static late final AppDatabase _database;
  static late final DeviceInfoService _deviceInfoService;
  static late final SecureStorageService _secureStorageService;
  static late final LicenseService _licenseService;

  // DAOs
  static late final UsersDao _usersDao;
  static late final CyclesDao _cyclesDao;
  static late final ExpensesDao _expensesDao;
  static late final DebtsDao _debtsDao;
  static late final GoalsDao _goalsDao;
  static late final IncomesDao _incomesDao;
  static late final InsightsDao _insightsDao;
  static late final ChallengesDao _challengesDao;
  static late final SavingsDao _savingsDao;
  static late final LendingsDao _lendingsDao;

  // Repositories
  static late final UserRepository userRepository;
  static late final CycleRepository cycleRepository;
  static late final ExpenseRepository expenseRepository;
  static late final DebtRepository debtRepository;
  static late final GoalRepository goalRepository;
  static late final IncomeRepository incomeRepository;
  static late final InsightRepository insightRepository;
  static late final ChallengeRepository challengeRepository;
  static late final SavingsRepository savingsRepository;
  static late final LendingRepository lendingRepository;

  // Services
  static DeviceInfoService get deviceInfoService => _deviceInfoService;
  static SecureStorageService get secureStorageService => _secureStorageService;
  static LicenseService get licenseService => _licenseService;
  static AppDatabase get database => _database;
  static late final NotificationService notificationService;

  // Use Cases — Onboarding
  static late final SetupSalaryUseCase setupSalaryUseCase;
  static late final AddInitialIncomeUseCase addInitialIncomeUseCase;

  // Use Cases — Activation
  static late final GetDeviceIdUseCase getDeviceIdUseCase;
  static late final ValidateLicenseUseCase validateLicenseUseCase;
  static late final ComposeWhatsAppMessageUseCase composeWhatsAppMessageUseCase;

  // Use Cases — Dashboard
  static late final GetDashboardDataUseCase getDashboardDataUseCase;
  static late final GetSafeBalanceUseCase getSafeBalanceUseCase;

  // Use Cases — Expense
  static late final AddExpenseUseCase addExpenseUseCase;
  static late final EditExpenseUseCase editExpenseUseCase;
  static late final DeleteExpenseUseCase deleteExpenseUseCase;
  static late final GetExpensesUseCase getExpensesUseCase;

  // Use Cases — Income
  static late final AddIncomeUseCase addIncomeUseCase;
  static late final UpdateIncomeUseCase updateIncomeUseCase;
  static late final DeleteIncomeUseCase deleteIncomeUseCase;

  // Use Cases — Debt
  static late final CreateDebtUseCase createDebtUseCase;
  static late final GetDebtsUseCase getDebtsUseCase;
  static late final UpdateDebtUseCase updateDebtUseCase;
  static late final DeleteDebtUseCase deleteDebtUseCase;
  static late final AddDebtPaymentUseCase addPaymentUseCase;
  static late final CalculateRemainingBalanceUseCase calculateRemainingBalanceUseCase;

  // Use Cases — Goal
  static late final CreateGoalUseCase createGoalUseCase;
  static late final GetGoalsUseCase getGoalsUseCase;
  static late final UpdateGoalUseCase updateGoalUseCase;
  static late final DeleteGoalUseCase deleteGoalUseCase;
  static late final CalculateGoalProgressUseCase calculateGoalProgressUseCase;

  // Use Cases — Statistics
  static late final GetCategoryBreakdownUseCase getCategoryBreakdownUseCase;
  static late final GetMonthlyComparisonUseCase getMonthlyComparisonUseCase;
  static late final GetFinancialClassificationUseCase getFinancialClassificationUseCase;

  // Use Cases — Insights
  static late final insight_classification.CalculateFinancialClassificationUseCase
      calculateFinancialClassificationUseCase;
  static late final insight_leaks.DetectLeaksUseCase detectLeaksUseCase;
  static late final GenerateSpendingTrendsUseCase generateTrendsUseCase;

  // Public getters for InsightsCubit
  static insight_leaks.DetectLeaksUseCase get leaksUseCase => detectLeaksUseCase;
  static GenerateSpendingTrendsUseCase get trendsUseCase => generateTrendsUseCase;

  // Use Cases — Cycle
  static late final ResetAppDataUseCase resetAppDataUseCase;
  static late final CheckAndStartCycleUseCase checkAndStartCycleUseCase;

  // Pending cycle for salary split (set by auto-cycle detection in router)
  static FinancialCycleEntity? pendingCycleForSplit;

  // Cubit factory — creates new instance each time (not singleton)
  static FinancialSetupCubit get financialSetupCubit => FinancialSetupCubit(
        getStepUseCase: getFinancialSetupStepUseCase,
        setBalanceUseCase: setInitialBalanceUseCase,
        setSavingsUseCase: setInitialSavingsUseCase,
        addDebtUseCase: addInitialDebtUseCase,
        editDebtUseCase: editInitialDebtUseCase,
        deleteDebtUseCase: deleteInitialDebtUseCase,
        addLendingUseCase: addInitialLendingUseCase,
        editLendingUseCase: editInitialLendingUseCase,
        deleteLendingUseCase: deleteInitialLendingUseCase,
        completeUseCase: completeFinancialSetupUseCase,
        getSummaryUseCase: getSetupSummaryUseCase,
        userRepository: userRepository,
        debtRepository: debtRepository,
        lendingRepository: lendingRepository,
      );

  // Use Cases — Challenge
  static late final GenerateWeeklyChallengeUseCase generateWeeklyChallengeUseCase;
  static late final GetActiveChallengeUseCase getActiveChallengeUseCase;
  static late final CalculateChallengeProgressUseCase calculateChallengeProgressUseCase;

  // Use Cases — Notification
  static late final GenerateNotificationUseCase generateNotificationUseCase;

  // Use Cases — Savings
  static late final GetSavingsBalanceUseCase getSavingsBalanceUseCase;
  static late final GetSavingsHistoryUseCase getSavingsHistoryUseCase;
  static late final DepositCycleSavingsUseCase depositCycleSavingsUseCase;
  static late final WithdrawSavingsUseCase withdrawSavingsUseCase;
  static late final DepositFromBalanceUseCase depositFromBalanceUseCase;
  static late final WithdrawToBalanceUseCase withdrawToBalanceUseCase;
  static late final DepositSalarySplitUseCase depositSalarySplitUseCase;

  // Use Cases — Financial Setup
  static late final GetFinancialSetupStepUseCase getFinancialSetupStepUseCase;
  static late final SetInitialBalanceUseCase setInitialBalanceUseCase;
  static late final SetInitialSavingsUseCase setInitialSavingsUseCase;
  static late final AddInitialDebtUseCase addInitialDebtUseCase;
  static late final EditInitialDebtUseCase editInitialDebtUseCase;
  static late final DeleteInitialDebtUseCase deleteInitialDebtUseCase;
  static late final AddInitialLendingUseCase addInitialLendingUseCase;
  static late final EditInitialLendingUseCase editInitialLendingUseCase;
  static late final DeleteInitialLendingUseCase deleteInitialLendingUseCase;
  static late final CompleteFinancialSetupUseCase completeFinancialSetupUseCase;
  static late final GetSetupSummaryUseCase getSetupSummaryUseCase;

  // Use Cases — Lending
  static late final CreateLendingUseCase createLendingUseCase;
  static late final GetLendingsUseCase getLendingsUseCase;
  static late final AddLendingCollectionUseCase addLendingCollectionUseCase;
  static late final DeleteLendingUseCase deleteLendingUseCase;
  static late final UpdateLendingUseCase updateLendingUseCase;

  static Future<void> init() async {
    // Database
    _database = AppDatabase();

    // DAOs
    _usersDao = UsersDao(_database);
    _cyclesDao = CyclesDao(_database);
    _expensesDao = ExpensesDao(_database);
    _debtsDao = DebtsDao(_database);
    _goalsDao = GoalsDao(_database);
    _incomesDao = IncomesDao(_database);
    _insightsDao = InsightsDao(_database);
    _challengesDao = ChallengesDao(_database);
    _savingsDao = SavingsDao(_database);
    _lendingsDao = LendingsDao(_database);

    // Services
    _deviceInfoService = DeviceInfoService();
    _secureStorageService = SecureStorageService();
    _licenseService = LicenseService();

    // Repositories
    userRepository = UserRepositoryImpl(_usersDao);
    cycleRepository = CycleRepositoryImpl(_cyclesDao);
    expenseRepository = ExpenseRepositoryImpl(_expensesDao);
    debtRepository = DebtRepositoryImpl(_debtsDao, cycleRepository);
    goalRepository = GoalRepositoryImpl(_goalsDao);
    incomeRepository = IncomeRepositoryImpl(_incomesDao);
    insightRepository = InsightRepositoryImpl(_insightsDao);
    challengeRepository = ChallengeRepositoryImpl(_challengesDao);
    savingsRepository = SavingsRepositoryImpl(_savingsDao);
    lendingRepository = LendingRepositoryImpl(_lendingsDao);

    // Use Cases — Onboarding
    setupSalaryUseCase = SetupSalaryUseCase(userRepository, cycleRepository);
    addInitialIncomeUseCase = AddInitialIncomeUseCase(cycleRepository, incomeRepository);

    // Use Cases — Activation
    getDeviceIdUseCase = GetDeviceIdUseCase(_deviceInfoService);
    validateLicenseUseCase = ValidateLicenseUseCase(_licenseService, userRepository);
    composeWhatsAppMessageUseCase = ComposeWhatsAppMessageUseCase();

    // Use Cases — Dashboard
    getDashboardDataUseCase = GetDashboardDataUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
      debtRepository: debtRepository,
      lendingRepository: lendingRepository,
    );
    getSafeBalanceUseCase = const GetSafeBalanceUseCase();

    // Use Cases — Savings (must be before Expense/Debt which depend on withdraw)
    getSavingsBalanceUseCase = GetSavingsBalanceUseCase(savingsRepository);
    getSavingsHistoryUseCase = GetSavingsHistoryUseCase(savingsRepository);
    depositCycleSavingsUseCase = DepositCycleSavingsUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
      debtRepository: debtRepository,
      savingsRepository: savingsRepository,
      lendingRepository: lendingRepository,
    );
    withdrawSavingsUseCase = WithdrawSavingsUseCase(savingsRepository);
    depositSalarySplitUseCase = DepositSalarySplitUseCase(
      cycleRepository: cycleRepository,
      savingsRepository: savingsRepository,
    );
    depositFromBalanceUseCase = DepositFromBalanceUseCase(
      savingsRepository,
      cycleRepository,
    );
    withdrawToBalanceUseCase = WithdrawToBalanceUseCase(
      savingsRepository,
      cycleRepository,
    );

    // Use Cases — Financial Setup
    getFinancialSetupStepUseCase = GetFinancialSetupStepUseCase(userRepository);
    setInitialBalanceUseCase = SetInitialBalanceUseCase(userRepository);
    setInitialSavingsUseCase = SetInitialSavingsUseCase(userRepository, savingsRepository);
    addInitialDebtUseCase = AddInitialDebtUseCase(debtRepository);
    editInitialDebtUseCase = EditInitialDebtUseCase(debtRepository);
    deleteInitialDebtUseCase = DeleteInitialDebtUseCase(debtRepository);
    addInitialLendingUseCase = AddInitialLendingUseCase(lendingRepository, cycleRepository);
    editInitialLendingUseCase = EditInitialLendingUseCase(lendingRepository);
    deleteInitialLendingUseCase = DeleteInitialLendingUseCase(lendingRepository);
    completeFinancialSetupUseCase = CompleteFinancialSetupUseCase(
      userRepository,
      cycleRepository,
      incomeRepository,
      expenseRepository,
      lendingRepository,
    );
    getSetupSummaryUseCase = GetSetupSummaryUseCase(
      userRepository, debtRepository, lendingRepository, savingsRepository,
    );

    // Use Cases — Lending
    createLendingUseCase = CreateLendingUseCase(
      lendingRepository,
      cycleRepository,
      withdrawSavingsUseCase,
      savingsRepository,
    );
    getLendingsUseCase = GetLendingsUseCase(lendingRepository);
    addLendingCollectionUseCase = AddLendingCollectionUseCase(lendingRepository, savingsRepository);
    deleteLendingUseCase = DeleteLendingUseCase(lendingRepository);
    updateLendingUseCase = UpdateLendingUseCase(lendingRepository);

    // Use Cases — Expense
    addExpenseUseCase = AddExpenseUseCase(
      expenseRepository,
      withdrawSavingsUseCase,
      savingsRepository,
    );
    editExpenseUseCase = EditExpenseUseCase(expenseRepository, cycleRepository, savingsRepository);
    deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository, cycleRepository, savingsRepository);
    getExpensesUseCase = GetExpensesUseCase(expenseRepository);

    // Use Cases — Income
    addIncomeUseCase = AddIncomeUseCase(incomeRepository, savingsRepository);
    updateIncomeUseCase = UpdateIncomeUseCase(incomeRepository);
    deleteIncomeUseCase = DeleteIncomeUseCase(incomeRepository);

    // Use Cases — Debt
    createDebtUseCase = CreateDebtUseCase(debtRepository, cycleRepository);
    getDebtsUseCase = GetDebtsUseCase(debtRepository);
    updateDebtUseCase = UpdateDebtUseCase(debtRepository);
    deleteDebtUseCase = DeleteDebtUseCase(debtRepository, savingsRepository);
    addPaymentUseCase = AddDebtPaymentUseCase(
      debtRepository,
      withdrawSavingsUseCase,
      savingsRepository,
    );
    calculateRemainingBalanceUseCase = CalculateRemainingBalanceUseCase(debtRepository);

    // Use Cases — Goal
    createGoalUseCase = CreateGoalUseCase(goalRepository);
    getGoalsUseCase = GetGoalsUseCase(goalRepository);
    updateGoalUseCase = UpdateGoalUseCase(goalRepository);
    deleteGoalUseCase = DeleteGoalUseCase(goalRepository);
    calculateGoalProgressUseCase = CalculateGoalProgressUseCase(
      cycleRepository,
      expenseRepository,
      incomeRepository,
    );

    // Use Cases — Statistics
    getCategoryBreakdownUseCase = GetCategoryBreakdownUseCase(
      expenseRepository: expenseRepository,
    );
    getMonthlyComparisonUseCase = GetMonthlyComparisonUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );
    getFinancialClassificationUseCase = GetFinancialClassificationUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );
    // Use Cases — Insights
    calculateFinancialClassificationUseCase =
        insight_classification.CalculateFinancialClassificationUseCase(
          cycleRepository,
          expenseRepository,
        );
    detectLeaksUseCase = insight_leaks.DetectLeaksUseCase(
      cycleRepository,
      expenseRepository,
    );
    generateTrendsUseCase = GenerateSpendingTrendsUseCase(
      cycleRepository,
      expenseRepository,
    );

    // Use Cases — Cycle
    checkAndStartCycleUseCase = CheckAndStartCycleUseCase(
      userRepository,
      cycleRepository,
      depositCycleSavingsUseCase,
    );
    resetAppDataUseCase = ResetAppDataUseCase(
      _database,
      userRepository,
      cycleRepository,
    );

    // Use Cases — Challenge
    generateWeeklyChallengeUseCase = GenerateWeeklyChallengeUseCase(
      challengeRepository,
      cycleRepository,
      expenseRepository,
    );
    getActiveChallengeUseCase = GetActiveChallengeUseCase(challengeRepository);
    calculateChallengeProgressUseCase = CalculateChallengeProgressUseCase(
      challengeRepository,
      expenseRepository,
    );

    // Use Cases — Notification
    generateNotificationUseCase = GenerateNotificationUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
      debtRepository: debtRepository,
      lendingRepository: lendingRepository,
    );

    // Notification Service
    notificationService = NotificationService(
      generateNotificationUseCase: generateNotificationUseCase,
    );
    await notificationService.initialize();
  }
}
