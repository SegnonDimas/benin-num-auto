import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color? backgroundColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final BoxBorder? border;
  final Widget? child;
  final Function()? onTap;
  final AlignmentGeometry? alignment;
  const AppButton(
      {super.key,
      this.backgroundColor,
      this.borderRadius,
      this.child,
      this.height,
      this.width,
      this.gradient,
      this.onTap,
      this.border,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          alignment: alignment,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border,
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            gradient: backgroundColor == null
                ? gradient
                : LinearGradient(colors: [backgroundColor!, backgroundColor!]),
          ),
          child: child ?? const Text(''),
        ),
      ),
    );
  }
}
