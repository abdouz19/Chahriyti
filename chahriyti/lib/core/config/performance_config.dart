/// Performance configuration and optimization guidelines
abstract final class PerformanceConfig {
  /// Database query timeout in milliseconds
  static const int dbQueryTimeout = 5000;

  /// List view pagination size - optimal for 60fps scrolling
  static const int listPageSize = 20;

  /// Image cache size in MB
  static const int imageCacheSize = 50;

  /// Maximum number of goals to load at once
  static const int maxGoalsPerPage = 20;

  /// Maximum number of debts to load at once
  static const int maxDebtsPerPage = 20;

  /// Maximum number of expenses to load at once
  static const int maxExpensesPerPage = 50;

  /// Debounce duration for search/filter operations (ms)
  static const Duration searchDebounce = Duration(milliseconds: 300);

  /// Optimization notes:
  /// 1. All list views use ListView.builder with pagination
  /// 2. RepaintBoundary wraps progress bars to prevent parent repaints
  /// 3. All widget constructors are const where possible
  /// 4. Database operations always in cubits/usecases, never in build()
  /// 5. Freezed entities provide value equality for efficient rebuilds
  /// 6. BLoC pattern prevents unnecessary widget rebuilds
  /// 7. GoalProgressBar uses RepaintBoundary for smooth animations
  /// 8. All SizedBox.shrink() are const
  /// 9. Theme colors cached via AppColors constants
  /// 10. Typography cached via AppTypography constants
}
