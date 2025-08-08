import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Event Terbaru",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9800), // orange terang
              Color(0xFFF57C00), // orange gelap
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : events.isEmpty
            ? Center(
                child: Text(
                  "Belum ada event.",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        event['title'] ?? 'Tanpa Judul',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Tanggal: ${event['start_date']?.substring(0, 10)} s/d ${event['end_date']?.substring(0, 10)}\n"
                          "Lokasi: ${event['location'] ?? '-'}\n"
                          "Kategori: ${event['category'] ?? '-'}\n"
                          "Harga: Rp${event['price'].toString()}",
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF57C00),
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
