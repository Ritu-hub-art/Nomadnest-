import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Centralized app logo widget using assets/images/logo.png
class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const LogoWidget({
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String assetPath = 'assets/images/logo.png';

    return Image.asset(
      assetPath,
      width: width ?? 40.w,
      height: height ?? 15.h,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 40.w,
          height: height ?? 15.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            'Logo',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
