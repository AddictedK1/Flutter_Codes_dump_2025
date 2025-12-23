import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  XFile? _image;
  bool _busy = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = picked);
    }
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) return;
    setState(() => _busy = true);
    try {
      await FirebaseService.createPost(
        title: title,
        content: content,
        image: _image,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
                const SizedBox(width: 12),
                if (_image != null) const Text('Image selected'),
                const Spacer(),
                ElevatedButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy ? const CircularProgressIndicator() : const Text('Publish'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
