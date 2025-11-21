import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';
import 'package:game_vault_seller/features/auth/screens/widgets/auth_modal.dart';
import 'package:game_vault_seller/features/auth/screens/widgets/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocBuilder<AuthCupit, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              const Spacer(),
              if (!isKeyboardVisible)
                Image.asset('assets/images/logo.png', height: width * 0.7),

              const Spacer(),
              if (state is LoadingAuthState) const CircularProgressIndicator(),

              _buildLoginForm(state is ErrorAuthState ? state.message : null),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(String? error) {
    final List<CustomTextfield> fields =
        context.read<AuthCupit>().state is! AuthenticatedState
        ? [
            CustomTextfield(
              validator: _validateEmail,
              label: 'Email',
              hint: 'Enter your email',
              controller: _emailController,
            ),
            CustomTextfield(
              validator: _validatePassword,
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              isPassword: true,
            ),
          ]
        : [
            CustomTextfield(
              validator: _validateUsername,
              label: 'Username',
              hint: 'Enter your username',
              controller: _usernameController,
            ),
          ];
    return AuthModal(
      error: error,
      formkey: _loginFormKey,
      title: 'Welcome Back!',

      isShowForgotPassword: true,
      submitButtonText: 'Login',
      onSubmit: () async {
        if (_loginFormKey.currentState?.validate() ?? false) {
          if (!context.mounted) {
            return;
          }
          await context.read<AuthCupit>().loginUser(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            username: _usernameController.text.trim(),
          );
        }
      },
      textFields: fields,
      switchAuthQuestion: "Contact Admin for an account? ",
      switchAuthActionText: 'Request Account',
      onSwitchAuth: () async {
        // whatsapp
        final url = Uri.parse(
          'https://wa.me/+27623250915?text=Hello%20Game%20Vault%20Admin,%20I%20would%20like%20to%20request%20an%20account%20for%20the%20Game%20Vault%20Seller%20app.',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not contact admin')),
          );
        }
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!EmailValidator.validate(value) ||
        !value.contains('@gamevault.com')) {
      return 'Enter a valid email provided by game vault';
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
  }

  String? _validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Passwords do not match';
    }
  }
}
