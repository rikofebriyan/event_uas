import 'package:flutter/material.dart';
import 'package:event_uas/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(event.description),
            const SizedBox(height: 8),
            Text(
              "Tanggal: ${event.startDate} s/d ${event.endDate}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text("Waktu: ${event.time}"),
            Text("Lokasi: ${event.location}"),
            Text("Kategori: ${event.category}"),
            Text("Max Peserta: ${event.maxAttendees}"),
            Text("Harga: Rp ${event.price}"),
          ],
        ),
      ),
    );
  }
}
