import 'dart:async';
import 'package:flutter/material.dart';

class TimerItem {
  int minutes;
  int seconds;
  Timer? timer;
  bool isPaused = false;

  TimerItem({required this.minutes, required this.seconds});
}

class TimerScreenPage extends StatefulWidget {
  @override
  _TimerScreenPageState createState() => _TimerScreenPageState();
}

class _TimerScreenPageState extends State<TimerScreenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _second = TextEditingController();
  final TextEditingController _minute = TextEditingController();
  List<TimerItem> timerItems = [];

  void addTimerItem(int minutes, int seconds) {
    if (timerItems.length < 10) {
      timerItems.add(TimerItem(minutes: minutes, seconds: seconds));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minute,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Minutes'),
                      onChanged: (value) {
                        // Handle minutes input change
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _second,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Seconds'),
                      onChanged: (value) {
                        // Handle seconds input change
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Add button press
                      addTimerItem(int.parse(_minute.value.text),
                          int.parse(_second.value.text));
                      // Call addTimerItem function with input values
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timerItems.length,
              itemBuilder: (context, index) {
                return TimerListItem(
                  timerItem: timerItems[index],
                  onDelete: () {
                    _deleteTimerItem(index);
                  },
                  onPauseResume: () {
                    // Handle timer pause/resume
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTimerItem(int index) {
    timerItems[index].timer?.cancel();
    timerItems.removeAt(index);
    setState(() {});
  }
}

class TimerListItem extends StatefulWidget {
  final TimerItem timerItem;
  final VoidCallback onDelete;
  final VoidCallback onPauseResume;

  TimerListItem({
    required this.timerItem,
    required this.onDelete,
    required this.onPauseResume,
  });

  @override
  _TimerListItemState createState() => _TimerListItemState();
}

class _TimerListItemState extends State<TimerListItem> {
  late int _remainingSeconds;
  late Color _timerColor;

  @override
  void initState() {
    super.initState();
    _remainingSeconds =
        widget.timerItem.minutes * 60 + widget.timerItem.seconds;
    _updateTimerColor();
    _startTimer();
  }

  void _updateTimerColor() {
    if (_remainingSeconds < 30) {
      _timerColor = Colors.red;
    } else {
      _timerColor = Colors.green;
    }
  }

  void _startTimer() {
    widget.timerItem.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!widget.timerItem.isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _updateTimerColor();
          } else {
            timer.cancel();
            widget.onDelete();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${widget.timerItem.minutes}:${widget.timerItem.seconds.toString().padLeft(2, '0')}',
        style: TextStyle(color: _timerColor),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
                widget.timerItem.isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                widget.timerItem.isPaused = !widget.timerItem.isPaused;
                widget.onPauseResume();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Cancel the timer and handle item deletion
              widget.timerItem.timer?.cancel();
              widget.onDelete();
            },
          ),
        ],
      ),
    );
  }
}
