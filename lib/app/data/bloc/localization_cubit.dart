import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit() : super(const Locale('vi')); // Mặc định là tiếng Việt

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }
}
