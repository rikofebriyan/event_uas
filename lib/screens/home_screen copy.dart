import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async {
    final response = await ApiService.getEvents(widget.token);
    setState(() {
      events = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Terbaru")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? const Center(child: Text("Belum ada event."))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(event['title'] ?? 'Tanpa Judul'),
                    subtitle: Text(
                      "Tanggal: ${event['start_date']?.substring(0, 10)} s/d ${event['end_date']?.substring(0, 10)}\n"
                      "Lokasi: ${event['location'] ?? '-'}\n"
                      "Kategori: ${event['category'] ?? '-'}\n"
                      "Harga: Rp${event['price'].toString()}",
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEventScreen(token: widget.token),
            ),
          );
          if (result == true) {
            fetchEvents(); // Refresh list setelah tambah event
          }
        },
        tooltip: 'Tambah Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
