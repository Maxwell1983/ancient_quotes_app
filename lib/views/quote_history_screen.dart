import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ancient_quotes_app/controller/quote_provider.dart';
import 'package:intl/intl.dart'; // 🔹 For date formatting

class QuoteHistoryScreen extends StatefulWidget {
  const QuoteHistoryScreen({super.key});

  @override
  State<QuoteHistoryScreen> createState() => _QuoteHistoryScreenState();
}

class _QuoteHistoryScreenState extends State<QuoteHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user-selected quotes on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteProvider>(context, listen: false).fetchUserQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quote History")),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          if (quoteProvider.userQuotes.isEmpty) {
            return const Center(child: Text("No quotes in history."));
          }

          return ListView.builder(
            itemCount: quoteProvider.userQuotes.length,
            itemBuilder: (context, index) {
              final quote = quoteProvider.userQuotes[index];

              // 🔹 Format the date for better readability
              String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(quote.date);

              return ListTile(
                title: Text('"${quote.text}"'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- ${quote.author}"),
                    Text(
                      "Saved on: $formattedDate", // Show formatted date
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
