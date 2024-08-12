import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              const Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                "Add your details to login",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtEmail,
                decoration: const InputDecoration(
                  hintText: "Your Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtPassword,
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: btnLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  // Navigate to Reset Password Screen
                },
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "or Login With",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.facebook),
                label: const Text("Login with Facebook"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff367FC0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text("Login with Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffDD4B39),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 80),
              TextButton(
                onPressed: () {
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpView()),
    );                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Don't have an Account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void btnLogin() {
  if (!isValidEmail(txtEmail.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid email")),
    );
    return;
  }

  if (txtPassword.text.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password must be at least 6 characters")),
    );
    return;
  }

  // Print login info (remove this in production)
  print("Login with: ${txtEmail.text} and ${txtPassword.text}");

  // Navigate to Home Screen
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
}