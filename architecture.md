# Clean Architecture Structure for SetRise App

## Directory Structure
```
SetRise/
├── core/
│   ├── utils/
│   └── constants/
├── domain/
│   ├── models/
│   └── repositories/
├── data/
│   ├── datasources/
│   ├── repositories/
│   └── mappers/
└── presentation/
    ├── screens/
    ├── widgets/
    ├── themes/
    │   ├── colors.dart
    │   ├── text_styles.dart
    │   └── theme_data.dart
    └── main.dart
```

## Layers Description

### Core Layer
- Contains the essential utilities and constants that can be used throughout the application. 

### Domain Layer
- Holds the business logic of the application. This layer includes:
    - **Models**: Define the data structures used in the app.
    - **Repositories**: Define interfaces for data access.

### Data Layer
- Responsible for data management, which includes:
    - **Datasources**: Manage data retrieval from various sources (API, local, etc.).
    - **Repositories**: Implement the repository interfaces defined in the domain layer.
    - **Mappers**: Convert data from one format to another (e.g., network model to domain model).

### Presentation Layer
- Contains all UI-related code. This layer includes:
    - **Screens**: Define the various screens of the application.
    - **Widgets**: Reusable UI components.
    - **Themes**: Define styles and themes used throughout the app.
        - **colors.dart**: Defines the custom colors for the app.
        - **text_styles.dart**: Defines text styles using Inter font family (100-900).
        - **theme_data.dart**: Combines colors and text styles into a ThemeData object.

## Colors Definition in colors.dart
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color vibrantYellow = Color(0xFFFFEB3B);
  static const Color lightPink = Color(0xFFFFC1D4);
  static const Color lightGreen = Color(0xFFB2FF59);
  static const Color lightBlue = Color(0xFF81D4FA);
}
```

## Text Styles in text_styles.dart
```dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle inter100 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w100);
  static const TextStyle inter200 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w200);
  static const TextStyle inter300 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300);
  // Add more styles for weights 400 - 900
}
```

## theme_data.dart
```dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.vibrantYellow,
    accentColor: AppColors.lightPink,
    textTheme: TextTheme(
      bodyText1: AppTextStyles.inter400,
      // More text styles can be added here
    ),
  );
}
```