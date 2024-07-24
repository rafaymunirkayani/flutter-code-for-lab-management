import 'package:flutter/material.dart';
import 'db_helper.dart';

class UserDashboardActivity extends StatefulWidget {
  final String username;
  final String userId;

  UserDashboardActivity({required this.username, required this.userId});

  @override
  _UserDashboardActivityState createState() => _UserDashboardActivityState();
}

class _UserDashboardActivityState extends State<UserDashboardActivity> {
  final DBHelper _dbHelper = DBHelper();
  List<String> _availableEquipments = [];
  late String _username;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _userId = widget.userId;
    _loadAvailableEquipments();
  }

  void _loadAvailableEquipments() async {
    List<String> equipments = await _dbHelper.getAvailableEquipments();
    setState(() {
      _availableEquipments = equipments;
    });
  }

  void _issueEquipment() async {
    final selectedEquipment = _availableEquipments[0]; // Replace with actual selection logic
    bool success = await _dbHelper.issueEquipment(_username, _userId, selectedEquipment);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipment issued successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error issuing equipment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _availableEquipments.isNotEmpty ? _availableEquipments[0] : null,
              items: _availableEquipments.map((String equipment) {
                return DropdownMenuItem<String>(
                  value: equipment,
                  child: Text(equipment),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  // Handle the selection
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _issueEquipment,
              child: Text('Issue Equipment'),
            ),
          ],
        ),
      ),
    );
  }
}
