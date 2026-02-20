import 'package:flutter/material.dart';
import 'package:shoesbrand/models/brand.dart';
import 'package:shoesbrand/services/database_services.dart';

class BrandFormPage extends StatefulWidget {
  const BrandFormPage({super.key});
  @override
  State<BrandFormPage> createState() => _BrandFormPageState();
}

class _BrandFormPageState extends State<BrandFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  Future<void> _onSave() async {
    final name = _nameController.text.trim(); // Trim to remove extra spaces
    final description = _descController.text.trim();
    if (name.isEmpty || description.isEmpty) {
      // Show an error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both fields are required!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Check for duplicate brand name
    final isDuplicate = await _databaseService.isBrandNameDuplicate(name);
    if (isDuplicate) {
      // Show an error if a duplicate is found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duplicate data: Brand name already exists!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await _databaseService
        .insertBrand(Brand(name: name, description: description));
    if (!mounted) return;
    Navigator.pop(context); // Close the form after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Brand'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the brand name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the brand description',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save Brand',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
