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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Contoh kategori (bisa disesuaikan dengan API kamu)
  final List<String> _categories = [
    '',
    'UAS',
    'Meetup',
    'Workshop',
    'Seminar',
    'Conference',
  ];
  String? _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents({String? search, String? category, String? date}) async {
    setState(() => isLoading = true);

    final response = await ApiService.getEvents(
      widget.token,
      search: search,
      category: category,
      date: date,
    );

    setState(() {
      events = response;
      isLoading = false;
    });
  }

  void _showEventDetail(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icon.png', // gambar dummy
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  event['title'] ?? 'Tanpa Judul',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tanggal: ${event['start_date']?.substring(0, 10)} s/d ${event['end_date']?.substring(0, 10)}",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Text(
                  "Lokasi: ${event['location'] ?? '-'}",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Text(
                  "Kategori: ${event['category'] ?? '-'}",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Text(
                  "Harga: Rp${event['price'] ?? 0}",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  event['description'] ?? 'Tidak ada deskripsi.',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () {
              // Hapus token & kembali ke LoginScreen
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔍 Search Field
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // 📂 Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat.isEmpty ? 'Semua Kategori' : cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Category",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // 🔍 Search Button
                ElevatedButton(
                  onPressed: () {
                    fetchEvents(
                      search: _searchController.text.trim().isEmpty
                          ? null
                          : _searchController.text.trim(),
                      category: _selectedCategory?.isEmpty ?? true
                          ? null
                          : _selectedCategory,
                      date: _dateController.text.trim().isEmpty
                          ? null
                          : _dateController.text.trim(),
                    );
                  },
                  child: const Text("Cari Event"),
                ),
                const SizedBox(height: 10),

                // 📜 Event List
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : events.isEmpty
                      ? Center(
                          child: Text(
                            "Belum ada event.",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ),
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
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  event['title'] ?? 'Tanpa Judul',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Tanggal: ${event['start_date']?.substring(0, 10)} s/d ${event['end_date']?.substring(0, 10)}\n"
                                    "Lokasi: ${event['location'] ?? '-'}\n"
                                    "Kategori: ${event['category'] ?? '-'}\n"
                                    "Harga: Rp${event['price'] ?? 0}",
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                                isThreeLine: true,
                                onTap: () => _showEventDetail(event),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ➕ Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
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
