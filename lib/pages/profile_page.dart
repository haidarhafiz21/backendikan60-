import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'history_screen.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = '';
  String email = '';
  String phone = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      fetchUserProfile(widget.userId!);
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('http://localhost:3000/api/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nama = data['nama'] ?? '';
          email = data['email'] ?? '';
          phone = data['phone'] ?? '';
        });
      } else {
        print('Gagal mengambil data profil');
      }
    } catch (e) {
      print('Error fetch profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserProfile(String userId, String newNama, String newEmail, String newPhone) async {
    final url = Uri.parse('http://localhost:3000/api/user/$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': newNama,
          'email': newEmail,
          'phone': newPhone,
        }),
      );
      if (response.statusCode == 200) {
        print('Profil berhasil diperbarui');
      } else {
        print('Gagal memperbarui profil');
      }
    } catch (e) {
      print('Error update profile: $e');
    }
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          nama: nama,
          email: email,
          phone: phone,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        nama = result['nama'] ?? nama;
        email = result['email'] ?? email;
        phone = result['phone'] ?? phone;
      });
      if (widget.userId != null) {
        await updateUserProfile(widget.userId!, nama, email, phone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],  // dihapus
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage('assets/images/tampilanawal.jpg'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(email),
                                Text(phone),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _editProfile,
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: const Text('Pesanan'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HistoryScreen(userId: widget.userId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
