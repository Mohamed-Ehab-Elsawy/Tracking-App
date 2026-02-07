import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extensions/string_image_type_extension.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';

void main() {
  group('ImageTypeExtension Tests', () {
    test('should identify network images', () {
      expect('https://example.com/image.png'.imageType, ImageType.network);
      expect('http://example.com/image.jpg'.imageType, ImageType.network);
    });

    test('should identify svg images', () {
      expect('assets/icons/logo.svg'.imageType, ImageType.svg);
    });

    test('should identify file images', () {
      expect('file:///data/user/0/image.png'.imageType, ImageType.file);
      expect(
        'com.inlighty.app.inlighty/cache/img.jpg'.imageType,
        ImageType.file,
      );
    });

    test('should default to png for assets', () {
      expect('assets/images/banner.png'.imageType, ImageType.png);
    });
  });
}
