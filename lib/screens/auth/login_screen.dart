import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/models/user.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:forte_life/widgets/error_dialog.dart';
import 'package:forte_life/widgets/loading_modal.dart';
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
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: ErrorDialog(
                details: message,
                onActionButtonPressed: () => Navigator.of(context).pop(),
              ),
            ));
  }

  Future<void> _onSignInPress(scaffoldContext) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print('account : ' + _accountController.text);
    print('password : ' + _passwordController.text);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
      _showErrorDialog("Username and Password Can't Be Empty");
    } else {
      try {
        User agent = await authProvider.login(
            username: _accountController.text,
            password: _passwordController.text);

        // TODO: Prompt user to change password if password is default password (123456)
        if (_passwordController.text == "123456") {}

        Navigator.of(loadingModalContext).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('/main_flow');
        prefs.setString(AGENT_USERNAME, agent.username);
        prefs.setString(AGENT_ID, agent.id);
      } catch (error) {
        Navigator.of(loadingModalContext).pop();
        _showErrorDialog(error.message);
      }
    }
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
