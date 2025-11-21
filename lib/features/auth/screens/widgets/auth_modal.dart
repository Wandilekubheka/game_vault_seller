import 'package:flutter/material.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';
import 'package:game_vault_seller/features/auth/screens/widgets/custom_textfield.dart';

class AuthModal extends StatelessWidget {
  final String title;
  final bool isShowForgotPassword;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final List<CustomTextfield> textFields;
  final String switchAuthQuestion;
  final String switchAuthActionText;
  final VoidCallback onSwitchAuth;
  final VoidCallback? onForgotPassword;
  final Key formkey;
  final String? error;
  const AuthModal({
    super.key,
    required this.title,
    required this.isShowForgotPassword,
    required this.submitButtonText,
    required this.onSubmit,
    required this.textFields,
    required this.switchAuthQuestion,
    required this.switchAuthActionText,
    required this.onSwitchAuth,
    this.onForgotPassword,
    required this.formkey,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Form(
        key: formkey,
        child: Material(
          elevation: 4,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Color(AppColors.border),
                      fontSize: 28,
                    ),
                  ),
                ),
                ...textFields.map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: field,
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    submitButtonText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$switchAuthQuestion '),
                    GestureDetector(
                      onTap: onSwitchAuth,
                      child: Text(
                        switchAuthActionText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
