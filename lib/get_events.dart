import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetEventsPage extends StatefulWidget {
  final String token;
  const GetEventsPage({super.key, required this.token});

  @override
  State<GetEventsPage> createState() => _GetEventsPageState();
}

class _GetEventsPageState extends State<GetEventsPage> {
  List<dynamic> events = [];

  // Form controller
  final TextEditingController searchController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> fetchEvents() async {
    final queryParams = {
      if (searchController.text.isNotEmpty) 'search': searchController.text,
      if (categoryController.text.isNotEmpty)
        'category': categoryController.text,
      if (dateController.text.isNotEmpty) 'date': dateController.text,
    };

    final uri = Uri.http('103.160.63.165', '/api/events', queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          events = data['data'];
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to fetch events")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void goToAddEvent() {
    Navigator.pushNamed(context, '/add-event', arguments: widget.token);
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddEvent,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form pencarian
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Filter by category',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Filter by date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchEvents,
              child: const Text("Get Events"),
            ),
            const SizedBox(height: 10),
            // List Event
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    child: ListTile(
                      title: Text(event['name']),
                      subtitle: Text(
                        '${event['date']} @ ${event['location']} \n${event['category']}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
