import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddEquipmentActivity extends StatefulWidget {
  @override
  _AddEquipmentActivityState createState() => _AddEquipmentActivityState();
}

class _AddEquipmentActivityState extends State<AddEquipmentActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _addEquipment() async {
    String name = _nameController.text;
    String id = _idController.text;

    bool isSuccess = await _dbHelper.addEquipment(name, id);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipment added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding equipment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Equipment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Equipment Name'),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(hintText: 'Equipment ID'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addEquipment,
              child: Text('Add Equipment'),
            ),
          ],
        ),
      ),
    );
  }
}
