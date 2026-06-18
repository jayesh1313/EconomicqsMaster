import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:credible_edutech/shared/network/http_client.dart';
import 'package:credible_edutech/shared/storage/cache_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(SupabaseClient supabaseClient) async {
  // Network
  HttpClient.initialize(supabaseClient);
  getIt.registerSingleton<HttpClient>(HttpClient());
  
  // Storage
  await CacheService.initialize();
  getIt.registerSingleton<CacheService>(CacheService());
  
  // Supabase
  getIt.registerSingleton<SupabaseClient>(supabaseClient);
}
