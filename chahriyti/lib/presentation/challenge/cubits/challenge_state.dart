part of 'challenge_cubit.dart';

abstract class ChallengeState {
  const ChallengeState();
}

class ChallengeInitial extends ChallengeState {
  const ChallengeInitial();
}

class ChallengeLoading extends ChallengeState {
  const ChallengeLoading();
}

class ChallengeLoaded extends ChallengeState {
  final List<dynamic> challenges;
  final bool hasMore;
  final int offset;

  const ChallengeLoaded(this.challenges, {this.hasMore = false, this.offset = 0});
}

class ChallengeCreated extends ChallengeState {
  final int challengeId;

  const ChallengeCreated(this.challengeId);
}

class ChallengeUpdated extends ChallengeState {
  const ChallengeUpdated();
}

class ChallengeDeleted extends ChallengeState {
  const ChallengeDeleted();
}

class ChallengeCompleted extends ChallengeState {
  const ChallengeCompleted();
}

class ChallengeError extends ChallengeState {
  final String message;

  const ChallengeError(this.message);
}
