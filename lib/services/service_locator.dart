
import 'package:ags_ims/core/view_models/item_view_model.dart';
import 'package:ags_ims/core/view_models/history_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<FireStoreDBService>(() => FireStoreDBService());
  locator.registerLazySingleton<Auth>(() => Auth());
  locator.registerLazySingleton<UI>(() => UI());
  locator.registerLazySingleton<BaseUtils>(() => BaseUtils());
  locator.registerLazySingleton<CloudStorageService>(() => CloudStorageService());
  locator.registerLazySingleton<UserProfileViewModel>(() => UserProfileViewModel());
  locator.registerLazySingleton<ItemViewModel>(() => ItemViewModel());
  locator.registerLazySingleton<HistoryViewModel>(() => HistoryViewModel());
}