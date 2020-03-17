import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/data/models/all_sections_model.dart';

class OccasionsRepo {

  Future<AllOccasionsModel> getAllOccasions() async {
    String url = APIs.getOccasionsEP;
    return AllOccasionsModel.fromJson(await APIs.getRequest(url));
  }

  Future<AllSectionsModel> getAllSections() async {
    String url = APIs.getAllSectionEP;
    return AllSectionsModel.fromJson(await APIs.getRequest(url));
  }
}