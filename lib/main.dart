import 'package:flutter/material.dart';
import 'package:pokedex_secompp/screens/home.dart';

void main() {
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: const MaterialColor(900, {
            50: Color.fromRGBO(112, 145, 154, .1),
            100: Color.fromRGBO(112, 145, 154, .2),
            200: Color.fromRGBO(112, 145, 154, .3),
            300: Color.fromRGBO(112, 145, 154, .4),
            400: Color.fromRGBO(112, 145, 154, .5),
            500: Color.fromRGBO(112, 145, 154, .6),
            600: Color.fromRGBO(112, 145, 154, .7),
            700: Color.fromRGBO(112, 145, 154, .8),
            800: Color.fromRGBO(112, 145, 154, .9),
            900: Color.fromRGBO(112, 145, 154, 1),
          }),
          backgroundColor: const Color(0xFFFFFFFF),
          primaryColor: const Color(0xFF000000),
          highlightColor: const Color(0xFFFFFFFF),
          disabledColor: const Color(0xFFBDB8B8)
        ),
      home: const PokemonListScreen()
    );
  }
}