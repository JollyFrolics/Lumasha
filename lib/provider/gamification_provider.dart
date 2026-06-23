import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/supabase_client.dart';
import '../models/gamification_state.dart';

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(const GamificationState());

  Future<void> load(String userId) async {
    final response = await supabase
        .from('user_gamification')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (response != null) {
      state = GamificationState.fromJson(response);
    }
  }

  Future<void> addXp(int amount) async {
    final newXp = state.xp + amount;
    final newLevel = (newXp ~/ 100) + 1;
    final updated = state.copyWith(
      xp: newXp,
      level: newLevel,
      dailyXpToday: state.dailyXpToday + amount,
    );
    await _save(updated);
  }

  Future<void> spendGems(int amount) async {
    if (state.gems < amount) return;
    final updated = state.copyWith(gems: state.gems - amount);
    await _save(updated);
  }

  Future<void> loseHeart() async {
    if (state.hearts <= 0) return;
    final updated = state.copyWith(hearts: state.hearts - 1);
    await _save(updated);
  }

  Future<void> refillHearts() async {
    final updated = state.copyWith(hearts: state.maxHearts);
    await _save(updated);
  }

  Future<void> incrementStreak() async {
    final updated = state.copyWith(streakDays: state.streakDays + 1);
    await _save(updated);
  }

  Future<void> updateDailyGoal(int percent) async {
    final updated = state.copyWith(dailyGoalPct: percent);
    await _save(updated);
  }

  Future<void> _save(GamificationState gam) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase.from('user_gamification').upsert({
      'user_id': userId,
      ...gam.toJson(),
    });
    state = gam;
  }
}

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});
