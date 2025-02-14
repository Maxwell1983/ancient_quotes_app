import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ancient_quotes_app/controller/quote_provider.dart';
import 'package:ancient_quotes_app/firebase_options.dart';
import 'package:ancient_quotes_app/views/home_screen.dart';
import 'package:ancient_quotes_app/controller/persistence/firestore.dart';
import 'package:ancient_quotes_app/models/quote_data.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize QuoteProvider and fetch quotes on startup
  QuoteProvider quoteProvider = QuoteProvider();
  await quoteProvider.fetchQuotes(); // 🚀 Ensure Firestore gets populated

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuoteProvider()),
      ],
      child: MaterialApp(
        title: 'Ancient Quotes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
