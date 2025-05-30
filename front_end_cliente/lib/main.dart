import 'package:flutter/material.dart';
import 'package:front_end_cliente/data/notifiers.dart';
import 'package:front_end_cliente/pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness:
                  isDarkMode
                      ? Brightness.dark
                      : Brightness
                          .light, //criando um botao para alterar entra dark e light mode
            ),
          ),
          home: Homepage(), //Chamando o Homepage como pagina home
        );
      },
    );
  }
}
