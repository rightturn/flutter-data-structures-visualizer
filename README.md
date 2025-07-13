# Data Structures Visualization App

A Flutter application for visualizing and interacting with various data structures through an intuitive, animated interface.

## Features

- **Interactive Visualizations**: Real-time visualization of data structures with custom drawing
- **Multiple Data Structures**: Support for arrays, stacks, and other data structures
- **Operation Controls**: Perform insert, delete, traverse, and randomize operations
- **Animated Traversal**: Step-by-step animation through data structure elements
- **Cross-Platform**: Works on Android, iOS, macOS, Linux, Windows, and Web
- **Modern UI**: Clean, intuitive interface with action chips and responsive design

## App Structure

### Project Organization

The app follows a typical Flutter project structure, with the main code in the `lib/` directory, organized by feature and responsibility:

```
lib/
  main.dart
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
```

### Key Directories and Their Roles

#### **lib/main.dart**
- **Entry point** of the app
- Sets up providers (using Riverpod), routing (using GoRouter), and the app's theme

#### **models/**
- Contains data models representing data structures (e.g., `data_structure.dart`)
- Models define the properties and methods for each data structure (like Array, Stack, etc.)

#### **providers/**
- Houses Riverpod providers for state management
- Example: `theme_provider.dart` for theme state

#### **screens/**
- Contains UI screens
- `home_screen.dart`: The main landing page, listing available data structures
- `data_structure_screen.dart`: The visualization and interaction page for a selected data structure

#### **services/**
- Intended for business logic or backend interaction (currently empty or minimal)

#### **utils/**
- Utility functions and factories
- `data_structure_factory.dart`: Creates instances of data structure models based on user selection

#### **widgets/**
- Reusable UI components:
  - `data_structure_canvas.dart`: Custom painter for visualizing data structures
  - `data_structure_card.dart`: UI card for each data structure
  - `operation_controls.dart`: UI for controlling operations
  - `learning_panel.dart`, `quiz_panel.dart`: Panels for learning and quizzes

### State Management

- **Riverpod** is used for managing app-wide and feature-specific state
- Providers are defined in `providers/` and consumed throughout the app for things like theme and current data structure

### Navigation

- **GoRouter** is used for navigation between screens
- Routes:
  - `/` → Home screen
  - `/data-structure/:type` → Visualization screen for a selected data structure

### Visualization & Interaction

- **CustomPainter** (in `data_structure_canvas.dart`) is used to draw data structures (e.g., arrays as vertical boxes)
- **Operation Controls**: Action chips/buttons allow users to perform operations (insert, delete, traverse, randomize, etc.)
- **Animations**: Traversal and other operations animate changes to help users understand the process

### Platform Support

- The project includes folders for Android, iOS, macOS, Linux, Windows, and web, making it a cross-platform Flutter app

### Assets

- `assets/` contains icons and images used in the UI

### Testing

- `test/widget_test.dart` contains (or is set up for) widget tests

## User Flow

1. **Home Screen**: User selects a data structure
2. **Visualization Screen**: User sees a visual representation and can perform operations via action chips
3. **Operations**: Insert, delete, randomize, and traverse update the visualization immediately, with animations for traversal
4. **UI Updates**: The canvas and controls update in real time based on user actions

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
