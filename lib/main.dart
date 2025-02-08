import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/calendarpage.dart';
import 'package:to_do_app_beta/completed.dart';
import 'package:to_do_app_beta/createnewtag.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';
import 'package:to_do_app_beta/tomorrow.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoViewModel()),
        ChangeNotifierProvider(create: (context) => TagViewModel()), // Add your second provider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // '/Today/': (context) {
        //   return const Today();
        // },
        '/Tomorrow/': (context) {
          return const Tomorrow();
        },
        '/Completed/': (context) {
          return const Completed();
        },
        '/Description/': (context) {
          return const Description();
        },
        '/Calendar/': (context) {
          return const Calendarpage();
        }
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: const Color.fromARGB(255, 74, 141, 224),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Tomorrow();
  }
}
