import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/data/models/all_comments_model.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/data/models/all_sections_model.dart';
import 'package:tawasool/data/models/occasion_mode.dart';
import 'package:tawasool/data/models/sav_occasion_model.dart';
import 'package:tawasool/data/models/search_users_model.dart';
import 'package:tawasool/data/repository/occasions_repo.dart';

class OccasionsStore {
  OccasionsRepo occasionsRepo;
  AllOccasionsModel allOccasionsModel;
  AllSectionsModel allSectionsModel;
  SearchUsersModel searchUsersModel;
  SaveOccasionModel saveOccasionModel;
  OccasionsStore() {
    occasionsRepo = OccasionsRepo();
  }
  Future<AllOccasionsModel> getAllOccasions() async {
    allOccasionsModel = await occasionsRepo.getAllOccasions();
    if (allOccasionsModel != null)
      return allOccasionsModel;
    else
      throw 'لا توجد مناسبات';
  }

  Future<AllSectionsModel> getAllSections() async {
    allSectionsModel = await occasionsRepo.getAllSections();
    if (allSectionsModel != null)
      return allSectionsModel;
    else
      throw 'لا توجد أقسام';
  }

  Future<List<User>> searchUsers(String name) async {
    searchUsersModel = await occasionsRepo.searchUsers(name);
    if (searchUsersModel != null)
      return searchUsersModel.data
          .where((user) => user.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    else
      throw 'لا يوجد مستخدمين';
  }

  Future<SaveOccasionModel> saveOccasion(Map<String, String> savedOccasion,
      String image, List invitedUsers) async {
        print(savedOccasion);
    saveOccasionModel =
        await occasionsRepo.saveOccasion(savedOccasion, image, invitedUsers);
    if (saveOccasionModel != null)
      return saveOccasionModel;
    else
      throw 'لم يتمكن من إضافة مناسبة';
  }

  Future sendComment(String content, int id, int userID) async {
    return await occasionsRepo.sendComment(content, id, userID);
  }

  Future mngrDecision(int isPublic, int id, int userID, int decision) async {
    return await occasionsRepo.mngrDecision(isPublic, id, userID, decision);
  }

  Future deleteOccasion(int id) async {
    return await occasionsRepo.deleteOccasion(id);
  }

  Future<OccasionModel> getOccationByID(int id) async {
    final temp =
        OccasionModel.fromJson(await occasionsRepo.getOccasionByID(id));
    // print('stemp ${temp.data.toJson()}');
    return OccasionModel.fromJson(await occasionsRepo.getOccasionByID(id));
  }

  Future<AllCommentsModel> getComments(int id) async {
    return AllCommentsModel.fromJson(await occasionsRepo.getAllComments(id));
  }
}
