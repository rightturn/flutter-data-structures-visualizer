# 🎯 Flutter Data Structures Visualizer

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.32+-blue.svg?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg?style=flat-square&logo=dart)
![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg?style=flat-square)

**Transform learning into an interactive experience!**

*An engaging Flutter application that brings data structures to life through stunning visualizations and step-by-step animations.*

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Contributing](#-contributing)

</div>

---

## 🚀 Why This App?

Ever struggled to understand how a stack grows or how linked lists connect? This app transforms abstract concepts into **visual, interactive experiences** that make learning data structures intuitive and fun!

### 🎓 Perfect for:
- **Students** learning computer science fundamentals
- **Educators** teaching data structures concepts
- **Developers** preparing for technical interviews
- **Anyone** curious about how data structures work internally

---

## ✨ Features

### 🎬 **Immersive Visualizations**
- **Real-time animations** show exactly how operations execute
- **Step-by-step progression** lets you follow along at your own pace
- **Interactive controls** to play, pause, and navigate through operations

### 📊 **Data Structure Library**
| Data Structure | Operations | Special Features |
|---|---|---|
| **Arrays** | Insert, Delete, Search, Traverse | Index-based access visualization |
| **Linked Lists** | Add to Start/End, Delete, Search | Node connections and pointers |
| **Stacks** | Push, Pop, Peek, Traverse | LIFO principle with proper growth |
| **Queues** | Enqueue, Dequeue, Front, Traverse | FIFO principle visualization |
| **Binary Trees** | Insert, Delete, Traverse | Tree structure with branches |
| **Binary Search Trees** | Insert, Delete, Search, In-order Traverse | Ordered tree navigation |
| **Graphs** | Add/Remove Vertex, Add Edge, BFS, DFS | Undirected network visualizations |
| **Min/Max Heaps** | Insert, Extract, Peek, Heapify | Priority queue operations |

### 🎮 **Interactive Learning**
- **Tap to edit** array values directly on the canvas
- **Real-time feedback** with operation explanations
- **Time complexity insights** for each operation

### 📱 **Cross-Platform Excellence**
- **Android & iOS** - Native mobile experience
- **Web** - Run directly in your browser
- **Desktop** - Windows, macOS, and Linux support
- **Responsive design** adapts to any screen size

---

## 🎯 Educational Value

### 🧠 **Conceptual Understanding**
- **Visual Learning**: See how data flows through structures
- **Interactive Exploration**: Experiment with different operations
- **Step-by-Step Breakdown**: Understand each operation phase
- **Real-World Context**: Connect theory to practical applications

### 📚 **Academic Support**
- **Algorithm Analysis**: Learn time and space complexity
- **Interview Preparation**: Practice with common data structure problems
- **Concept Reinforcement**: Solidify theoretical knowledge through practice

---

## 🛠️ Tech Stack

<div align="center">

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.32+ |
| **Language** | Dart 3.8+ |
| **State Management** | Riverpod 2.5+ |
| **Navigation** | GoRouter 14.6+ |
| **Architecture** | Clean Architecture |
| **Testing** | Flutter Test Framework |
| **Storage** | SharedPreferences |

</div>

---

## 📱 Screenshots

Screenshots are not yet included. Run the application locally to explore the interactive views.

---

## 🏗️ Installation

### Prerequisites
- Flutter SDK (3.32 or later)
- Dart SDK (3.0 or later)
- Android Studio / VS Code with Flutter extensions

### Quick Start
```bash
# Clone the repository
git clone git@github.com:rightturn/flutter-data-structures-visualizer.git

# Navigate to project directory
cd flutter-data-structures-visualizer

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform-Specific Setup
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d web

# For Desktop
flutter run -d windows    # or macos, linux
```

---

## 🎯 Usage

### 🚀 **Getting Started**
1. **Launch the app** and explore the data structure gallery
2. **Select a structure** you want to learn about
3. **Start with basic operations** like insert and delete
4. **Use the animation controls** to step through operations
5. **Experiment freely** - there's no wrong way to learn!

### 🎮 **Interactive Controls**
- **Play/Pause** ⏯️ - Control animation speed
- **Step Forward/Back** ⏭️⏮️ - Navigate through operations
- **Reset** 🔄 - Start fresh with new data
- **Speed Control** 🐌🐎 - Adjust animation speed

### 📊 **Understanding Visualizations**
- **Color Coding**: Different colors represent different states
  - 🟢 Green: Successfully found/inserted
  - 🔵 Blue: Currently processing
  - 🟠 Orange: New insertion
  - ⚫ Gray: Default state
- **Index Numbers**: Show position in the structure
- **Arrows**: Indicate relationships and flow direction

---

## 🧪 Testing

Run the comprehensive test suite:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/data_structures/stack_data_structure_test.dart

# Run the end-to-end application flow on a connected device
flutter test integration_test/app_test.dart
```

### Test Coverage
- **Unit tests**: Core structures, models, services, constants, and providers
- **Widget tests**: Home screen, operation controls, canvas, and learning panel
- **Integration test**: Launch, navigation, and array insertion flow

---

## 🎨 Architecture

### 📁 **Project Structure**
```
lib/
├── data_structures/     # Core data structure implementations
├── models/             # Data models and entities
├── providers/          # State management (Riverpod)
├── screens/           # UI screens and pages
├── services/          # Business logic services
├── utils/             # Utility functions and constants
├── widgets/           # Reusable UI components
└── main.dart          # App entry point
```

### 🏗️ **Clean Architecture**
- **Separation of Concerns**: Each layer has a specific responsibility
- **Testability**: Easy to unit test individual components
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new data structures and features

---

## 👥 Credits

This app was built by two developers:

- **Amna Sherazi**: original author. She created the project in July 2025 and wrote the initial
  implementation of the array, stack and queue visualizations, the first tests and the app structure
  (8 of the project's 9 commits, roughly two thirds of the Dart code at the time of this release).
- **Nadeem Abbas Shah**: co-author. In October 2026 he reworked and extended the visualizations
  (arrays, trees and graphs), expanded the test coverage and added the CI workflow and license
  (roughly one third of the Dart code).

The full commit history is preserved in this repository. Personal e-mail addresses in the history were
replaced with placeholders, so GitHub does not link Amna's commits to her profile; her name remains on every
commit she made.

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 **Bug Reports**
Found a bug? Please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### 💡 **Feature Requests**
Have an idea? We'd love to hear it! Create an issue describing:
- The feature you'd like to see
- Why it would be useful
- How you envision it working

### 🔧 **Code Contributions**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### 📝 **Documentation**
- Improve existing documentation
- Add code comments
- Create tutorials or examples
- Translate to other languages

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Show Your Support

If this project helped you learn data structures, please consider:
- ⭐ **Starring** this repository
- 🍴 **Forking** to contribute
- 📢 **Sharing** with fellow developers
- 💬 **Providing feedback** through issues

---

## 📞 Contact & Support

<div align="center">

**Have questions or suggestions?**

[![GitHub Issues](https://img.shields.io/badge/GitHub-Issues-red?style=for-the-badge&logo=github)](https://github.com/rightturn/flutter-data-structures-visualizer/issues)

</div>

---

<div align="center">

**Made with ❤️ for the learning community**

*"The best way to understand data structures is to see them in action!"*

</div>
