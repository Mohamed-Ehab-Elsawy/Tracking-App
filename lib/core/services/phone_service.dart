import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class PhoneService {
  Future<void> call(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> openWhatsApp(String phone, {String message = ''}) async {
    final Uri uri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch WhatsApp for $phone';
    }
  }
}
