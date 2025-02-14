import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ancient_quotes_app/controller/quote_provider.dart';
import 'package:ancient_quotes_app/models/quote_data.dart';
import 'package:ancient_quotes_app/views/quote_history_screen.dart';
import 'package:intl/intl.dart'; // Add at the top

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuoteData? _quoteOfTheDay;
  bool _hasHistoryQuotes = false; // Track if user quotes exist

  @override
  void initState() {
    super.initState();
    _checkUserHistory(); // 🔹 Check if there are stored quotes on app launch
  }

  Future<void> _checkUserHistory() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    await quoteProvider.fetchUserQuotes(); // Fetch user history from Firestore

    setState(() {
      _hasHistoryQuotes = quoteProvider.userQuotes.isNotEmpty;
    });
  }

  Future<void> _fetchAndSaveQuote() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    await quoteProvider.fetchTodayQuote(); // Fetch and save quote

    setState(() {
      _quoteOfTheDay = quoteProvider.todayQuote; // Update UI with new quote
      _hasHistoryQuotes = true; // 🔹 Ensure history button turns blue after saving a quote
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title with Columns & Icons
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/greekpillar.svg',
                        width: 50,
                        height: 50,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const Text(
                            "ANCIENT",
                            style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: const Text(
                              "QUOTES",
                              style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      SvgPicture.asset(
                        'assets/icons/greekpillar.svg',
                        width: 50,
                        height: 50,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),

              // Date Section
              Padding(
                padding: const EdgeInsets.only(left: 2), // Move the whole block 15% left
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    const Text(
                      "Today is:",
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50), // Move date further right
                      child: Text(
                        DateFormat("d MMM, yyyy").format(DateTime.now()), // Format: 14 Feb, 2025
                        style: const TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),

              // Quote Section (Updates when button is clicked)
              _quoteOfTheDay != null
                  ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '"${_quoteOfTheDay!.text}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "- ${_quoteOfTheDay!.author}",
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              )
                  : const SizedBox(),

              // Fetch Quote Button
              ElevatedButton(
                onPressed: _fetchAndSaveQuote,
                child: const Text("Press for quote"),
              ),

              // History Button (Navigates to History Screen)
              ElevatedButton(
                onPressed: _hasHistoryQuotes
                    ? () async {
                  final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
                  await quoteProvider.fetchUserQuotes(); // Ensure user-selected quotes are loaded

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuoteHistoryScreen()),
                  );
                }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _hasHistoryQuotes ? Colors.blue : Colors.grey.shade300),
                ),
                child: const Text("HISTORY"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
