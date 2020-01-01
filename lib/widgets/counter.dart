import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Counter extends StatefulWidget {

  final int defaultVal;
  final int min;
  final int max;
  final int multipler;
  final Function onCounter;

  Counter({
    this.defaultVal = 0,
    this.min = 1,
    this.max = 10,
    this.multipler = 1,
    this.onCounter
  });
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final counterController = TextEditingController();
  int counterVal;
  void initState() {
    super.initState();
    counterVal = widget.defaultVal;
  }

  onPress(bool isIncrement) {
    if (isIncrement) {
      /// If it is the increment concept
      /// Check the future value is within the min and max
      /// else If it is the decrement concept
      /// Check the future value is within the min and max
      if ((this.counterVal + widget.multipler <= widget.max)
          & (this.counterVal + widget.multipler >= widget.min)) 
        setState(() {
          this.counterVal = this.counterVal + widget.multipler;
          widget.onCounter(this.counterVal);
        });
    } else if ((this.counterVal - widget.multipler <= widget.max)
          & (this.counterVal - widget.multipler >= widget.min)) {
        setState(() {
          this.counterVal = this.counterVal - widget.multipler;
          widget.onCounter(this.counterVal);
        });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.remove,
              size: 12,
            ),
            onPressed: () => onPress(false),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: FittedBox(child: 
                Text('$counterVal')
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.add,
              size: 12,
            ),
            onPressed: () => onPress(true),
          )
      ],),
    );
  }
}