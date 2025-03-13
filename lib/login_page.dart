import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  // The Appwrite client instance is passed in so that it's available here.
  final Client client;

  const LoginPage({Key? key, required this.client}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create an instance of the Appwrite Account service.
  late Account account;

  @override
  void initState() {
    super.initState();
    // Initialize Appwrite Account using the passed client.
    account = Account(widget.client);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // This function calls the Appwrite authentication endpoint to
  // create an email session and log in the user.
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create an email session using the provided credentials.
        final session = await account.createEmailPasswordSession(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // If the session is created successfully, navigate to the HomePage.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(client: widget.client),
          ),
        );
      } on AppwriteException catch (e) {
        // If Appwrite returns an error, display it.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Login failed.'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        // Any other error is caught here.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          // ListView handles small screens and keyboard appearance gracefully.
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Obscure text for password input.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _loginUser, child: const Text('Login')),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(client: widget.client),
                    ),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
