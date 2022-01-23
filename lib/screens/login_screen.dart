import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readme/api/megz_readme_api.dart';
import '../models/models.dart';

class LoginScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: ReadmePages.loginPath,
        key: ValueKey(ReadmePages.loginPath),
        child: LoginScreen());
  }

  LoginScreen({
    Key? key,
  }) : super(key: key);

  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);

  var username = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
                child: Image(
                  image: AssetImage(
                    'assets/splash.png',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildTextfield('Username', username),
              const SizedBox(height: 16),
              buildTextfield('Password', password),
              const SizedBox(height: 16),
              buildButton(context, 'Login'),
              /*const SizedBox(height: 16),
              buildButton(context, 'Register'),*/
              const SizedBox(height: 16),
              buildButton(context, 'Skip'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String btnText) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: rwColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (btnText == 'Skip') {
            Provider.of<AppStateManager>(context, listen: false).loginAsGuest();
          } else if (btnText == 'Login') {
            if (await MegzReadmeApi()
                .checkUserExist(username.text, password.text)) {
              Provider.of<AppStateManager>(context, listen: false)
                  .loginWithSession(await MegzReadmeApi()
                      .getProfileData(username.text, password.text));
              Provider.of<AppStateManager>(context, listen: false)
                  .logInAndStoreInSession();
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text(
                        "Incorrect login info!",
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                          "Try again, or skip to enter without an account :)"),
                    );
                  });
            }
          }
        },
      ),
    );
  }

  Widget buildTextfield(String hintText, TextEditingController loginInfo) {
    return TextField(
      obscureText: hintText == 'Password' ? true : false,
      controller: loginInfo,
      cursorColor: rwColor,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(height: 0.5),
      ),
    );
  }
}
