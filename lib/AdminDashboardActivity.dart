import 'package:flutter/material.dart';
import 'add_equipment_activity.dart';
import 'db_helper.dart';

class AdminDashboardActivity extends StatefulWidget {
  @override
  _AdminDashboardActivityState createState() => _AdminDashboardActivityState();
}

class _AdminDashboardActivityState extends State<AdminDashboardActivity> {
  final DBHelper _dbHelper = DBHelper();
  List<IssuedEquipment> _issuedEquipments = [];

  @override
  void initState() {
    super.initState();
    _loadIssuedEquipments();
  }

  void _loadIssuedEquipments() async {
    List<IssuedEquipment> issuedEquipments = await _dbHelper.getIssuedEquipments();
    setState(() {
      _issuedEquipments = issuedEquipments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _issuedEquipments.length,
              itemBuilder: (context, index) {
                final equipment = _issuedEquipments[index];
                return ListTile(
                  title: Text('User: ${equipment.username}'),
                  subtitle: Text('Equipment ID: ${equipment.equipmentId}\nIssued On: ${equipment.issueDate}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEquipmentActivity()),
              );
            },
            child: Text('Add Equipment'),
          ),
        ],
      ),
    );
  }
}
