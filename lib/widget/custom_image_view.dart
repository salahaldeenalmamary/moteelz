// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CustomImageView extends StatelessWidget {
  /// [imagePath] is a required parameter for showing an image.
  final String? imagePath;

  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  const CustomImageView({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  Widget _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    switch (imagePath!.imageType) {
      // case ImageType.svg:
      //   return SvgPicture.asset(
      //     imagePath!,
      //     height: height,
      //     width: width,
      //     fit: fit ?? BoxFit.contain,
      //     placeholderBuilder: (context) => _buildLoadingIndicator(),
      //   );
      case ImageType.file:
        final file = File(imagePath!);
        if (!file.existsSync()) {
          return _buildPlaceholder();
        }
        return Image.file(
          file,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          color: color,
        );
      case ImageType.network:
        return CachedNetworkImage(
          imageUrl: imagePath!,
          height: height,
          colorBlendMode:  BlendMode.color,
          width: width,
          fit: fit ?? BoxFit.fill,
          color: color,
         
          placeholder: (context, url) => _buildLoadingIndicator(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        );
      case ImageType.png:
      default:
        return Image.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height ?? 50,
      width: width ?? 50,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.broken_image,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file }
