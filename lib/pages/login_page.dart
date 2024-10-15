import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'home_page.dart'; 
import 'register_page.dart';

// The main LoginPage widget, which is a StatefulWidget.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  LoginPageState createState() => LoginPageState(); // Creating the state for LoginPage.
}

class LoginPageState extends State<LoginPage> {
  // Controllers for email and password input fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // GlobalKey to manage the form state.
  final _formKey = GlobalKey<FormState>();
  // A boolean to manage loading state during login.
  bool _isLoading = false;

  // Function to handle login.
  void _login() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      // Show loading indicator.
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Show success message.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to HomePage after successful login.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        // Show error message if login fails.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      } finally {
        // Hide loading indicator.
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  // Function to handle password reset.
  void _forgotPassword() async {
    // Check if email field is empty.
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return; // Exit the function if email is empty.
    }

    try {
      // Send password reset email.
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Show success message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      // Show error message if sending reset email fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $e')),
      );
    }
  }

  // Building the UI for the LoginPage.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 242, 242), 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key for validation.
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                // Logo image at the top.
                Image.asset(
                  'assets/images/reminder.png',
                  height: 150.0, 
                ),
                const SizedBox(height: 32.0),
                // Email text field.
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      // Error message if email is empty.
                      return 'Please enter your email';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 16.0), 
                // Password text field.
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true, // Hide password input
                  validator: (value) {
                    if (value!.isEmpty) {
                      // Error message if password is empty.
                      return 'Please enter your password';
                    }
                    return null; // No error.
                  },
                ),
                const SizedBox(height: 8.0), 
                // "Forgot Password?" button.
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        _forgotPassword, // Call the forgot password function.
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Show loading indicator or login button.
                _isLoading
                  // Show loading indicator if logging in.
                  ? const CircularProgressIndicator() 
                  : ElevatedButton(
                    onPressed: _login, // Call the login function.
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                const SizedBox(height: 20.0), 
                // "Register" button to navigate to the registration page.
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build a text field.
  Widget _buildTextField({
    required TextEditingController controller, // Controller for text input.
    required String label, // Label for the text field.
    bool obscureText = false, // Whether to obscure text (for passwords).
    TextInputType keyboardType = TextInputType.text, // Type of keyboard to use.
    required String? Function(String?)validator, // Validator function for input.
  }) {
    return TextFormField(
      controller: controller, // Assign the controller.
      decoration: InputDecoration(
        labelText: label, // Set the label.
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0)), 
        border: OutlineInputBorder(borderRadius:BorderRadius.circular(8.0), 
        ),
      ),
      obscureText: obscureText, // Whether to obscure text.
      keyboardType: keyboardType, // Set keyboard type.
      style: const TextStyle(
          color: Color.fromARGB(255, 0, 0,0)), 
      validator: validator, // Assign the validator function.
    );
  }
}