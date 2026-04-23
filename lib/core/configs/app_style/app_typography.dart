part of 'init_app_style.dart';

class AppTypography {
  static TextStyle base({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.text_primary,
      height: height ?? 1.2,
    );
  }

  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;

  static TextStyle h1 = base(
    fontSize: 30,
    fontWeight: bold,
  );

  static TextStyle h2 = base(
    fontSize: 24,
    fontWeight: bold,
  );

  static TextStyle h3 = base(
    fontSize: 20,
    fontWeight: bold,
  );

  static TextStyle h4 = base(
    fontSize: 18,
    fontWeight: bold,
  );

  static TextStyle h5 = base(
    fontSize: 16,
    fontWeight: bold,
  );

  static TextStyle h6 = base(
    fontSize: 14,
    fontWeight: bold,
  );

  static TextStyle p1 = base(
    fontSize: 18,
    fontWeight: medium,
  );

  static TextStyle p2 = base(
    fontSize: 18,
    fontWeight: normal,
  );

  static TextStyle p3 = base(
    fontSize: 16,
    fontWeight: medium,
  );

  static TextStyle p4 = base(
    fontSize: 16,
    fontWeight: normal,
  );

  static TextStyle p5 = base(
    fontSize: 14,
    fontWeight: medium,
  );

  static TextStyle p6 = base(
    fontSize: 14,
    fontWeight: normal,
  );

  static TextStyle p7 = base(
    fontSize: 12,
    fontWeight: medium,
  );

  static TextStyle p8 = base(
    fontSize: 12,
    fontWeight: bold,
  );

  static TextStyle p9 = base(
    fontSize: 12,
    fontWeight: normal,
  );

  static TextStyle p10 = base(
    fontSize: 10,
    fontWeight: normal,
  );

  static TextStyle p11 = base(
    fontSize: 10,
    fontWeight: medium,
  );

  static TextStyle p12 = base(
    fontSize: 8,
    fontWeight: normal,
  );
}
