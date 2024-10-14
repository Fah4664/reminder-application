import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

// This class represents the registration page.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // Creates the state for the registration page.
  RegisterPageState createState() => RegisterPageState();
}

// State class for RegisterPage.
class RegisterPageState extends State<RegisterPage> {
  // Controllers to handle user input.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Key for form validation.
  final _formKey = GlobalKey<FormState>();
  // Loading state to show progress indicator during registration.
  bool _isLoading = false;

  // Function to handle registration logic.
  void _register() async {
    // Validate the form input.
    if (_formKey.currentState!.validate()) {
      // Set loading state to true.
      setState(() {
        _isLoading = true;
      });

      try {
        // Create a new user with email and password.
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Get the user object and UID.
        final User? user = userCredential.user;
        final String? uid = user?.uid;

        // If UID is not null, save user's name and email to Firestore.
        if (uid != null) {
          // เก็บชื่อและเมลลงใน Cloud Firestore.
          await FirebaseFirestore.instance.collection('usersID').doc(uid).set({
            'name': _nameController.text,
            'email': _emailController.text,
          });
        }

        // Show success message and navigate to LoginPage.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          // Navigate to the login page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        // Handle registration errors.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      } finally {
        // Reset loading state.
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color for the registration page.
      backgroundColor: const Color.fromARGB(255, 246, 242, 242),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key for validation.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo image
                Image.asset(
                  'assets/images/reminder.png',
                  height: 150.0,
                ),
                const SizedBox(height: 32.0),
                // Name text field with validation.
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null; // Valid input.
                  },
                ),
                const SizedBox(height: 16.0),
                // Email text field with validation.
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null; // Valid input.
                  },
                ),
                const SizedBox(height: 16.0),
                // Password text field with validation.
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true, // Hide password input.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null; // Valid input.
                  },
                ),
                const SizedBox(height: 32.0),
                // Show loading indicator or register button.
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register, // Call register function.
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                const SizedBox(height: 20.0),
                // Text button to navigate to LoginPage.
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Log in',
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

  // Function to build a text field for name, email, and password
  Widget _buildTextField({
    required TextEditingController controller, // Controller for text input
    required String label, // Label for the text field
    bool obscureText = false, // Whether to obscure text (for passwords)
    TextInputType keyboardType = TextInputType.text, // Type of keyboard to use
    required String? Function(String?) validator, // Validator function for input
  }) {
    return TextFormField(
      controller: controller, // Assign the controller
      decoration: InputDecoration(
        labelText: label, // Set the label
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0), // Label text color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
        ),
      ),
      obscureText: obscureText, // Whether to obscure text
      keyboardType: keyboardType, // Set keyboard type
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0), // Text color in the TextField
      ),
      validator: validator, // Assign the validator function
    );
  }
}
