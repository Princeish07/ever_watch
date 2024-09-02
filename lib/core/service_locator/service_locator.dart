
import 'package:ever_watch/data/repository/register_repository_impl.dart';
import 'package:ever_watch/domain/repository/register_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../presentation/ui/register/provider/register_provider.dart';
import '../../presentation/ui/register/state/register_state.dart';

final serviceLocator = GetIt.instance; // GetIt.I is also valid
void serviceLocatorSetup() {
  registerRepository();
  // getProviders();

}
// StateNotifierProvider<RegisterProvider, RegisterState>? registerProvider;


registerRepository() {
  serviceLocator.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl());

}


// getProviders(){
//    registerProvider = StateNotifierProvider<RegisterProvider, RegisterState>((ref)
//   {
//     return RegisterProvider(registerRepository: RegisterRepositoryImpl());
//   }
//   );
// }

