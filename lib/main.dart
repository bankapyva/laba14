import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 14 - Варіант 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NativePlatformPage(),
    );
  }
}

class NativePlatformPage extends StatefulWidget {
  const NativePlatformPage({super.key});

  @override
  State<NativePlatformPage> createState() => _NativePlatformPageState();
}

class _NativePlatformPageState extends State<NativePlatformPage> {
  static const platform = MethodChannel('native/date');

  String _nativeData = 'Натисніть кнопку для отримання дати';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getDateFromNative() async {
    try {
      final String result = await platform.invokeMethod('getDate');
      setState(() {
        _nativeData = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _nativeData = "Помилка: ${e.message}";
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, // ✅ КАМЕРА
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Помилка камери: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна 14 — Варіант 2'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Дата з нативного коду:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(
                _nativeData,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getDateFromNative,
              child: const Text('Отримати поточну дату'),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Зробити фото'),
            ),

            const SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 300),
          ],
        ),
      ),
    );
  }
}
