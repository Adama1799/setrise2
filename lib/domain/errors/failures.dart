/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final int? code;
  final dynamic data;

  const Failure({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory ServerFailure.fromCode(int code) {
    switch (code) {
      case 400:
        return const ServerFailure(message: 'Bad Request', code: 400);
      case 401:
        return const ServerFailure(message: 'Unauthorized', code: 401);
      case 403:
        return const ServerFailure(message: 'Forbidden', code: 403);
      case 404:
        return const ServerFailure(message: 'Not Found', code: 404);
      case 500:
        return const ServerFailure(message: 'Internal Server Error', code: 500);
      case 503:
        return const ServerFailure(message: 'Service Unavailable', code: 503);
      default:
        return ServerFailure(message: 'Server Error', code: code);
    }
  }
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory CacheFailure.read() {
    return const CacheFailure(message: 'Failed to read from cache');
  }

  factory CacheFailure.write() {
    return const CacheFailure(message: 'Failed to write to cache');
  }

  factory CacheFailure.delete() {
    return const CacheFailure(message: 'Failed to delete from cache');
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection',
      code: 0,
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Request timeout',
      code: 408,
    );
  }

  factory NetworkFailure.unknown() {
    return const NetworkFailure(
      message: 'Unknown network error',
    );
  }
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(message: 'Invalid email address');
  }

  factory ValidationFailure.invalidPassword() {
    return const ValidationFailure(
      message: 'Password must be at least 8 characters',
    );
  }

  factory ValidationFailure.invalidUsername() {
    return const ValidationFailure(
      message: 'Username must be at least 3 characters',
    );
  }

  factory ValidationFailure.emptyField(String fieldName) {
    return ValidationFailure(message: '$fieldName cannot be empty');
  }
}

/// Authentication-related failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory UnauthorizedFailure.tokenExpired() {
    return const UnauthorizedFailure(
      message: 'Session expired. Please login again',
      code: 401,
    );
  }

  factory UnauthorizedFailure.invalidCredentials() {
    return const UnauthorizedFailure(
      message: 'Invalid email or password',
      code: 401,
    );
  }

  factory UnauthorizedFailure.accessDenied() {
    return const UnauthorizedFailure(
      message: 'Access denied',
      code: 403,
    );
  }
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory PermissionFailure.camera() {
    return const PermissionFailure(message: 'Camera permission denied');
  }

  factory PermissionFailure.storage() {
    return const PermissionFailure(message: 'Storage permission denied');
  }

  factory PermissionFailure.microphone() {
    return const PermissionFailure(message: 'Microphone permission denied');
  }

  factory PermissionFailure.location() {
    return const PermissionFailure(message: 'Location permission denied');
  }
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code = 404,
    super.data,
  });

  factory NotFoundFailure.user() {
    return const NotFoundFailure(message: 'User not found');
  }

  factory NotFoundFailure.post() {
    return const NotFoundFailure(message: 'Post not found');
  }

  factory NotFoundFailure.thread() {
    return const NotFoundFailure(message: 'Thread not found');
  }
}

/// Conflict failures
class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.code = 409,
    super.data,
  });

  factory ConflictFailure.userExists() {
    return const ConflictFailure(message: 'User already exists');
  }

  factory ConflictFailure.emailTaken() {
    return const ConflictFailure(message: 'Email already taken');
  }

  factory ConflictFailure.usernameTaken() {
    return const ConflictFailure(message: 'Username already taken');
  }
}
