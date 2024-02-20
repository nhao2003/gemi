import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemi/data/repository/setting_repository_impl.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/domain/repositories/auth_repository.dart';
import 'package:gemi/domain/repositories/setting_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/data_source/local/setting_local_data_source.dart';
import '../../../data/model/gemini/gemini_safety/safety_category.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingRepository settingRepository;

  AuthRepository authRepository;

  SettingBloc({
    required this.settingRepository,
    required this.authRepository,
  }) : super(SettingInitial()) {
    on<SettingEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetSafetyCategorySettings>((event, emit) async {
      emit(SafetyCategorySettingsLoading());
      final Map<SafetyCategory, int> safetyCategorySettings =
          await settingRepository.getSafetyCategorySettings();
      emit(SafetyCategorySettingsLoaded(safetyCategorySettings));
    });

    on<SetSafetyCategorySettings>((event, emit) async {
      await settingRepository
          .setSafetyCategorySettings(event.safetyCategorySettings);
      final Map<SafetyCategory, int> safetyCategorySettings =
          await settingRepository.getSafetyCategorySettings();
      emit(SafetyCategorySettingsLoaded(safetyCategorySettings));
    });

    on<SignOut>((event, emit) async {
      emit(SignOutLoading());
      await authRepository.signOut();
      emit(SignOutSuccess());
    });
  }
}
