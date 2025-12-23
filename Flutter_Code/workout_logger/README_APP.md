# Workout Logger App

A comprehensive fitness tracker Flutter application with workout entry, history tracking, and detailed statistics.

## Features

### 📝 Workout Entry Form

- **Exercise dropdown** with 12 exercise types (Running, Cycling, Swimming, Weightlifting, Yoga, etc.)
- **Duration slider** (0-120 minutes) with visual feedback
- **Calories text field** with validation
- **Date picker** to log past workouts
- Edit and update existing workouts

### 📊 Dashboard Screen

- **Streak Counter**: Shows consecutive workout days with fire icon
- **Monthly Statistics Card**:
  - Total workouts, minutes, and calories
  - Average minutes and calories per workout
- **7-Day Bar Chart**: Visual representation of workout minutes using Container heights
- **Exercise Breakdown**: Progress bars showing most popular exercises
- Pull to refresh functionality
- Floating action button to add new workouts

### 📜 Workout History

- **Grouped by Week**: ListView showing workouts organized by week
- **Weekly Summary Cards**: Display total workouts, minutes, and calories for each week
- **Filter Options**:
  - Filter by exercise type
  - Filter by date range (start/end dates)
  - Clear filters option
- **Workout Management**:
  - Edit existing workouts
  - Delete workouts with confirmation
  - Pull to refresh
- Color-coded icons for different exercise types

### 💾 Data Storage

- Workouts stored as JSON in `shared_preferences`
- Persistent data across app sessions
- CRUD operations (Create, Read, Update, Delete)

### 📈 Statistics & Analytics

- **Streak Calculation**: Tracks consecutive workout days
- **Monthly Statistics**:
  - Total and average metrics
  - Most popular exercise
  - Exercise frequency breakdown
- **Weekly Summaries**: Aggregated data by week
- **7-Day Trends**: Recent workout patterns

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── workout.dart                   # Workout data model and ExerciseType list
├── services/
│   └── workout_storage.dart           # SharedPreferences storage service
├── utils/
│   └── statistics.dart                # Statistics calculations (streaks, weekly/monthly stats)
└── screens/
    ├── dashboard_screen.dart          # Main screen with stats, chart, and streaks
    ├── workout_entry_screen.dart      # Form to add/edit workouts
    └── workout_history_screen.dart    # History with filters and weekly grouping
```

## Dependencies

- `shared_preferences: ^2.3.3` - Local data storage
- `intl: ^0.20.1` - Date formatting

## How to Run

1. Ensure Flutter is installed and configured
2. Navigate to the project directory:
   ```bash
   cd workout_logger
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Add a Workout**: Tap the floating action button on the dashboard
2. **View History**: Tap the history icon in the app bar
3. **Filter Workouts**: Use the filter icon in history screen
4. **Edit/Delete**: Tap the three-dot menu on any workout
5. **View Stats**: Dashboard automatically shows current month statistics

## Key Features Implementation

### Bar Chart (Container-based)

- Uses `Container` widgets with dynamic heights
- Last 7 days of workout minutes
- Shows day of week labels (M, T, W, etc.)
- Visual feedback with minutes displayed above bars

### Streak Calculation

- Tracks consecutive workout days
- Must workout today or yesterday to maintain streak
- Resets if gap is detected

### Weekly Grouping

- Groups workouts by week (Monday-Sunday)
- Shows date range for each week
- Calculates aggregate statistics per week

### Monthly Statistics

- Automatically shows current month
- Exercise breakdown with progress bars
- Most popular exercise tracking
- Average calculations

## Color Scheme

- Primary: Deep Purple
- Accent: Orange (for streaks)
- Supporting colors: Blue, Green (for statistics)
