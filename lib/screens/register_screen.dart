import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentNumberController = TextEditingController();
  final majorController = TextEditingController();
  final classYearController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>(); // untuk validasi (opsional)

  void register() async {
    setState(() => isLoading = true);

    final token = await ApiService.registerUser({
      "name": nameController.text,
      "email": emailController.text,
      "student_number": studentNumberController.text,
      "major": majorController.text,
      "class_year": int.tryParse(classYearController.text) ?? 0,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
    });

    setState(() => isLoading = false);

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: token);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mendaftar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Penting agar keyboard tidak menutupi
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Daftar Akun BookEvent",
                      style: TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: studentNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Student Number',
                      ),
                    ),
                    TextField(
                      controller: majorController,
                      decoration: const InputDecoration(labelText: 'Jurusan'),
                    ),
                    TextField(
                      controller: classYearController,
                      decoration: const InputDecoration(
                        labelText: 'Tahun Masuk',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Konfirmasi Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : register,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Daftar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
