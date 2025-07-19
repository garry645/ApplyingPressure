import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/service_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;
  bool _isSuccess = false;

  final inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
    ),
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                const Text('Email'),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration.copyWith(hintText: 'Enter your email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildSubmitButton(),
                const SizedBox(height: 20),
                _buildMessageDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 83, 80, 80),
                ),
              ),
              onPressed: _handlePasswordReset,
              child: const Text(
                'Send Password Reset Email',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
  }

  Widget _buildMessageDisplay() {
    if (_message.isEmpty) return const SizedBox.shrink();
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isSuccess ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _message,
          style: TextStyle(
            color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
      _isError = false;
      _isSuccess = false;
    });

    try {
      final authService = ServiceProvider.getAuthService(context);
      await authService.sendPasswordResetEmail(email: _emailController.text.trim());
      
      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _message = 'Password reset email sent! Please check your inbox.';
      });
      
      // Clear the email field after success
      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _message = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _message = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}