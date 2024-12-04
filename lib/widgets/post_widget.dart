import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto/entity/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({required this.post, super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.texto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            if (widget.post.imagemUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(base64Decode(widget.post.imagemUrl!)),
              ),
            const SizedBox(height: 10),
            Text(
              'Publicado em: ${widget.post.hora.toDate().toLocal()}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
