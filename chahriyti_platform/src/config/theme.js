// Chahriyti brand tokens — mirrors mobile app (app_colors.dart)
export const colors = {
  primary: '#0D6E6E',
  primaryLight: '#1A9494',
  primaryDark: '#084E4E',
  positive: '#22C55E',
  negative: '#EF4444',
  warning: '#F59E0B',
  surface: '#F8F9FA',
  card: '#FFFFFF',
  textPrimary: '#1A1A2E',
  textSecondary: '#94A3B8',
  border: '#E2E8F0',
  divider: '#F1F5F9',
};

// Chart color palette for Recharts
export const chartColors = {
  primary: colors.primary,
  secondary: colors.primaryLight,
  positive: colors.positive,
  negative: colors.negative,
  warning: colors.warning,
  muted: colors.textSecondary,
  grid: colors.divider,
};

export const chartDefaults = {
  strokeWidth: 2,
  dotRadius: 4,
  activeDotRadius: 6,
  animationDuration: 800,
};
