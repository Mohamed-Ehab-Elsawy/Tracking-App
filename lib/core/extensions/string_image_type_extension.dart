import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file:') || contains('com.inlighty.app.inlighty')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}
