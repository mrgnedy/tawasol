import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/data/models/all_sections_model.dart';
import 'package:tawasool/data/repository/occasions_repo.dart';

class OccasionsStore {
  OccasionsRepo occasionsRepo;
  AllOccasionsModel allOccasionsModel;
  AllSectionsModel allSectionsModel;
  OccasionsStore(){
    occasionsRepo = OccasionsRepo();
  }
  Future<AllOccasionsModel> getAllOccasions()async{
    allOccasionsModel = await occasionsRepo.getAllOccasions();
    if(allOccasionsModel != null)
    return allOccasionsModel;
    else
    throw 'لا توجد مناسبات';
  }
  Future<AllSectionsModel> getAllSections()async{
    allSectionsModel = await occasionsRepo.getAllSections();
    if(allSectionsModel != null)
    return allSectionsModel;
    else
    throw 'لا توجد أقسام';
  }
}