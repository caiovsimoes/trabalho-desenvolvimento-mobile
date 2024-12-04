import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _base64Image;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        setState(() {
          _imageBytes = bytes;
          _base64Image = base64Image;
        });
      }
    } catch (e) {
      print("Erro ao selecionar imagem: $e");
    }
  }

  Future<void> _uploadImage() async {
    if (_base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma imagem selecionada')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('images').add({
        'image': _base64Image,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem enviada com sucesso!')),
      );

      setState(() {
        _imageBytes = null;
        _base64Image = null;
      });
    } catch (e) {
      print("Erro ao enviar imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar imagem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imageBytes != null)
          Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Selecionar Imagem'),
        ),
        ElevatedButton(
          onPressed: _uploadImage,
          child: const Text('Enviar para o Firestore'),
        ),
      ],
    );
  }
}
