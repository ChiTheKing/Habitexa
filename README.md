# Habitexa — Premium Habit Tracking & Diagnostics Application

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture: BLoC/Cubit](https://img.shields.io/badge/Architecture-BLoC%20%2F%20Cubit-blueviolet?style=for-the-badge)](https://pub.dev/packages/flutter_bloc)
[![Design: Premium UI](https://img.shields.io/badge/Design-Premium%20UI%2FUX-ff69b4?style=for-the-badge)](https://figma.com)

**Habitexa** is a high-fidelity, production-grade habit tracking application built with Flutter. Designed with an uncompromising eye for visual balance and UI/UX fluidity, the application translates complex neumorphic layouts, fine elevations, and interactive progression models into a flawless, native mobile experience.

The project demonstrates advanced architectural separation of concerns, robust state-management lifecycles, and performance-optimized widget trees.

---

## 🎨 The Design Vision

The user interface is a pixel-perfect implementation of contemporary mobile dashboard aesthetics, balancing visual micro-interactions with heavy state logic:

- **Progress Optimization:** A premium header analytics block highlighting active streak counts and an integrated metric visualizer showing current-day completion percentages.
- **Neumorphic Cards:** Habit cards leverage subtle gradient fills, custom dropshadow configurations, and responsive state changes when toggled.
- **Fluid Forms:** The "Add New Habit" pipeline features an intuitive multi-axis category selector, localized custom time wheels, and week-matrix configuration inputs.

---

## 🏗️ Technical Architecture

Habitexa is engineered around the **BLoC/Cubit Pattern**, completely decoupling the presentation tier from underlying core business rules and storage layers.

```text
lib/
├── core/
│   ├── theme/          # Custom typography systems, layout constants, and color spaces
│   └── constants/      # App-wide fixed telemetry keys and constants
├── data/
│   ├── models/         # Immutable Habit data transport contracts
│   └── repository/     # Storage abstraction interfaces and local drivers
└── logic/
    ├── cubits/         # Uni-directional state emission engines (HabitCubit, AnalyticsCubit)
    └── states/         # Well-defined, immutable system state classes
```
