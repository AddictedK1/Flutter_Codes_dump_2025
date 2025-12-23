# Multi-Theme Switcher

A Flutter application demonstrating a comprehensive theme management system with three beautiful predefined themes.

## Features

### 🎨 Three Predefined Themes

1. **Light Theme** - Clean and bright interface with blue primary colors
2. **Dark Theme** - Easy on the eyes with dark gray color scheme
3. **Custom Blue Theme** - Soothing blue color palette with sky blue accents

### ⚡ Key Capabilities

- **Instant Theme Switching** - Change themes on-the-fly with immediate visual feedback using `setState`
- **Persistent Storage** - Theme preferences are saved using `shared_preferences` and restored on app restart
- **Custom Color Schemes** - Each theme features carefully crafted color properties:
  - Primary Color
  - Secondary/Accent Color
  - Background Color
  - Surface Color
  - Text Colors

### 🎯 UI Components

The app showcases theme effects across multiple UI elements:

- **AppBar** with theme-specific colors
- **Buttons** (Elevated, Outlined, Text)
- **Cards** with custom elevation and borders
- **Typography** with various text styles (Display, Headline, Body)
- **Icons** with theme-aware colors
- **Color Preview** showing hex codes for each theme color

### ⚙️ Settings Page

- RadioButtons for theme selection
- Visual preview of each theme with icons and descriptions
- Live color swatches showing primary, secondary, and background colors

### 🏠 Home Page Features

- Welcome card with theme information
- Theme color display with hex codes
- Button style demonstrations
- Feature highlight cards
- Typography showcase
- Quick theme switcher with icon buttons
- Floating action button for easy settings access

## Project Structure

```
lib/
├── main.dart           # App entry point with StatefulWidget for theme management
├── themes.dart         # ThemeData configurations for all three themes
├── theme_provider.dart # Theme state management (alternative provider approach)
├── home_page.dart      # Main content page displaying theme effects
└── settings_page.dart  # Theme selection page with RadioButtons
```

## Implementation Details

### Theme Configuration

Each theme is defined with complete `ThemeData` including:

- `ColorScheme` with primary, secondary, background, surface colors
- `AppBarTheme` with custom colors and text styles
- `CardThemeData` with elevation, shadows, and borders
- `ElevatedButtonThemeData` with custom styling
- `TextTheme` with multiple text style variants

### State Management

The app uses `setState` for immediate theme updates:

- Theme selection is stored in app state
- `shared_preferences` persists the selection
- Theme changes trigger full app rebuild with new `ThemeData`

### Persistent Storage

- Uses `shared_preferences` package
- Stores theme selection as integer index
- Loads saved theme on app startup
- Automatic fallback to Light theme if no preference exists

## Getting Started

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

```bash
flutter run
```

Select your target device (Android, iOS, Web, Desktop) when prompted.

## Usage

1. **Launch the app** - Opens with the last selected theme (or Light theme by default)
2. **Explore the home page** - View various UI components styled with the current theme
3. **Access settings** - Tap the settings icon in the AppBar or the floating action button
4. **Select a theme** - Choose from Light, Dark, or Custom Blue using RadioButtons
5. **See instant changes** - The theme updates immediately across the entire app
6. **Restart the app** - Your theme preference is saved and restored automatically

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.3.4
```

## Theme Customization

To add a new theme:

1. Add a new enum value in `themes.dart`:

   ```dart
   enum AppTheme {
     light,
     dark,
     customBlue,
     yourNewTheme, // Add here
   }
   ```

2. Create a new `ThemeData` configuration:

   ```dart
   static ThemeData yourNewTheme = ThemeData(
     // Your theme configuration
   );
   ```

3. Update the `getThemeFromEnum` and `getThemeName` methods
4. Add a new RadioButton option in `settings_page.dart`

## License

This project is a Flutter mini-project for learning purposes.

## Screenshots

The app demonstrates:

- Smooth theme transitions
- Consistent styling across all components
- Professional color schemes
- User-friendly theme selection interface
