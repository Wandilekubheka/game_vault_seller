class FirebaseExceptionHandler extends FormatException {
  final String code;
  FirebaseExceptionHandler(this.code);

  final Map<String, String> authErrorMessages = {
    // Common / Generic
    'unknown': 'An unknown error occurred. Please try again later.',
    'network-request-failed': 'Network error. Check your internet connection.',
    'internal-error': 'Something went wrong. Please try again.',
    'too-many-requests': 'Too many attempts. Please wait and try again.',
    'operation-not-allowed':
        'This sign-in method is not allowed on the server.',

    // Account Creation / Sign Up
    'email-already-in-use':
        'This email is already in use. Try logging in instead.',
    'invalid-email': 'The email address you entered is not valid.',
    'weak-password': 'Your password is too weak. Choose a stronger password.',

    // Sign In
    'user-not-found': 'No account found with this email.',
    'wrong-password': 'The password you entered is incorrect.',
    'invalid-credential': 'Invalid credentials. Please try again.',
    'user-disabled': 'This account has been disabled.',
    'invalid-verification-code': 'Invalid verification code.',
    'invalid-verification-id': 'Invalid verification session. Try again.',
    'account-exists-with-different-credential':
        'This account exists with a different sign-in provider.',

    // Email Verification
    'unverified-email': 'Please verify your email address to continue.',

    // Password Reset
    'missing-email': 'Please enter your email to continue.',
    'invalid-email': 'The email address you entered is not valid.',
    'user-not-found': 'No account is associated with this email.',

    // Updating Email / Password / Sensitive Info
    'requires-recent-login':
        'For security reasons, please log in again to complete this action.',
    'email-change-not-allowed':
        'This email cannot be used. Try a different one.',
    'credential-already-in-use':
        'This credential is already linked to another account.',

    // Reauthentication
    'invalid-user-token': 'Your session expired. Please sign in again.',
    'user-token-expired': 'Your session has expired. Please re-login.',

    // Deleting Account
    'user-mismatch':
        'This credential does not match the currently signed-in user.',
    'provider-already-linked':
        'This provider is already linked to your account.',
    'no-such-provider': 'This provider is not linked to your account.',

    // Phone Auth
    'captcha-check-failed': 'Captcha validation failed. Try again.',
    'missing-phone-number': 'Please enter a valid phone number.',
    'quota-exceeded': 'SMS quota exceeded. Try again later.',
    'session-expired': 'Session expired. Request a new verification code.',

    // Permissions
    'permission-denied': 'You do not have permission to perform this action.',
    'unauthenticated': 'You must be signed in to continue.',

    // Resource Not Found
    'not-found': 'The requested resource was not found.',
  };

  @override
  String get message =>
      authErrorMessages[code] ??
      'An unexpected error occurred. Please try again later.';
}
