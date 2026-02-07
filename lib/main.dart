import 'package:flutter/material.dart';
import 'package:tracking_app/core/bloc/my_bloc_observer.dart';
import 'package:tracking_app/tracking_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(const TrackingApp());
}
