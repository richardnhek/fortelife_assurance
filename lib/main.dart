import 'package:flutter/material.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/parameters_provider.dart';
import 'app_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ParametersProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      )
    ], child: AppController());
  }
}
