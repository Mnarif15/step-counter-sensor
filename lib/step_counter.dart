import 'package:flutter/material.dart';
import 'package:sensor2/login_page.dart';
import 'package:sensors/sensors.dart';
import 'database_helper.dart';
import 'package:sensor2/history_page.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  int stepCount = 0;
  int consecutiveValidReadings = 0;
  bool isStepInProgress = false;
  bool isCountingSteps = false;
  bool isPaused = false;
  bool isStopped = false;
  int _currentIndex = 0;
  double acceleration = 0.0;
  double angularSpeed = 0.0;
  bool shouldCountSteps = false;
  bool isDebouncing = false;
  static const double gyroscopeThreshold = 0.85;
  static const double accelerometerThreshold = 18.0;

  @override
  void initState() {
    super.initState();
    _startAccelerometerListener();
  }

  void _startAccelerometerListener() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = event.x.abs() + event.y.abs() + event.z.abs();

      if (acceleration > accelerometerThreshold && shouldCountSteps && !isCountingSteps) {
        setState(() {
          isCountingSteps = true;
          shouldCountSteps = false;
        });

        _startCountingSteps();
      }
    });
  }

  void _startCountingSteps() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      angularSpeed = event.x.abs() + event.y.abs() + event.z.abs();

      if (!isStepInProgress && isCountingSteps && !isPaused && !isStopped) {
        if (angularSpeed > gyroscopeThreshold) {
          isStepInProgress = true;
          consecutiveValidReadings = 1;
        }
      } else if (!isPaused && !isStopped) {
        consecutiveValidReadings++;

        if (consecutiveValidReadings > 5) {
          setState(() {
            stepCount++;
            isStepInProgress = false;
          });
        }
      }
    });
  }

  void _resetStepCount() {
    setState(() {
      stepCount = 0;
      isStopped = false;
    });
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _saveStepCount() {
    // Save the step count to the database
    DatabaseHelper.instance.insertStepCount(stepCount);

    // Reset all relevant state variables to their initial state
    setState(() {
      stepCount = 0;
      isStopped = false;
      isCountingSteps = false;
      isPaused = false;
      angularSpeed = 0.0;
      acceleration = 0.0;
      shouldCountSteps = false; // Reset the flag
    });

    // Check if step count is saved by printing to console
    print('Step count saved: $stepCount');
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(
          'StepMaster',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],leading: IconButton(
          icon: Icon(Icons.logout), // Change to your preferred logout icon
          onPressed: () {Navigator.pop(context); // Pop the current page
            Navigator.pushReplacement( // Push the login page and remove the current page from the stack
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 5.0,
              margin: EdgeInsets.all(16.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Step Count',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '$stepCount',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: !isCountingSteps && !isPaused && !isStopped
                          ? () {
                              setState(() {
                                isCountingSteps = true;
                                shouldCountSteps = true; // Set the flag to start counting on the next shake
                              });
                              _startCountingSteps();
                            }
                          : null,
                      child: Text('Start Counting'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isCountingSteps
                          ? () {
                              _resetStepCount();
                            }
                          : null,
                      child: Text('Reset Count'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isCountingSteps
                          ? () {
                              setState(() {
                                isPaused = !isPaused;
                              });
                            }
                          : null,
                      child: Text(isPaused ? 'Resume' : 'Pause'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isCountingSteps
                          ? () {
                              _saveStepCount();
                            }
                          : null,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
}
