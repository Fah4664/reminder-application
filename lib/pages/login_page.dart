import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication package
import 'home_page.dart'; // Importing HomePage widget
import 'register_page.dart'; // Importing RegisterPage widget

// The main LoginPage widget, which is a StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  LoginPageState createState() => LoginPageState(); // Creating the state for LoginPage
}

class LoginPageState extends State<LoginPage> {
  // Controllers for email and password input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // GlobalKey to manage the form state
  final _formKey = GlobalKey<FormState>();

  // A boolean to manage loading state during login
  bool _isLoading = false;

  // Function to handle login
  void _login() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        // Show error message if login fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      } finally {
        // Hide loading indicator
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  // Function to handle password reset
  void _forgotPassword() async {
    // Check if email field is empty
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return; // Exit the function if email is empty
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      // Show error message if sending reset email fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $e')),
      );
    }
  }

  // Building the UI for the LoginPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 246, 242, 242), // Set background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the form
          child: Form(
            key: _formKey, // Assign the form key for validation
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize the size of the column
              children: [
                // Logo image at the top
                Image.asset(
                  'assets/images/reminder.png',
                  height: 150.0, // Set image height
                ),
                const SizedBox(height: 32.0), // Space between widgets
                // Email text field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email'; // Error message if email is empty
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 16.0), // Space between widgets
                // Password text field
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true, // Hide password input
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password'; // Error message if password is empty
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 8.0), // Space between widgets
                // "Forgot Password?" button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        _forgotPassword, // Call the forgot password function
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), // Text color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Space between widgets
                // Show loading indicator or login button
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator if logging in
                    : ElevatedButton(
                        onPressed: _login, // Call the login function
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(
                                255, 0, 0, 0), // Button text color
                          ),
                        ),
                      ),
                const SizedBox(height: 20.0), // Space between widgets
                // "Register" button to navigate to the registration page
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
                      color: Color.fromARGB(255, 0, 0, 0), // Text color
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

  // Function to build a text field
  Widget _buildTextField({
    required TextEditingController controller, // Controller for text input
    required String label, // Label for the text field
    bool obscureText = false, // Whether to obscure text (for passwords)
    TextInputType keyboardType = TextInputType.text, // Type of keyboard to use
    required String? Function(String?)
        validator, // Validator function for input
  }) {
    return TextFormField(
      controller: controller, // Assign the controller
      decoration: InputDecoration(
        labelText: label, // Set the label
        labelStyle: const TextStyle(
            color: Color.fromARGB(
                255, 0, 0, 0)), // Label text color / สีตัวอักษร Label
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Rounded corners for the border
        ),
      ),
      obscureText: obscureText, // Whether to obscure text
      keyboardType: keyboardType, // Set keyboard type
      style: const TextStyle(
          color: Color.fromARGB(255, 0, 0,
              0)), // Text color in the TextField // สีตัวอักษรใน TextField
      validator: validator, // Assign the validator function
    );
  }
}
