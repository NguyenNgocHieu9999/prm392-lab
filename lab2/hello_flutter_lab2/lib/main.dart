import 'dart:async';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("========== LAB 2: DART ESSENTIALS ==========\n");

  exercise1();
  exercise2();
  exercise3();
  exercise4();
  await exercise5();

  runApp(const MyApp());
}

/// =====================================================
/// EXERCISE 1 - BASIC SYNTAX & DATA TYPES
/// =====================================================
void exercise1() {
  print("===== Exercise 1: Basic Syntax & Data Types =====");

  // Integer
  int age = 21;

  // Double
  double gpa = 3.8;

  // String
  String name = "Nguyen Ngoc Hieu";

  // Boolean
  bool isStudent = true;

  print("Name: $name");
  print("Age: $age");
  print("GPA: $gpa");
  print("Student: $isStudent");

  // String interpolation
  print("Next year age: ${age + 1}");

  print("");
}

/// =====================================================
/// EXERCISE 2 - COLLECTIONS & OPERATORS
/// =====================================================
void exercise2() {
  print("===== Exercise 2: Collections & Operators =====");

  // List
  List<int> numbers = [10, 20, 30, 40];

  print("Original List: $numbers");

  numbers.add(50);
  print("After add: $numbers");

  numbers.remove(20);
  print("After remove: $numbers");

  print("First element: ${numbers[0]}");

  // Operators
  int a = 10;
  int b = 5;

  print("a + b = ${a + b}");
  print("a - b = ${a - b}");
  print("a == b : ${a == b}");
  print("a > b && b > 0 : ${a > b && b > 0}");

  // Ternary Operator
  String result = a > b ? "a is greater" : "b is greater";
  print(result);

  // Set
  Set<String> fruits = {"Apple", "Banana", "Apple", "Orange"};

  print("Set (unique values): $fruits");

  // Map
  Map<String, dynamic> student = {"name": "Hieu", "age": 21, "major": "IT"};

  print("Student Name: ${student["name"]}");
  print("Student Age: ${student["age"]}");

  print("");
}

/// =====================================================
/// EXERCISE 3 - CONTROL FLOW & FUNCTIONS
/// =====================================================

void exercise3() {
  print("===== Exercise 3: Control Flow & Functions =====");

  int score = 85;

  // If Else
  if (score >= 90) {
    print("Grade A");
  } else if (score >= 80) {
    print("Grade B");
  } else if (score >= 70) {
    print("Grade C");
  } else {
    print("Grade D");
  }

  // Switch Case
  String day = "Monday";

  switch (day) {
    case "Monday":
      print("Start of week");
      break;
    case "Friday":
      print("Weekend is coming");
      break;
    default:
      print("Normal day");
  }

  List<String> subjects = ["Flutter", "Dart", "Firebase"];

  // For loop
  print("\nFor loop:");
  for (int i = 0; i < subjects.length; i++) {
    print(subjects[i]);
  }

  // For-in loop
  print("\nFor-in loop:");
  for (String item in subjects) {
    print(item);
  }

  // forEach
  print("\nforEach:");
  subjects.forEach((item) {
    print(item);
  });

  // Functions
  print("\nFunctions:");
  print("Sum = ${add(5, 3)}");
  print("Square = ${square(4)}");

  print("");
}

/// Normal Function
int add(int a, int b) {
  return a + b;
}

/// Arrow Function
int square(int x) => x * x;

/// =====================================================
/// EXERCISE 4 - INTRO TO OOP
/// =====================================================

class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named Constructor
  Car.unknown() : brand = "Unknown";

  void startEngine() {
    print("$brand car engine started.");
  }
}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);

  @override
  void startEngine() {
    print("$brand electric motor activated.");
  }
}

void exercise4() {
  print("===== Exercise 4: OOP =====");

  Car car1 = Car("Toyota");
  car1.startEngine();

  Car car2 = Car.unknown();
  car2.startEngine();

  ElectricCar tesla = ElectricCar("Tesla");
  tesla.startEngine();

  print("");
}

/// =====================================================
/// EXERCISE 5 - ASYNC, FUTURE, NULL SAFETY & STREAMS
/// =====================================================

Future<void> exercise5() async {
  print("===== Exercise 5: Async & Null Safety =====");

  // Future + await
  await loadData();

  // Null Safety
  String? nickname;

  print("Nickname: ${nickname ?? "No nickname"}");

  nickname = "FlutterDev";

  print("Nickname length: ${nickname!.length}");

  // Stream
  Stream<int> stream = Stream.periodic(
    const Duration(milliseconds: 500),
    (count) => count + 1,
  ).take(5);

  print("\nStream Output:");

  await for (int value in stream) {
    print("Received: $value");
  }

  print("");
}

Future<void> loadData() async {
  print("Loading data...");

  await Future.delayed(const Duration(seconds: 2));

  print("Data loaded successfully!");
}

/// =====================================================
/// SIMPLE FLUTTER UI
/// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lab 2 Dart Essentials",
      home: Scaffold(
        appBar: AppBar(title: const Text("Lab 2 - Dart Essentials")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Open Debug Console to view all Lab Results",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
