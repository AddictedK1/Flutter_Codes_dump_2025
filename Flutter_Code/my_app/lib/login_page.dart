import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  String msg = "text";
  Color msgColor = Colors.purple;
  TextEditingController userTxtCtl = TextEditingController();
  TextEditingController pwdTxtCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('from build');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 50, color: Colors.deepPurple),
            ),
            // Text('Username'),
            TextField(
              controller: userTxtCtl,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            // Text('Password'),
            TextField(
              controller: pwdTxtCtl,
              obscureText: isHidden,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                prefixIcon: Icon(Icons.key),
                suffixIcon: IconButton(
                  onPressed: () {
                    isHidden = !isHidden;
                    print(isHidden);
                    setState(() {});
                  },
                  icon: Icon(Icons.visibility_off),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (userTxtCtl.text == pwdTxtCtl.text) {
                  print('Welcome ${userTxtCtl.text}');
                  msg = 'Welcome ${userTxtCtl.text}';
                  msgColor = Colors.green;
                } else {
                  msg = 'Invalid credentials';
                  msgColor = Colors.red;
                }
                setState(() {});
              },
              child: Text('Login'),
            ),
            Text(msg , style: TextStyle(
              color: msgColor,
            ),  ),
          ],
        ),
      ),
    );
  }
}
