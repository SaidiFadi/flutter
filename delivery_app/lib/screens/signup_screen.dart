import 'package:flutter/material.dart';
import 'package:delivery_app/screens/home_screen.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtAddress = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();

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
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                "Add your details to sign up",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtName,
                decoration: const InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtEmail,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtMobile,
                decoration: const InputDecoration(
                  hintText: "Mobile No",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtAddress,
                decoration: const InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
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
              TextField(
                controller: txtConfirmPassword,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text("Sign Up"),
                onPressed: btnSignUp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Already have an Account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Login",
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

  void btnSignUp() {
    if (txtName.text.isEmpty) {
      showSnackBar("Please enter your name");
      return;
    }

    if (!isValidEmail(txtEmail.text)) {
      showSnackBar("Please enter a valid email");
      return;
    }

    if (txtMobile.text.isEmpty) {
      showSnackBar("Please enter your mobile number");
      return;
    }

    if (txtAddress.text.isEmpty) {
      showSnackBar("Please enter your address");
      return;
    }

    if (txtPassword.text.length < 6) {
      showSnackBar("Password must be at least 6 characters");
      return;
    }

    if (txtPassword.text != txtConfirmPassword.text) {
      showSnackBar("Passwords do not match");
      return;
    }

    // Print sign up info (remove this in production)
    print("Sign Up with: ${txtName.text}, ${txtEmail.text}, ${txtMobile.text}, ${txtAddress.text}");

    // Navigate to Home Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}