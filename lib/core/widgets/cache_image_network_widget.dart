import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/extension/init_ext.dart';
import 'package:drmom/core/extension/string_extension.dart';
import 'package:drmom/gen/assets.gen.dart';
import 'base/base_loading.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Widget? placeholder;
  final bool showLoad;
  final bool useCard;

  const AppNetworkImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.errorWidget,
    this.placeholder,
    this.showLoad = false,
    this.useCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultWidth = width ?? 61;
    final defaultHeight = height ?? 61;
    final defaultRadius = borderRadius ?? 0;

    Widget image = CachedNetworkImage(
      imageUrl: url ?? "",
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) =>
          placeholder ??
          Stack(
            children: [
              if (!showLoad)
                Positioned.fill(
                  child: Assets.images.logo.image(
                    fit: BoxFit.contain,
                  ),
                ),
              Center(
                child: showLoad
                    ? const BaseLoading()
                    : const CupertinoActivityIndicator(),
              ),
            ],
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Assets.images.logo.image(
            width: defaultWidth,
            height: defaultHeight,
            fit: BoxFit.contain,
          ),
    );

    if (url.nullOrEmpty) {
      image = Assets.images.logo.image(
        width: defaultWidth,
        height: defaultHeight,
        fit: BoxFit.contain,
      );
    }

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(defaultRadius),
      child: image,
    );

    if (useCard) {
      return Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: defaultRadius.radius,
        ),
        child: content,
      );
    }

    return content;
  }
}

// Deprecated: For compatibility during migration
typedef CacheNetworkImageWidget = AppNetworkImage;
typedef CacheNetworkImageV2 = AppNetworkImage;
typedef CacheNetworkImageV3 = AppNetworkImage;

Widget imageNetWork({
  required String path,
  double? width,
  double? height,
  Color? color,
  BoxFit fit = BoxFit.contain,
  BorderRadius radius = BorderRadius.zero,
  Widget? errorWidget,
  Widget? placeholder,
}) {
  return AppNetworkImage(
    url: path,
    width: width,
    height: height,
    fit: fit,
    borderRadius: radius.bottomLeft.x, // Extracting radius from BorderRadius
    errorWidget: errorWidget,
    placeholder: placeholder,
  );
}
