
import 'package:ags_ims/services/auth_service.dart';
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
}