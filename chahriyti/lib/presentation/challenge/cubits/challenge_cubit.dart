import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/challenge/generate_weekly_challenge_use_case.dart';
import '../../../infrastructure/services/notification_service.dart';

part 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  final GenerateWeeklyChallengeUseCase _generateWeeklyChallengeUseCase;
  final NotificationService? _notificationService;

  ChallengeCubit(
    this._generateWeeklyChallengeUseCase, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService,
        super(const ChallengeInitial());

  Future<void> generateWeeklyChallenge() async {
    emit(const ChallengeLoading());
    try {
      final challengeId = await _generateWeeklyChallengeUseCase();

      if (challengeId != null) {
        emit(ChallengeCreated(challengeId));

        // Trigger motivational notification
        _notificationService?.checkNotifications();
      } else {
        emit(const ChallengeLoaded(
          [],
          hasMore: false,
          offset: 0,
        ));
      }
    } catch (e) {
      debugPrint('❌ CHALLENGE ERROR: $e');
      emit(ChallengeError('فشل إنشاء التحدي: ${e.toString()}'));
    }
  }

  Future<void> completeChallenge(int challengeId) async {
    emit(const ChallengeLoading());
    try {
      // Mark challenge as completed (this would be a use case)
      emit(const ChallengeCompleted());

      // Send celebratory notification
      _notificationService?.checkNotifications();
    } catch (e) {
      debugPrint('❌ CHALLENGE ERROR: $e');
      emit(ChallengeError('فشل إكمال التحدي: ${e.toString()}'));
    }
  }
}
