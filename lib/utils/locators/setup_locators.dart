import 'package:get_it/get_it.dart';

import '../../model/current_location_model.dart';
import '../../model/firebase_model.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register an instance of MySingletonClass as a singleton
  locator.registerSingleton<CurrentLocationModel>(CurrentLocationModel());
  locator.registerLazySingleton<AppFirebase>(() => AppFirebase());
}
