import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'admin_dashboard_activity.dart';
import 'create_admin_account_activity.dart';

class AdminLoginActivity extends StatefulWidget {
  @override
  _AdminLoginActivityState createState() => _AdminLoginActivityState();
}

class _AdminLoginActivityState extends State<AdminLoginActivity> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool isValid = await _dbHelper.checkAdminCredentials(username, password);
    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardActivity()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAdminAccountActivity()),
                );
              },
              child: Text('Create Account?'),
            ),
          ],
        ),
      ),
    );
  }
}
