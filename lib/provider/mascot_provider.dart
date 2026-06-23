import 'package:flutter_riverpod/legacy.dart';

enum MascotMood { idle, happy, sad, encourage }

final mascotMoodProvider = StateProvider<MascotMood>((ref) => MascotMood.idle);
final mascotMessageProvider = StateProvider<String>((ref) => '');
