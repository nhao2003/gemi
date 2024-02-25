import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gemi/data/data_source/local/gemini_local_data_source/gemini_local_data_source_impl.dart';
import 'package:gemi/data/data_source/local/local_data_storage/local_data_storage.dart';
import 'package:gemi/data/data_source/local/local_database.dart';
import 'package:gemi/data/data_source/local/setting_local_data_source.dart';
import 'package:gemi/data/data_source/remote/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:gemi/data/data_source/remote/auth_remote_data_source/auth_remote_data_source_impl.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source_impl.dart';
import 'package:gemi/data/data_source/remote/remote_database/remote_database_impl.dart';
import 'package:gemi/data/repository/auth_repository_impl.dart';
import 'package:gemi/data/repository/gemini_repository_impl.dart';
import 'package:gemi/domain/repositories/auth_repository.dart';
import 'package:gemi/domain/repositories/gemini_repository.dart';
import 'package:gemi/presentation/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:gemi/presentation/home/bloc/home_bloc.dart';
import 'package:gemi/presentation/splash/bloc/splash_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/data_source/remote/gemini_remote_data_source/gemini_constanst.dart';
import 'data/data_source/remote/gemini_service/gemini_service.dart';
import 'data/data_source/remote/remote_data_storage/remote_data_storage.dart';
import 'data/data_source/remote/remote_data_storage/remote_data_storage_impl.dart';
import 'data/repository/data_storage_repository_impl.dart';
import 'data/repository/setting_repository_impl.dart';
import 'domain/repositories/data_storage_repository.dart';
import 'domain/repositories/setting_repository.dart';
import 'presentation/authentication/sign_up/bloc/sign_up_bloc.dart';
import 'presentation/setting/bloc/setting_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final localDatabase = await LocalDataBase.instance.init();
  await dotenv.load(fileName: '.env');
  final sp = await SharedPreferences.getInstance();
  final supabaseClient = (await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  ))
      .client;
  sl.registerLazySingleton<LocalDataStorage>(() => LocalDataStorage(
        DefaultCacheManager(),
      ));
  sl.registerLazySingleton<RemoteDataStorage>(() => RemoteDataStorageImpl(
        supabaseClient,
      ));

  sl.registerLazySingleton<DataStorageRepository>(
      () => DataStorageRepositoryImpl(
            sl<LocalDataStorage>(),
            sl<RemoteDataStorage>(),
          ));
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);
  sl.registerLazySingleton<SharedPreferences>(() => sp);
  sl.registerLazySingleton<GeminiLocalDataSourceImpl>(
      () => GeminiLocalDataSourceImpl(
            database: localDatabase,
          ));
  sl.registerLazySingleton<GeminiRemoteDataSource>(
      () => GeminiRemoteDataSourceImpl(
            service: GeminiService(
              Dio(BaseOptions(
                baseUrl:
                    '${GeminiConstants.baseUrl}${GeminiConstants.defaultVersion}/',
                contentType: 'application/json',
              )),
              apiKey: dotenv.env['GEMINI_API_KEY']!,
            ),
          ));
  sl.registerLazySingleton<GemiRemoteDatabase>(() => GemiRemoteDatabaseImpl(
        supabaseClient,
      ));
  sl.registerLazySingleton<GeminiRepository>(() => GeminiRepositoryImpl(
      sl<GeminiLocalDataSourceImpl>(),
      sl<GeminiRemoteDataSource>(),
      sl<DataStorageRepository>(),
      sl<GemiRemoteDatabase>()));

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        supabaseClient,
      ));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        sl<AuthRemoteDataSource>(),
      ));

  sl.registerLazySingleton<SettingLocalDataSource>(
      () => SettingLocalDataSourceImpl(sharedPreferences: sp));

  sl.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(
        settingLocalDataSource: sl<SettingLocalDataSource>(),
      ));

  sl.registerLazySingleton<SettingBloc>(() => SettingBloc(
        settingRepository: sl<SettingRepository>(),
        authRepository: sl<AuthRepository>(),
        geminiRepository: sl<GeminiRepository>(),
      ));
  sl.registerLazySingleton<HomeBloc>(() => HomeBloc(
        sl<GeminiRepository>(),
      ));
  sl.registerLazySingleton<SplashBloc>(() => SplashBloc(sl<AuthRepository>()));
  sl.registerLazySingleton<SignUpBloc>(() => SignUpBloc(sl<AuthRepository>()));
  sl.registerLazySingleton<SignInBloc>(() => SignInBloc(sl<AuthRepository>()));
}
