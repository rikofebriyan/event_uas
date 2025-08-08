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

    final result = await ApiService.registerUser({
      "name": nameController.text,
      "email": emailController.text,
      "student_number": studentNumberController.text,
      "major": majorController.text,
      "class_year": int.tryParse(classYearController.text) ?? 0,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
    });

    setState(() => isLoading = false);

    if (result['status'] == 201) {
      print("Berhasil register, result: $result");

      final token = result['data']['data']['token'];
      if (token != null) {
        Navigator.pushReplacementNamed(context, '/home', arguments: token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registrasi berhasil tapi token tidak ditemukan."),
          ),
        );
      }
    } else if (result['status'] == 422) {
      final errors = result['data']['errors'];
      String errorText = '';

      errors.forEach((key, value) {
        errorText += "$key: ${value.join(', ')}\n";
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorText)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['data']['message'] ?? "Gagal mendaftar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3), // biru
            Color(0xFF9C27B0), // ungu
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
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
                        "Daftar Akun Event App\nUAS x UAI",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: studentNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Student Number',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: majorController,
                        decoration: const InputDecoration(
                          labelText: 'Jurusan',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: classYearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tahun Masuk',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
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
      ),
    );
  }
}
