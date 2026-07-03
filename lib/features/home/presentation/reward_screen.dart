import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumasha/core/theme/app_colors.dart';
import 'package:lumasha/features/home/provider/home_provider.dart';

import '../../../widgets/lumasha_bottom_nav.dart';

class RewardScreen extends ConsumerWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(homeUserProfileProvider).value;
    if (userProfile == null) {
      return Text("No User Data");
    }

    final stats = [
      StatCardItem(
        icon: Icons.local_fire_department,
        title: 'Streak',
        value: userProfile.streakDays.toString(),
        color: LumashaColors.primary,
      ),
      StatCardItem(
          icon: Icons.heart_broken,
          title: "Hearts",
          value: "${userProfile.hearts}/${userProfile.maxHearts}",
          color: LumashaColors.primary),
    ];


    return Scaffold(
        backgroundColor: LumashaColors.background,
        bottomNavigationBar: const LumashaBottomNav(),
        body: RefreshIndicator(
            color: LumashaColors.primary,
            onRefresh: () async {
              ref.invalidate(homeUserProfileProvider);
              ref.invalidate(homeWeekStreakProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                    hasScrollBody: true,
                    child: Stack(
                      children: [
                        Positioned(
                            child: SafeArea(
                                child: Column(
                          children: [
                            _TopBar(),
                            _Indicator(
                              currValue: userProfile.xp,
                              maxValue:
                                  userProfile.xp + userProfile.xpNextLevel,
                            ),
                            _UserStat(
                              stats: stats,
                            ),
                            _Indicator(
                              currValue: userProfile.dailyDoneMin,
                              maxValue: userProfile.dailyGoalMin,
                            ),
                          ],
                        ))),
                      ],
                    ))
              ],
            )));
  }
}

class _Indicator extends StatelessWidget {
  final int currValue;
  final int maxValue;

  const _Indicator({
    required this.currValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        maxValue == 0 ? 0.0 : (currValue / maxValue).clamp(0.0, 1.0);

    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LumashaColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: LumashaColors.primaryFaint,
        ),
        boxShadow: [
          BoxShadow(
            color: LumashaColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$currValue',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LumashaColors.textDark,
                ),
              ),
              Text(
                ' / $maxValue',
                style: const TextStyle(
                  fontSize: 16,
                  color: LumashaColors.textLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: LumashaColors.accentFaint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    color: LumashaColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: LumashaColors.surface,
              valueColor: const AlwaysStoppedAnimation(
                LumashaColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCardItem {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCardItem(
      {required this.icon,
      required this.title,
      required this.value,
      required this.color});
}

class _UserStat extends ConsumerWidget {
  final List<StatCardItem> stats;
  const _UserStat({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3),
      itemBuilder: (contenxt, index) {
        final stat = stats[index];
        return _StatCard(
            icon: stat.icon,
            title: stat.title,
            value: stat.value,
            color: stat.color);
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Text("Reward");
  }
}
