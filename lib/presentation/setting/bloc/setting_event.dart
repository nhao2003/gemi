part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class GetSafetyCategorySettings extends SettingEvent {}

class SetSafetyCategorySettings extends SettingEvent {
  final Map<SafetyCategory, int> safetyCategorySettings;

  const SetSafetyCategorySettings(this.safetyCategorySettings);

  @override
  List<Object> get props => [safetyCategorySettings];
}

class SignOut extends SettingEvent {}
