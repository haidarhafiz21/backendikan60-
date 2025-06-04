import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  final String phone;
  final String? userId; // tambahkan userId untuk API update

  const EditProfilePage({
    super.key,
    required this.nama,
    required this.email,
    required this.phone,
    this.userId,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<bool> updateProfile(String userId, String nama, String email, String phone) async {
    final url = Uri.parse('http://localhost:3000/api/user/$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'phone': phone,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error update profile: $e');
      return false;
    }
  }

  void _simpan() async {
    if (widget.userId == null) {
      // kalau userId tidak ada, cuma return data saja
      Navigator.pop(context, {
        'nama': _namaController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await updateProfile(
      widget.userId!,
      _namaController.text,
      _emailController.text,
      _phoneController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pop(context, {
        'nama': _namaController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui profil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'No. HP'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    child: const Text('Simpan'),
                  ),
          ],
        ),
      ),
    );
  }
}
