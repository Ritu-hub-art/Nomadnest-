import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './custom_image_widget.dart';

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
    return CustomImageWidget(
      imageUrl: 'assets/images/NN_Logo-1754942019366.png',
      width: width ?? 40.w,
      height: height ?? 15.h,
      fit: fit,
    );
  }
}
