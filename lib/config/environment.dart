import 'package:flutter/foundation.dart';

/// Environment configuration
enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  /// Initialize environment
  static void init(Environment env) {
    _environment = env;
  }

  /// Get current environment
  static Environment get current => _environment;

  /// Check if development
  static bool get isDevelopment => _environment == Environment.development;

  /// Check if staging
  static bool get isStaging => _environment == Environment.staging;

  /// Check if production
  static bool get isProduction => _environment == Environment.production;

  /// Get API base URL based on environment
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.setrise.com';
      case Environment.staging:
        return 'https://staging-api.setrise.com';
      case Environment.production:
        return 'https://api.setrise.com';
    }
  }

  /// Get WebSocket URL based on environment
  static String get wsBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'wss://dev-ws.setrise.com';
      case Environment.staging:
        return 'wss://staging-ws.setrise.com';
      case Environment.production:
        return 'wss://ws.setrise.com';
    }
  }

  /// Get app name with environment suffix
  static String get appName {
    switch (_environment) {
      case Environment.development:
        return 'SetRise Dev';
      case Environment.staging:
        return 'SetRise Staging';
      case Environment.production:
        return 'SetRise';
    }
  }

  /// Enable/disable analytics based on environment
  static bool get analyticsEnabled {
    return _environment == Environment.production;
  }

  /// Enable/disable crash reporting based on environment
  static bool get crashReportingEnabled {
    return _environment == Environment.production || _environment == Environment.staging;
  }

  /// Enable/disable debug logging
  static bool get debugLoggingEnabled {
    return _environment == Environment.development || kDebugMode;
  }

  /// API timeout duration based on environment
  static Duration get apiTimeout {
    switch (_environment) {
      case Environment.development:
        return const Duration(seconds: 60); // Longer timeout for debugging
      case Environment.staging:
        return const Duration(seconds: 45);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }

  /// Cache expiration based on environment
  static Duration get cacheExpiration {
    switch (_environment) {
      case Environment.development:
        return const Duration(minutes: 5); // Short cache for development
      case Environment.staging:
        return const Duration(hours: 1);
      case Environment.production:
        return const Duration(hours: 24);
    }
  }

  /// Get all environment variables as map
  static Map<String, dynamic> get variables {
    return {
      'environment': _environment.toString(),
      'apiBaseUrl': apiBaseUrl,
      'wsBaseUrl': wsBaseUrl,
      'appName': appName,
      'analyticsEnabled': analyticsEnabled,
      'crashReportingEnabled': crashReportingEnabled,
      'debugLoggingEnabled': debugLoggingEnabled,
      'apiTimeout': apiTimeout.inSeconds,
      'cacheExpiration': cacheExpiration.inHours,
    };
  }

  /// Print environment info (debug only)
  static void printInfo() {
    if (kDebugMode) {
      print('═══════════════════════════════════════════════');
      print('🌍 Environment Configuration');
      print('═══════════════════════════════════════════════');
      print('Environment: ${_environment.name}');
      print('API Base URL: $apiBaseUrl');
      print('WebSocket URL: $wsBaseUrl');
      print('App Name: $appName');
      print('Analytics: ${analyticsEnabled ? 'Enabled' : 'Disabled'}');
      print('Crash Reporting: ${crashReportingEnabled ? 'Enabled' : 'Disabled'}');
      print('Debug Logging: ${debugLoggingEnabled ? 'Enabled' : 'Disabled'}');
      print('API Timeout: ${apiTimeout.inSeconds}s');
      print('Cache Expiration: ${cacheExpiration.inHours}h');
      print('═══════════════════════════════════════════════');
    }
  }
}
