import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/core/theme/app_theme.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:notes_app/features/notes/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  await Hive.openBox('notes');
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: context.watch<NotesProvider>().isDark
          ? ThemeMode.dark
          : ThemeMode.light,
      builder: (context, child) {
        final isDark = context.watch<NotesProvider>().isDark;
        return AnimatedTheme(
          data: isDark ? AppTheme.dark() : AppTheme.light(),
          duration: const Duration(milliseconds: 300),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}
