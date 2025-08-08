import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EventListScreen extends StatefulWidget {
  final String token;
  const EventListScreen({super.key, required this.token});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final fetchedEvents = await ApiService.getEvents(widget.token);
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching events: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Event")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? const Center(child: Text("Belum ada event tersedia."))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(event['title'] ?? 'Tanpa Judul'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event['description'] ?? '-'),
                  const SizedBox(height: 4),
                  Text("Tanggal: ${event['start_date']} - ${event['end_date']}"),
                  Text("Jam: ${event['time']}"),
                  Text("Lokasi: ${event['location']}"),
                  Text("Kategori: ${event['category']}"),
                  Text("Harga: Rp${event['price']}"),
                  Text("Max Peserta: ${event['max_attendees']}"),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
