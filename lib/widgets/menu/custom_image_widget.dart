import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mydealer/utils/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String? placeholder;
  const CustomImageWidget(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.placeholder = Images.placeholderImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Image.asset(
          placeholder ?? Images.placeholderImage,
          height: height,
          width: width,
          fit: BoxFit.cover),
      imageUrl: image,
      fit: fit,
      height: height,
      width: width,
      errorWidget: (c, o, s) => Image.asset(
          placeholder ?? Images.placeholderImage,
          height: height,
          width: width,
          fit: BoxFit.cover),
    );
  }
}
