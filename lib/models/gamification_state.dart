class GamificationState {
  final int xp;
  final int gems;
  final int hearts;
  final int maxHearts;
  final int streakDays;
  final DateTime? lastActiveDate;
  final int dailyGoalPct;
  final int dailyXpToday;
  final int level;

  const GamificationState({
    this.xp = 0,
    this.gems = 0,
    this.hearts = 5,
    this.maxHearts = 5,
    this.streakDays = 0,
    this.lastActiveDate,
    this.dailyGoalPct = 0,
    this.dailyXpToday = 0,
    this.level = 1,
  });

  factory GamificationState.fromJson(Map<String, dynamic> json) {
    return GamificationState(
      xp: json['xp'] as int? ?? 0,
      gems: json['gems'] as int? ?? 0,
      hearts: json['hearts'] as int? ?? 5,
      maxHearts: json['max_hearts'] as int? ?? 5,
      streakDays: json['streak_days'] as int? ?? 0,
      lastActiveDate: json['last_active_date'] != null
          ? DateTime.tryParse(json['last_active_date'] as String)
          : null,
      dailyGoalPct: json['daily_goal_pct'] as int? ?? 0,
      dailyXpToday: json['daily_xp_today'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'gems': gems,
        'hearts': hearts,
        'max_hearts': maxHearts,
        'streak_days': streakDays,
        'last_active_date': lastActiveDate?.toIso8601String(),
        'daily_goal_pct': dailyGoalPct,
        'daily_xp_today': dailyXpToday,
        'level': level,
      };

  GamificationState copyWith({
    int? xp,
    int? gems,
    int? hearts,
    int? maxHearts,
    int? streakDays,
    DateTime? lastActiveDate,
    int? dailyGoalPct,
    int? dailyXpToday,
    int? level,
  }) {
    return GamificationState(
      xp: xp ?? this.xp,
      gems: gems ?? this.gems,
      hearts: hearts ?? this.hearts,
      maxHearts: maxHearts ?? this.maxHearts,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      dailyGoalPct: dailyGoalPct ?? this.dailyGoalPct,
      dailyXpToday: dailyXpToday ?? this.dailyXpToday,
      level: level ?? this.level,
    );
  }
}
