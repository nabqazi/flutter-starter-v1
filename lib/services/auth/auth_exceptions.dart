// Login

// class UserNotFoundAuthException implements Exception {
//   final String message;
//   UserNotFoundAuthException(this.message);
// }

class UserNotFoundOrWrongPasswordAuthException implements Exception {
  final String message;

  UserNotFoundOrWrongPasswordAuthException(this.message);
}

// register exceptions

class WeakPasswordAuthException implements Exception {
  final String message;

  WeakPasswordAuthException(this.message);
}

class EmailAlreadyInUseAuthException implements Exception {
  final String message;

  EmailAlreadyInUseAuthException(this.message);
}

class InvalidEmailAuthException implements Exception {
  final String message;

  InvalidEmailAuthException(this.message);
}

// generic exceptions

class UnknownAuthException implements Exception {
  final String message;

  UnknownAuthException(this.message);
}

class UserNotLoggedInAuthException implements Exception {
  final String message;

  UserNotLoggedInAuthException(this.message);
}
