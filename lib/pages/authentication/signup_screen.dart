import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/animated_positioned_image.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/widgets/custom_password_field.dart';
import 'package:traintrack/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // services and controllers
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // state Variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRememberMe = true;
  bool _isTermsAccepted = false;
  String _errorMessage = "";

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [_buildHeaderSection(), _buildFormSection()]),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          const AnimatedPositionedImage(
            left: 30,
            width: 80,
            height: 180,
            asset: 'assets/images/light-1.png',
            duration: 4000,
          ),
          const AnimatedPositionedImage(
            left: 140,
            width: 80,
            height: 130,
            asset: 'assets/images/light-2.png',
            duration: 1000,
          ),
          const AnimatedPositionedImage(
            right: 10,
            top: 10,
            width: 80,
            height: 150,
            asset: 'assets/images/logo.png',
            duration: 0,
          ),
          Positioned(
            left: 30,
            top: 200,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: const Text(
                "Create\nNew Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputFields(),
            _buildFormActions(),
            _buildSignUpButton(),
            _buildSignInRedirect(),
          ],
        ),
      ),
    );
  }

  // input fields group
  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: CustomTextField(
            controller: _userNameController,
            hintText: "Username",
            validator: (value) =>
                value!.isEmpty ? "Please Enter Your Username" : null,
          ),
        ),
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: CustomTextField(
            controller: _emailController,
            hintText: "Email",
            validator: (value) =>
                value!.isEmpty ? "Please Enter Your Email" : null,
          ),
        ),
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: CustomPasswordField(
            controller: _passwordController,
            hintText: "Password",
            isVisible: _isPasswordVisible,
            toggleVisibility: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            validator: _validatePassword,
          ),
        ),
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: CustomPasswordField(
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            isVisible: _isConfirmPasswordVisible,
            toggleVisibility: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
            ),
            validator: _validateConfirmPassword,
          ),
        ),
        const SizedBox(height: 10),
        if (_errorMessage.isNotEmpty)
          FadeInLeftBig(
            duration: const Duration(milliseconds: 1400),
            child: Text(
              "❌ $_errorMessage",
              style: const TextStyle(
                color: kRedColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  // form validation methods
  String? _validatePassword(String? value) {
    if (value!.isEmpty) return "Please Enter Valid Password";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value!.isEmpty) return "Please Confirm Your Password";
    if (value != _passwordController.text) return "Passwords do not match";
    return null;
  }

  // checkboxes and form actions
  Widget _buildFormActions() {
    return Column(
      children: [_buildRememberMeCheckbox(), _buildTermsCheckbox()],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            Checkbox(
              value: _isRememberMe,
              activeColor: kSubMainColor,
              side: const BorderSide(color: kGreyColor, width: 1.5),
              onChanged: (value) => setState(() => _isRememberMe = value!),
            ),
            const Text(
              "Remember me for the next time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  activeColor: kSubMainColor,
                  side: const BorderSide(color: kGreyColor, width: 1.5),
                  onChanged: (value) => setState(() {
                    _isTermsAccepted = value!;
                    if (_isTermsAccepted) _errorMessage = "";
                  }),
                ),
                _buildTermsText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return GestureDetector(
      child: const Row(
        children: [
          Text(
            "I agree to the ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kGreyColor,
            ),
          ),
          Text(
            "Terms and Conditions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kSubMainColor,
              decoration: TextDecoration.underline,
              decorationColor: kSubMainColor,
            ),
          ),
        ],
      ),
    );
  }

  // signup button
  Widget _buildSignUpButton() {
    return Column(
      children: [
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              buttonText: "Sign Up",
              buttonColor1: kMainColor,
              buttonColor2: kSubMainColor,
              buttonTextColor: kWhiteColor,
              onPressed: () => {},
            ),
          ),
        ),
      ],
    );
  }

  // sign in redirect
  Widget _buildSignInRedirect() {
    return Column(
      children: [
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 1100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already Have an Account ? ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                ),
              ),
              GestureDetector(
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kSubMainColor,
                    decoration: TextDecoration.underline,
                    decorationColor: kSubMainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
