import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerItem {
  int minutes;
  int seconds;
  Timer? timer;
  bool isPaused = false;

  TimerItem({required this.minutes, required this.seconds});
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // toolbarHeight: 40,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Timer App',
            style: GoogleFonts.poppins(),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              height: MediaQuery.of(context).size.height * .2,
              color: Theme.of(context).canvasColor,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: GoogleFonts.poppins(),
                            textAlign: TextAlign.center,
                            controller: _minute,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Minute',
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 20.0, top: 20.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber.withOpacity(0.2)),
                                // borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              return null;
                            },
                            onChanged: (value) {
                              // Handle minutes input change
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          ':',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            style: GoogleFonts.poppins(),
                            textAlign: TextAlign.center,
                            controller: _second,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Second',
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 20.0, top: 20.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber.withOpacity(0.2)),
                                // borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (value) {
                              // Handle seconds input change
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        addTimerItem(int.parse(_minute.value.text),
                            int.parse(_second.value.text));
                      },
                      child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 217, 82),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Add Timer',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ListView.builder(
                  itemCount: timerItems.length,
                  itemBuilder: (BuildContext context, index) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    child: TimerListItem(
                      subtitles:
                          'Timer ${(timerItems.indexOf(timerItems[index]) + 1)}'
                              .toString(),
                      timerItem: timerItems[index],
                      onDelete: () {
                        _deleteTimerItem(index);
                      },
                      onPauseResume: () {
                        // Handle timer pause/resume
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
  final String subtitles;
  final VoidCallback onDelete;
  final VoidCallback onPauseResume;

  TimerListItem({
    required this.timerItem,
    required this.subtitles,
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
        if (widget.timerItem.minutes == 0 && widget.timerItem.seconds == 0) {
          timer.cancel();
          widget.onDelete(); // Stop the timer when it reaches 0.
        } else if (widget.timerItem.seconds == 0) {
          setState(() {
            widget.timerItem.minutes--;
            widget.timerItem.seconds = 59;
          });
        } else {
          setState(() {
            widget.timerItem.seconds--;
            if (widget.timerItem.minutes == 0 &&
                widget.timerItem.seconds < 30) {
              _timerColor = Colors.red;
            } else {
              _timerColor = Colors.green;
            }
          });
        }
      }
    });
  }

  // void _startTimer() {
  //   widget.timerItem.timer =
  //       Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (!widget.timerItem.isPaused) {
  //       setState(() {
  //         if (_remainingSeconds > 0) {
  //           _remainingSeconds--;
  //           _updateTimerColor();
  //           print(_remainingSeconds);
  //         } else {
  //           timer.cancel();
  //           widget.onDelete();
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.black26,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w600),
      subtitleTextStyle: GoogleFonts.poppins(),
      title: Text(
        '${widget.timerItem.minutes}:${widget.timerItem.seconds.toString().padLeft(2, '0')}',
        style: TextStyle(color: _timerColor),
      ),
      subtitle: Text(widget.subtitles),
      trailing: Wrap(
        // mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            child: IconButton(
              icon: Icon(
                  widget.timerItem.isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: () {
                setState(() {
                  widget.timerItem.isPaused = !widget.timerItem.isPaused;
                  widget.onPauseResume();
                });
              },
            ),
          ),
          CircleAvatar(
              backgroundColor: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  widget.timerItem.timer?.cancel();
                  widget.onDelete();
                },
                icon: const Icon(
                  Icons.delete,
                ),
                color: const Color.fromARGB(255, 236, 116, 108),
              )),
        ],
      ),
    );
  }
}
