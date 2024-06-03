import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  File? _image;

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();

    if (statuses[Permission.storage] != PermissionStatus.granted || statuses[Permission.camera] != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Resim seçmek için Depolama ve Kamera izinleri gereklidir. Lütfen ayarlardan izin verin.'),
      ));
    }
  }

  Future<void> _pickImage() async {
    await _requestPermissions();

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate() && _image != null) {
      try {
        // Resmi Firebase Storage'a yükleyin
        String imageUrl = await _uploadImage(_image!);

        // Mevcut kullanıcıyı alın
        User? user = FirebaseAuth.instance.currentUser;

        // Ürünü Firestore'a ekleyin
        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'quantity': int.parse(_quantityController.text),
          'imageUrl': imageUrl,
          'ownerId': user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hata: ${e.toString()}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lütfen tüm alanları doldurun ve bir resim seçin'),
      ));
    }
  }

  Future<String> _uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child('products/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Ekle'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ürün Adı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün adını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Ürün Açıklaması'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün açıklamasını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün fiyatını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Ürün Miktarı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün miktarını girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _image == null
                  ? ElevatedButton(
                onPressed: _pickImage,
                child: Text('Resim Seç'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              )
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Ürün Ekle'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
