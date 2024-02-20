part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {}

final class SafetyCategorySettingsLoading extends SettingState {}

final class SafetyCategorySettingsLoaded extends SettingState {
  final Map<SafetyCategory, int> safetyCategorySettings;

  const SafetyCategorySettingsLoaded(this.safetyCategorySettings);

  @override
  List<Object> get props => [safetyCategorySettings];
}

final class SignOutLoading extends SettingState {}

final class SignOutSuccess extends SettingState {}
