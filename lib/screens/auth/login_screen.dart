import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/models/user.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:forte_life/widgets/error_dialog.dart';
import 'package:forte_life/widgets/loading_modal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen_ui.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _accountController = new TextEditingController(text: '');
  final _passwordController = new TextEditingController(text: '');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void _showErrorDialog(String message) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final mq = MediaQuery.of(context);
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: ErrorDialog(
                appProvider: appProvider,
                mq: mq,
                details: message,
                onActionButtonPressed: () => Navigator.of(context).pop(),
              ),
            ));
  }

  String getErrorMessage(String errorMsg) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (errorMsg == "Unable to connect to the server") {
      return lang['server_disc'];
    } else if (errorMsg == "Incorrect Username or Password") {
      return lang['incorrect_creds'];
    } else if (errorMsg == "This Account Has Been Suspended") {
      return lang['suspended'];
    } else {
      return lang['unknown_error'];
    }
  }

  Future<void> _onSignInPress(scaffoldContext) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;

    BuildContext loadingModalContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        loadingModalContext = context;
        return LoadingModal();
      },
    );

    if (_accountController.text.isEmpty || _passwordController.text.isEmpty) {
      Navigator.of(context).pop();
      _showErrorDialog(lang['empty_creds']);
    } else {
      try {
        User agent = await authProvider.login(
            username: _accountController.text,
            password: _passwordController.text);
        prefs.setString(AGENT_USERNAME, agent.username);
        prefs.setString(AGENT_ID, agent.id);
        prefs.setString(
            LOGIN_DATE, convertDateTimeDisplay(DateTime.now().toString()));
        if (_passwordController.text == "1234") {
          Navigator.popAndPushNamed(context, "/change_pass");
        } else {
          await appProvider.getRider();

          Navigator.of(loadingModalContext).pop();
          Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.of(context).pushReplacementNamed('/main_flow');
        }
      } catch (error) {
        print(error);
        Navigator.of(loadingModalContext).pop();
        _showErrorDialog(getErrorMessage(error.message));
      }
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormatter.parse(date);
    final String formatted = serverFormatter.format(displayDate);
    return formatted;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreenUI(
      usernameController: _accountController,
      passwordController: _passwordController,
      scaffoldKey: _scaffoldKey,
      onSignInPress: _onSignInPress,
    );
  }
}
