import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ObCTAButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final String? svgIcon;
  final double? iconSize;
  final AnimationController? iconAnimationController;

  const ObCTAButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.width,
    this.height = 60,
    this.svgIcon,
    this.iconSize,
    this.iconAnimationController,
  });

  @override
  State<ObCTAButton> createState() => _ObCTAButtonState();
}

class _ObCTAButtonState extends State<ObCTAButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? 24.0;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: GestureDetector(
        onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: widget.enabled
            ? (_) {
          setState(() => _pressed = false);
          widget.onTap();
        }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(0, _pressed ? 6 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFC45F00),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: _pressed ? 0 : 6, bottom: _pressed ? 0 : 6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFB800), Color(0xFFFF8A00)],
                ),
                border: Border.all(color: const Color(0xFFFFCE85), width: 2),
              ),
              child: Stack(
                children: [
                   Positioned(
                    top: 4,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFFFE0B2).withOpacity(0.45),
                      ),
                    ),
                  ),
                  // Centered text
                  Center(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Color(0xFF3B1A08),
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16,),
                   if (widget.svgIcon != null)
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.iconAnimationController != null
                            ? AnimatedBuilder(
                          animation: widget.iconAnimationController!,
                          builder: (context, child) {
                            final offsetY = -4 * widget.iconAnimationController!.value;
                            return Transform.translate(
                              offset: Offset(0, offsetY),
                              child: child,
                            );
                          },
                          child: SvgPicture.asset(
                            widget.svgIcon!,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          ),
                        )
                            : SvgPicture.asset(
                          widget.svgIcon!,
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}