// import 'package:flutter/material.dart';
// import 'package:urpass/core/extensions/text_styles/color_text_style_extensions.dart';
//
// import '../../constants/app_colors.dart';
//
// extension CustomDarkThemeExtensions on ThemeData {
//   InputDecoration get outlineInputBorderDecoration => InputDecoration(
//         filled: true,
//         fillColor: AppColors.chablis,
//         contentPadding: EdgeInsets.all(5),
//         floatingLabelBehavior: FloatingLabelBehavior.never,
//         hintStyle: AppColors.chineseSilver.regular(fontSize: 12),
//         labelStyle: AppColors.white.medium(fontSize: 12),
//         errorStyle: AppColors.red.regular(fontSize: 12),
//         enabledBorder: OutlineInputBorder(
//           gapPadding: 10,
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.blueWhite),
//         ),
//         disabledBorder: OutlineInputBorder(
//           gapPadding: 10,
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           gapPadding: 10,
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: primaryColor),
//         ),
//         errorBorder: OutlineInputBorder(
//           gapPadding: 10,
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         border: OutlineInputBorder(
//           gapPadding: 10,
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.blueWhite),
//         ),
//       );
//
//   InputDecoration get underlineInputBorderDecoration =>
//       outlineInputBorderDecoration.copyWith(
//         enabledBorder: UnderlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.sweetGrey),
//         ),
//         disabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.primary),
//         ),
//         errorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.red),
//         ),
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.sweetGrey),
//         ),
//       );
// }
