import 'package:get_it/get_it.dart';
import 'package:studentconnect/data/databse/database_functions.dart';
import 'package:studentconnect/notification/notification_services.dart';

GetIt locator = GetIt.instance;
void setup() {
  locator.registerSingleton(Database());
  locator.registerSingleton(NotificationServices());
  // locator.registerFactory<Database>(() => Database());
}
