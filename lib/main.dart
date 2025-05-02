import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';
import 'providers/character_provider.dart';
import 'services/graphql_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>('favorites');
  await Hive.openBox<bool>('settings');

  final graphqlService = GraphQLService();
  graphqlService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CharacterProvider(graphqlService),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Rick & Morty App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData.dark(
          useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      home: const MainScreen(),
    );
  }
}
