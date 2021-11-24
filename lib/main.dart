import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/features/app/widget/app.dart';
import 'package:fluttercommerce/features/common/bloc/app_cubit_observer.dart';
import 'package:fluttercommerce/features/module_init.dart';
import 'package:fluttercommerce/core/utils/crashlytics_service.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    ModuleInit.registerModules();
    Bloc.observer = MyBlocObserver();
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = CrashlyticsService.recordFlutterError;
    runApp(const App());
  }, (error, stack) {
    CrashlyticsService.recordError(error, stack);
  }, zoneSpecification: const ZoneSpecification());
}
