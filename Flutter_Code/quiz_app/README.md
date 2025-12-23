# Quiz App

A comprehensive Flutter quiz application with multiple features including question management, score tracking, and quiz history.

## Features

### ✅ Core Features Implemented

1. **JSON Question Loading**

   - Questions loaded from `assets/questions.json`
   - Each question includes:
     - Question text
     - 4 multiple choice options
     - Correct answer index

2. **Quiz Screen**

   - One question displayed at a time
   - RadioListTile for answer selection
   - Next button (disabled until answer selected)
   - Progress indicator showing "Question X/10"
   - Linear progress bar visualization

3. **Results Screen**

   - Total score display (e.g., "7/10")
   - Percentage calculation
   - Congratulatory message based on performance
   - Review answers button
   - Back to home button

4. **Review Screen**

   - All questions displayed with answers
   - Selected answers highlighted
   - Correct answers highlighted in green
   - Wrong answers highlighted in red
   - Visual indicators (✓ for correct, ✗ for wrong)
   - Helpful hints showing correct answer for wrong answers

5. **Quiz History**

   - Stores all quiz attempts with:
     - Score and total questions
     - Percentage
     - Date and time of attempt
   - Persistent storage using shared_preferences
   - Clear history option
   - Color-coded performance indicators

6. **Restart Quiz**
   - Return to home screen from any screen
   - Start new quiz at any time
   - Previous attempts saved to history

## Project Structure

```
lib/
├── main.dart                 # App entry point and routing
├── models/
│   ├── question.dart        # Question model
│   └── quiz_attempt.dart    # Quiz attempt model for history
└── screens/
    ├── home_screen.dart     # Home screen with start quiz button
    ├── quiz_screen.dart     # Main quiz interface
    ├── results_screen.dart  # Results display
    ├── review_screen.dart   # Answer review
    └── history_screen.dart  # Quiz history list

assets/
└── questions.json           # Quiz questions data
```

## How to Run

1. **Install Dependencies**

   ```bash
   flutter pub get
   ```

2. **Run the App**

   ```bash
   flutter run
   ```

3. **Select Device**
   - Choose your preferred device (Android, iOS, Web, Desktop)

## Usage

1. **Start Quiz**: Click "Start Quiz" on the home screen
2. **Answer Questions**: Select an answer using the radio buttons
3. **Progress**: Click "Next" to move to the next question
4. **Finish**: After the last question, click "Finish"
5. **View Results**: See your score and percentage
6. **Review Answers**: Click "Review Answers" to see all questions
7. **View History**: Access quiz history from home screen or app bar
8. **Restart**: Return home to start a new quiz

## Dependencies

- `flutter`: SDK
- `shared_preferences: ^2.2.2`: For persistent storage of quiz history
- `intl: ^0.19.0`: For date formatting in history

## Customization

### Adding More Questions

Edit `assets/questions.json`:

```json
{
  "question": "Your question here?",
  "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
  "correctAnswer": 2
}
```

Note: `correctAnswer` is zero-indexed (0 = first option, 1 = second, etc.)

### Changing Theme

Edit theme in `lib/main.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Change color
  useMaterial3: true,
),
```
