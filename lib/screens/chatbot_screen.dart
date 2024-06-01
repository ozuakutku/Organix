import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chatbot_service.dart';
import 'package:file_picker/file_picker.dart';

class ChatbotScreen extends StatefulWidget {
  final User user;

  ChatbotScreen({required this.user});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatbotService _chatbotService = ChatbotService();
  String? _selectedFieldId;
  String? _pdfPath;
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarım Chatbot'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .collection('fields')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var fields = snapshot.data!.docs;
                return DropdownButton<String>(
                  value: _selectedFieldId,
                  hint: Text('Tarla Seçin'),
                  items: fields.map((field) {
                    return DropdownMenuItem<String>(
                      value: field.id,
                      child: Text(field['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFieldId = value;
                    });
                  },
                );
              },
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Sorunuzu yazın',
              ),
            ),
            ElevatedButton(
              onPressed: _pickPdf,
              child: Text('Toprak Analizi Raporu Ekle'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedFieldId != null && _controller.text.isNotEmpty) {
                  try {
                    final response = await _chatbotService.sendMessage(
                      _controller.text,
                      widget.user.uid,
                      _selectedFieldId!,
                      _pdfPath,
                    );
                    setState(() {
                      _response = response ?? 'Boş cevap alındı';
                    });
                  } catch (e) {
                    setState(() {
                      _response = 'Error: $e';
                    });
                  }
                } else {
                  setState(() {
                    _response = 'Lütfen bir tarla seçin ve sorunuzu yazın.';
                  });
                }
              },
              child: Text('Gönder'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.grey[200],
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_response),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path;
      });
    } else {
      // Kullanıcı seçimi iptal etti
    }
  }
}
