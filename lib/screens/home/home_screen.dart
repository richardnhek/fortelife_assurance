import 'package:flutter/material.dart';
import 'home_screen_ui.dart';
import 'package:forte_life/screens/calculation/calculation_protect.dart';
import 'package:forte_life/screens/calculation/calculation_education.dart';
import 'package:provider/provider.dart';
import 'package:forte_life/providers/app_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final homeTab = [
    HomeScreenUI(),
    CalculationProtect(),
    CalculationEducation()
  ];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: homeTab[appProvider.categoriesTabIndex],
    );
  }
}
