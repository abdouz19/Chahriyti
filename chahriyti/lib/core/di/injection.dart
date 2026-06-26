import '../../infrastructure/database/app_database.dart';
import '../../infrastructure/database/daos/users_dao.dart';
import '../../infrastructure/database/daos/cycles_dao.dart';
import '../../infrastructure/database/daos/expenses_dao.dart';
import '../../infrastructure/database/daos/debts_dao.dart';
import '../../infrastructure/database/daos/goals_dao.dart';
import '../../infrastructure/database/daos/incomes_dao.dart';
import '../../infrastructure/database/daos/insights_dao.dart';
import '../../infrastructure/repositories/user_repository_impl.dart';
import '../../infrastructure/repositories/cycle_repository_impl.dart';
import '../../infrastructure/repositories/expense_repository_impl.dart';
import '../../infrastructure/repositories/debt_repository_impl.dart';
import '../../infrastructure/repositories/goal_repository_impl.dart';
import '../../infrastructure/repositories/income_repository_impl.dart';
import '../../infrastructure/repositories/insight_repository_impl.dart';
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
import '../../application/use_cases/statistics/get_predictions_use_case.dart';
import '../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../application/use_cases/statistics/detect_financial_leaks_use_case.dart'
    as stats_leaks;
import '../../application/use_cases/insights/calculate_financial_classification_use_case.dart' as insight_classification;
import '../../application/use_cases/insights/detect_financial_leaks_use_case.dart' as insight_leaks;
import '../../application/use_cases/insights/generate_spending_trends_use_case.dart';
import '../../application/use_cases/cycle/reset_cycle_use_case.dart';
import '../../application/use_cases/challenge/generate_weekly_challenge_use_case.dart';
import '../../application/use_cases/challenge/get_active_challenge_use_case.dart';
import '../../application/use_cases/challenge/calculate_challenge_progress_use_case.dart';
import '../../application/use_cases/notification/generate_notification_use_case.dart';

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

  // Repositories
  static late final UserRepository userRepository;
  static late final CycleRepository cycleRepository;
  static late final ExpenseRepository expenseRepository;
  static late final DebtRepository debtRepository;
  static late final GoalRepository goalRepository;
  static late final IncomeRepository incomeRepository;
  static late final InsightRepository insightRepository;

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
  static late final GetPredictionsUseCase getPredictionsUseCase;
  static late final GetMonthlyComparisonUseCase getMonthlyComparisonUseCase;
  static late final GetFinancialClassificationUseCase getFinancialClassificationUseCase;
  static late final stats_leaks.DetectFinancialLeaksUseCase detectFinancialLeaksUseCase;

  // Use Cases — Insights
  static late final insight_classification.CalculateFinancialClassificationUseCase
      calculateFinancialClassificationUseCase;
  static late final insight_leaks.DetectLeaksUseCase detectLeaksUseCase;
  static late final GenerateSpendingTrendsUseCase generateTrendsUseCase;

  // Public getters for InsightsCubit
  static insight_leaks.DetectLeaksUseCase get leaksUseCase => detectLeaksUseCase;
  static GenerateSpendingTrendsUseCase get trendsUseCase => generateTrendsUseCase;

  // Use Cases — Cycle
  static late final ResetCycleUseCase resetCycleUseCase;

  // Use Cases — Challenge
  static late final GenerateWeeklyChallengeUseCase generateWeeklyChallengeUseCase;
  static late final GetActiveChallengeUseCase getActiveChallengeUseCase;
  static late final CalculateChallengeProgressUseCase calculateChallengeProgressUseCase;

  // Use Cases — Notification
  static late final GenerateNotificationUseCase generateNotificationUseCase;

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

    // Services
    _deviceInfoService = DeviceInfoService();
    _secureStorageService = SecureStorageService();
    _licenseService = LicenseService();

    // Repositories
    userRepository = UserRepositoryImpl(_usersDao);
    cycleRepository = CycleRepositoryImpl(_cyclesDao);
    expenseRepository = ExpenseRepositoryImpl(_expensesDao);
    debtRepository = DebtRepositoryImpl(_debtsDao);
    goalRepository = GoalRepositoryImpl(_goalsDao);
    incomeRepository = IncomeRepositoryImpl(_incomesDao);
    insightRepository = InsightRepositoryImpl(_insightsDao, _database);

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
    );
    getSafeBalanceUseCase = const GetSafeBalanceUseCase();

    // Use Cases — Expense
    addExpenseUseCase = AddExpenseUseCase(expenseRepository);
    editExpenseUseCase = EditExpenseUseCase(expenseRepository, cycleRepository);
    deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository, cycleRepository);
    getExpensesUseCase = GetExpensesUseCase(expenseRepository);

    // Use Cases — Income
    addIncomeUseCase = AddIncomeUseCase(incomeRepository);

    // Use Cases — Debt
    createDebtUseCase = CreateDebtUseCase(debtRepository);
    getDebtsUseCase = GetDebtsUseCase(debtRepository);
    updateDebtUseCase = UpdateDebtUseCase(debtRepository);
    deleteDebtUseCase = DeleteDebtUseCase(debtRepository);
    addPaymentUseCase = AddDebtPaymentUseCase(debtRepository);
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
    getPredictionsUseCase = GetPredictionsUseCase(
      cycleRepository: cycleRepository,
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
    detectFinancialLeaksUseCase = stats_leaks.DetectFinancialLeaksUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );

    // Use Cases — Insights
    calculateFinancialClassificationUseCase =
        insight_classification.CalculateFinancialClassificationUseCase(
          cycleRepository,
          expenseRepository,
          incomeRepository,
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
    resetCycleUseCase = ResetCycleUseCase(cycleRepository);

    // Use Cases — Challenge
    generateWeeklyChallengeUseCase = GenerateWeeklyChallengeUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );
    getActiveChallengeUseCase = GetActiveChallengeUseCase();
    calculateChallengeProgressUseCase = CalculateChallengeProgressUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );

    // Use Cases — Notification
    generateNotificationUseCase = GenerateNotificationUseCase(
      cycleRepository: cycleRepository,
      expenseRepository: expenseRepository,
    );

    // Notification Service
    notificationService = NotificationService(
      generateNotificationUseCase: generateNotificationUseCase,
    );
  }
}
