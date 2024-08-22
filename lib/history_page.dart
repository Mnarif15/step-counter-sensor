// lib/history_page.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
// ignore: unused_import
import 'step_counter.dart'; // Import StepCounter for navigation

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 1; // Set the initial index for HistoryPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(
          'Step History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700], // Use the same color as StepCounter
      ),
      body: FutureBuilder<List<int>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to fetch step history: ${snapshot.error}'),
            );
          } else {
            final List<int> stepCounts = snapshot.data!;
            return ListView.builder(
              itemCount: stepCounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Step Count: ${stepCounts[index]}'),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Step Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 0) {
      Navigator.pop(context); // Navigate back to StepCounter page
    }
  }
}
