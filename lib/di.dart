

import 'package:get_it/get_it.dart';

import 'core/api/karzinka_api.dart';
import 'core/api/texnomart_api.dart';

final di = GetIt.instance;

Future<void> setup() async {

  di.registerSingleton(KarzinkaEbazaarApi());
  di.registerSingleton(TexnomartApi());

}