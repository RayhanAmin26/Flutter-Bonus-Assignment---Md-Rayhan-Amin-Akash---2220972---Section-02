import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_management_provider.dart';
import 'screens/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Web-এ Firebase initialize (সবচেয়ে গুরুত্বপূর্ণ)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXX",           // ← তোমার apiKey
        authDomain: "your-project-id.firebaseapp.com",         // ← তোমার authDomain
        projectId: "your-project-id",                          // ← তোমার project ID
        storageBucket: "your-project-id.appspot.com",
        messagingSenderId: "123456789012",
        appId: "1:123456789012:web:xxxxxxxxxxxxxxxxxxxxxxxx",  // ← Web appId
        measurementId: "G-XXXXXXXXXX",                         // optional
      ),
    );
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskManagementProvider()),
      ],
      child: MaterialApp(
        title: 'IUB Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,
          ),
        ),
        home: const TaskListPage(),
      ),
    );
  }
}