import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../application/use_cases/activation/compose_whatsapp_message_use_case.dart';
import '../../../application/use_cases/activation/get_device_id_use_case.dart';
import '../../../application/use_cases/activation/validate_license_use_case.dart';
import '../../../application/use_cases/onboarding/add_initial_income_use_case.dart';
import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../activation/cubits/activation_cubit.dart';
import '../../activation/pages/activation_page.dart';
import '../../challenge/pages/challenge_detail_page.dart';
import '../../cycle_history/pages/cycle_history_page.dart';
import '../../debt/pages/add_debt_page.dart';
import '../../debt/pages/debt_detail_page.dart';
import '../../debt/pages/debts_list_page.dart';
import '../../expense/pages/add_expense_page.dart';
import '../../expense/pages/edit_expense_page.dart';
import '../../goal/pages/add_goal_page.dart';
import '../../goal/pages/goal_detail_page.dart';
import '../../goal/pages/goals_list_page.dart';
import '../../history/pages/expense_history_page.dart';
import '../../onboarding/cubits/onboarding_cubit.dart';
import '../../onboarding/pages/salary_setup_page.dart';
import '../../onboarding/pages/splash_page.dart';
import '../../onboarding/pages/value_proposition_page.dart';
import '../../home/pages/home_page.dart';
import '../../income/pages/add_income_page.dart';
import '../../onboarding/pages/additional_income_page.dart';
import '../../salary_split/pages/salary_split_page.dart';
import '../../lending/pages/add_lending_page.dart';
import '../../lending/pages/lending_detail_page.dart';
import '../../lending/pages/lendings_list_page.dart';
import '../../savings/pages/savings_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../statistics/pages/statistics_page.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final path = state.uri.path;

      // Check if user exists
      final user = await Injection.userRepository.getUser();

      // No user: allow splash and onboarding routes
      if (user == null) {
        const onboardingPaths = [
          '/',
          '/onboarding/value',
          '/onboarding/salary',
          '/onboarding/income',
          '/salary-split',
        ];

        return onboardingPaths.contains(path) ? null : '/';
      }

      // User exists but not activated: only allow activation
      if (!user.isActivated) {
        return path == '/activation' ? null : '/activation';
      }

      // User is activated: go to home if on splash or onboarding
      if (path == '/' || path.startsWith('/onboarding')) {
        return '/home';
      }

      // Auto-cycle gate: check if a new cycle should start on this app launch
      if (path != '/salary-split') {
        final newCycle = await Injection.checkAndStartCycleUseCase();
        if (newCycle != null) {
          Injection.pendingCycleForSplit = newCycle;
          return '/salary-split';
        }
      }

      return null;
    },
    routes: [
      // ── Splash ──────────────────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),

      // ── Onboarding ─────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding/salary',
        builder: (context, state) => BlocProvider(
          create: (_) => OnboardingCubit(
            setupSalaryUseCase: SetupSalaryUseCase(
              Injection.userRepository,
              Injection.cycleRepository,
            ),
            addInitialIncomeUseCase: AddInitialIncomeUseCase(
              Injection.cycleRepository,
              Injection.incomeRepository,
            ),
            depositSalarySplitUseCase: Injection.depositSalarySplitUseCase,
            cycleRepository: Injection.cycleRepository,
          )..start(),
          child: const SalarySetupPage(),
        ),
      ),
      GoRoute(
        path: '/onboarding/income',
        builder: (context, state) => BlocProvider(
          create: (_) => OnboardingCubit(
            setupSalaryUseCase: SetupSalaryUseCase(
              Injection.userRepository,
              Injection.cycleRepository,
            ),
            addInitialIncomeUseCase: AddInitialIncomeUseCase(
              Injection.cycleRepository,
              Injection.incomeRepository,
            ),
            depositSalarySplitUseCase: Injection.depositSalarySplitUseCase,
            cycleRepository: Injection.cycleRepository,
          ),
          child: const AdditionalIncomePage(),
        ),
      ),
      GoRoute(
        path: '/onboarding/value',
        builder: (context, state) => const ValuePropositionPage(),
      ),

      // ── Activation ─────────────────────────────────────────────────
      GoRoute(
        path: '/activation',
        builder: (context, state) => BlocProvider(
          create: (_) => ActivationCubit(
            getDeviceIdUseCase:
                GetDeviceIdUseCase(Injection.deviceInfoService),
            validateLicenseUseCase: ValidateLicenseUseCase(
              Injection.licenseService,
              Injection.userRepository,
            ),
            composeWhatsAppMessageUseCase:
                const ComposeWhatsAppMessageUseCase(),
          )..loadDeviceId(),
          child: const ActivationPage(),
        ),
      ),

      // ── Home ────────────────────────────────────────────────────────
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),

      // ── Expense ─────────────────────────────────────────────────────
      GoRoute(
        path: '/expense/add',
        builder: (context, state) {
          final cycleId = state.extra as int? ?? 0;
          return AddExpensePage(cycleId: cycleId);
        },
      ),
      GoRoute(
        path: '/expense/edit',
        builder: (context, state) {
          final expense = state.extra as ExpenseEntity;
          return EditExpensePage(
            expenseId: expense.id,
            cycleId: expense.cycleId,
          );
        },
      ),

      // ── Income ──────────────────────────────────────────────────────
      GoRoute(
        path: '/income/add',
        builder: (context, state) => const AddIncomePage(),
      ),

      // ── Statistics ──────────────────────────────────────────────────
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsPage(),
      ),

      // ── Debt ────────────────────────────────────────────────────────
      GoRoute(
        path: '/debts',
        builder: (context, state) => const DebtsListPage(),
      ),
      GoRoute(
        path: '/debt/add',
        builder: (context, state) => const AddDebtPage(),
      ),
      GoRoute(
        path: '/debt/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DebtDetailPage(debtId: id);
        },
      ),

      // ── Lending ──────────────────────────────────────────────────────
      GoRoute(
        path: '/lendings',
        builder: (context, state) => const LendingsListPage(),
      ),
      GoRoute(
        path: '/lending/add',
        builder: (context, state) {
          final cycleId = state.extra as int? ?? 0;
          return AddLendingPage(cycleId: cycleId);
        },
      ),
      GoRoute(
        path: '/lending/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LendingDetailPage(lendingId: id);
        },
      ),

      // ── Goal ────────────────────────────────────────────────────────
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsListPage(),
      ),
      GoRoute(
        path: '/goal/add',
        builder: (context, state) => const AddGoalPage(),
      ),
      GoRoute(
        path: '/goal/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return GoalDetailPage(goalId: id);
        },
      ),

      // ── Challenge ───────────────────────────────────────────────────
      GoRoute(
        path: '/challenge/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChallengeDetailPage(challengeId: id);
        },
      ),

      // ── History ─────────────────────────────────────────────────────
      GoRoute(
        path: '/history',
        builder: (context, state) => const ExpenseHistoryPage(),
      ),

      // ── Salary Split ──────────────────────────────────────────────────
      GoRoute(
        path: '/salary-split',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          // Auto-cycle path: consume the pending cycle set by the router redirect
          final pending = Injection.pendingCycleForSplit;
          Injection.pendingCycleForSplit = null;

          final cycleId = extra?['cycleId'] as int? ?? pending?.id ?? 0;
          final salaryAmount =
              extra?['salaryAmount'] as int? ?? pending?.salaryAmount ?? 0;
          final onComplete =
              extra?['onComplete'] as VoidCallback? ?? () => context.go('/home');
          final isAutoEntry = extra == null && pending != null;

          return SalarySplitPage(
            cycleId: cycleId,
            salaryAmount: salaryAmount,
            onComplete: onComplete,
            isAutoEntry: isAutoEntry,
          );
        },
      ),

      // ── Savings ─────────────────────────────────────────────────────
      GoRoute(
        path: '/savings',
        builder: (context, state) => const SavingsPage(),
      ),

      // ── Settings ────────────────────────────────────────────────────
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // ── Cycle History ──────────────────────────────────────────────
      GoRoute(
        path: '/cycle-history',
        builder: (context, state) => const CycleHistoryPage(),
      ),
    ],
  );
}
