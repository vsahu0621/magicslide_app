import 'package:dio/dio.dart';
import 'package:magicslide_app/config/api_config.dart';
class MagicSlidesApi {
  static final Dio _dio = Dio();

  static Future<String?> generatePPT({
    required String topic,
    String? extraInfoSource,
    required String template,
    required String language,
    required int slideCount,
    required bool aiImages,
    required bool imageForEachSlide,
    required bool googleImage,
    required bool googleText,
    required String model,
    String? presentationFor,
    String? watermarkWidth,
    String? watermarkHeight,
    String? watermarkBrandUrl,
    String? watermarkPosition,
  }) async {
    try {
      final data = {
        "topic": topic,
        "email": MagicSlidesConfig.email,
        "accessId": MagicSlidesConfig.accessId,
        "template": template,
        "language": language,
        "slideCount": slideCount,
        "aiImages": aiImages,
        "imageForEachSlide": imageForEachSlide,
        "googleImage": googleImage,
        "googleText": googleText,
        "model": model,
      };

      if (extraInfoSource != null) data["extraInfoSource"] = extraInfoSource;
      if (presentationFor != null) data["presentationFor"] = presentationFor;

      final watermark = {};
      if (watermarkWidth != null) watermark["width"] = watermarkWidth;
      if (watermarkHeight != null) watermark["height"] = watermarkHeight;
      if (watermarkBrandUrl != null) watermark["brandURL"] = watermarkBrandUrl;
      if (watermarkPosition != null) watermark["position"] = watermarkPosition;

      if (watermark.isNotEmpty) data["watermark"] = watermark;

      final res = await _dio.post(MagicSlidesConfig.baseUrl, data: data);

      if (res.data["success"] == true) {
        return res.data["data"]["url"];
      }

      return null;
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }
}
