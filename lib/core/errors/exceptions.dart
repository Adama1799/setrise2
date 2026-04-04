/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  const AppException({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Server exception
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.data,
  });

  factory ServerException.fromResponse(dynamic response) {
    final statusCode = response.statusCode ?? 500;
    final message = response.data?['message'] ?? 'Server error occurred';
    
    return ServerException(
      message: message,
      code: statusCode,
      data: response.data,
    );
  }
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.data,
  });

  factory CacheException.read() {
    return const CacheException(message: 'Failed to read from cache');
  }

  factory CacheException.write() {
    return const CacheException(message: 'Failed to write to cache');
  }

  factory CacheException.delete() {
    return const CacheException(message: 'Failed to delete from cache');
  }
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.data,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection',
      code: 0,
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Request timeout',
      code: 408,
    );
  }

  factory NetworkException.badRequest() {
    return const NetworkException(
      message: 'Bad request',
      code: 400,
    );
  }
}

/// Authentication exception
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.data,
  });

  factory AuthenticationException.invalidCredentials() {
    return const AuthenticationException(
      message: 'Invalid email or password',
      code: 401,
    );
  }

  factory AuthenticationException.tokenExpired() {
    return const AuthenticationException(
      message: 'Session expired. Please login again',
      code: 401,
    );
  }

  factory AuthenticationException.unauthorized() {
    return const AuthenticationException(
      message: 'Unauthorized access',
      code: 401,
    );
  }
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.data,
  });

  factory ValidationException.invalidEmail() {
    return const ValidationException(message: 'Invalid email address');
  }

  factory ValidationException.invalidPassword() {
    return const ValidationException(
      message: 'Password must be at least 8 characters',
    );
  }

  factory ValidationException.emptyField(String fieldName) {
    return ValidationException(message: '$fieldName cannot be empty');
  }
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code = 404,
    super.data,
  });

  factory NotFoundException.user() {
    return const NotFoundException(message: 'User not found');
  }

  factory NotFoundException.post() {
    return const NotFoundException(message: 'Post not found');
  }

  factory NotFoundException.resource(String resource) {
    return NotFoundException(message: '$resource not found');
  }
}

/// Conflict exception
class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.code = 409,
    super.data,
  });

  factory ConflictException.userExists() {
    return const ConflictException(message: 'User already exists');
  }

  factory ConflictException.emailTaken() {
    return const ConflictException(message: 'Email already taken');
  }
}

/// Permission exception
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code = 403,
    super.data,
  });

  factory PermissionException.camera() {
    return const PermissionException(message: 'Camera permission denied');
  }

  factory PermissionException.storage() {
    return const PermissionException(message: 'Storage permission denied');
  }

  factory PermissionException.denied(String permission) {
    return PermissionException(message: '$permission permission denied');
  }
}

/// Parse exception
class ParseException extends AppException {
  const ParseException({
    required super.message,
    super.code,
    super.data,
  });

  factory ParseException.json() {
    return const ParseException(message: 'Failed to parse JSON data');
  }

  factory ParseException.data() {
    return const ParseException(message: 'Failed to parse data');
  }
}

/// Timeout exception
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code = 408,
    super.data,
  });

  factory TimeoutException.request() {
    return const TimeoutException(message: 'Request timeout');
  }

  factory TimeoutException.connection() {
    return const TimeoutException(message: 'Connection timeout');
  }
}
