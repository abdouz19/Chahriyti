class GetSafeBalanceUseCase {
  const GetSafeBalanceUseCase();

  int call({required int remainingBalance, required int remainingDays}) {
    if (remainingDays <= 0) return 0;
    return remainingBalance ~/ remainingDays;
  }
}
