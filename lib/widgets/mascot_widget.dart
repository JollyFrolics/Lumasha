import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumasha/provider/gamification_provider.dart';
import 'package:lumasha/provider/mascot_provider.dart';

class MascotWidget extends ConsumerStatefulWidget {
  final double size;
  const MascotWidget({super.key, this.size = 48});

  @override
  ConsumerState<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends ConsumerState<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  Timer? _autoClearTimer;

  @override
  void initState() {
    super.initState();
     _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _autoClearTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    ref.read(mascotMoodProvider.notifier).state = MascotMood.encourage;
    ref.read(mascotMessageProvider.notifier).state = 'You can do it! 💪';
    _autoClearAfter(2500);
  }

  void _autoClearAfter(int ms) {
    _autoClearTimer?.cancel();
    _autoClearTimer = Timer(Duration(milliseconds: ms), () {
      if (mounted) {
        ref.read(mascotMoodProvider.notifier).state = MascotMood.idle;
        ref.read(mascotMessageProvider.notifier).state = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mood = ref.watch(mascotMoodProvider);
    final message = ref.watch(mascotMessageProvider);
    ref.watch(gamificationProvider);  

    String emoji;
    switch (mood) {
      case MascotMood.happy:
        emoji = '🦁✨';
        break;
      case MascotMood.sad:
        emoji = '🦁😿';
        break;
      case MascotMood.encourage:
        emoji = '🦁💪';
        break;
      default:
        emoji = '🦁';
    }

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
           final offsetY = -12 * _bounceController.value;
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF7C2D12)),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                Text(emoji, style: TextStyle(fontSize: widget.size)),
              ],
            ),
          );
        },
      ),
    );
  }
}
