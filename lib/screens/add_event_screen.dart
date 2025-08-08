import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddEventScreen extends StatefulWidget {
  final String token;

  const AddEventScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _maxParticipantsController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _submitForm() async {
    final success = await ApiService.createEvent(
      token: widget.token,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      time: _timeController.text.trim(),
      location: _locationController.text.trim(),
      maxAttendees: int.tryParse(_maxParticipantsController.text.trim()) ?? 0,
      category: _categoryController.text.trim(),
      price: int.tryParse(_priceController.text.trim()) ?? 0,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event berhasil ditambahkan')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menambahkan event')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date (YYYY-MM-DD)',
              ),
            ),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date (YYYY-MM-DD)',
              ),
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time (HH:MM:SS)'),
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _maxParticipantsController,
              decoration: const InputDecoration(labelText: 'Max Participants'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitForm, child: const Text('Tambah')),
          ],
        ),
      ),
    );
  }
}
