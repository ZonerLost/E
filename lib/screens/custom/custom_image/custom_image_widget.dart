import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edwardb/screens/custom/custom_shimmer/custom_shimmer_widget.dart';
import 'package:flutter/material.dart';

class CommonImageView extends StatelessWidget {
  // ignore_for_file: must_be_immutable
  String? url;
  String? imagePath;
  String? svgPath;
  File? file;
  double? height;
  double? width;
  double? radius;
  final BoxFit fit;
  final String placeHolder;
  final bool isImageLoading;

  CommonImageView({
    super.key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.isImageLoading = false,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.placeHolder = 'assets/images/no_image_found.png',
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    // shimmer loader widget
    Widget loadingWidget = CommonShimmer(
  height: 47,
  width: 47,
  radius: 40, // half of height/width = perfect circle
);

    // helper to wrap image with loader overlay
    Widget wrapWithLoader(Widget image) {
      if (!isImageLoading) return image;
      return Stack(
        alignment: Alignment.center,
        children: [
          image,
          loadingWidget,
        ],
      );
    }

    if (file != null && file!.path.isNotEmpty) {
      return wrapWithLoader(
         ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: Image.file(
              file!,
              height: height,
              width: width,
              fit: fit,
              frameBuilder: (context, child, frame, _) {
                if (frame == null && isImageLoading) return loadingWidget;
                return child;
              },
            ),
          
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                height: height,
                width: width,
                fit: fit,
                imageUrl: url!,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Image.asset(
                  placeHolder,
                  height: height,
                  width: width,
                  fit: fit,
                ),
              ),
              if (isImageLoading)
                Container(
                  height: height,
                  width: width,
                  color: Colors.black.withValues(alpha: 0.2),
                  child: loadingWidget,
                ),
            ],
          
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return wrapWithLoader(
       ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: Image.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit,
              frameBuilder: (context, child, frame, _) {
                if (frame == null && isImageLoading) return loadingWidget;
                return child;
              },
            ),
          
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width,
    );
  }
}


