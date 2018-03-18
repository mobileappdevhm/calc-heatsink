import 'package:flutter/material.dart';
import 'dart:collection';
import 'operators.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double buttonPadding = 10.0;

  String _currentOperation;
  Queue operands = new Queue();
  bool isOperatorSet = false;
  double lastValue = 0.0;
  double divisor = 1.0;
  bool isDecimal = false;
  void _commandOperator(String operator) {
    setState(() {
      switch (operator) {
        case Operators.AC:
          lastValue = 0.0;
          isOperatorSet = false;
          divisor = 1.0;
          isDecimal = false;
          while (operands.length > 0) {
            operands.removeFirst();
          }
          _currentOperation = Operators.NONE;
          break;
        case Operators.NEGATIVE:
          operands.addLast(operands.removeLast()*-1);
          break;
        case Operators.PERCENT:
          operands.addLast(operands.removeLast()/100);
          break;
        case Operators.DECIMAL:
          isDecimal = true;
          break;
      }
    });
  }

  void _setOperator(String operator) {
    setState(() {
      switch (operator) {
        case Operators.DIVIDE:
          _currentOperation = Operators.DIVIDE;
          break;
        case Operators.MULTIPLY:
          _currentOperation = Operators.MULTIPLY;
          break;
        case Operators.SUBTRACT:
          _currentOperation = Operators.SUBTRACT;
          break;
        case Operators.ADD:
          _currentOperation = Operators.ADD;
          break;
        case Operators.EQUALS:
          if (operands.length == 2) {
            lastValue = operands.removeLast();
          }
          if (_currentOperation == Operators.MULTIPLY) {
            operands.addLast(operands.length > 0 ?
            operands.removeFirst() * lastValue : 0.0);
          }
          else if (_currentOperation== Operators.ADD) {
            operands.addLast(operands.length > 0 ?
            operands.removeFirst() + lastValue : 0.0);
          }
          else if (_currentOperation== Operators.SUBTRACT) {
            operands.addLast(operands.length > 0 ?
            operands.removeFirst() - lastValue : 0.0);
          }
          else if (_currentOperation == Operators.DIVIDE) {
            operands.addLast(operands.length > 0 ?
            operands.removeFirst() / lastValue : 0.0);
          }
          isDecimal = false;
          break;
      }
      divisor = 1.0;
      isOperatorSet = _currentOperation == Operators.EQUALS ? false: true;
    });
  }

  void _setOperand(int operand) {
    setState(() {
      if (isOperatorSet) {
        isOperatorSet = false;
        if (isDecimal) {
          divisor /= 10;
          operands.addLast(operand.toDouble()*divisor);
        } else {
          divisor = 1.0;
          isDecimal = false;
          operands.addLast(operand.toDouble());
        }
      } else {
        if (isDecimal) {
          divisor /= 10;
          operands.addLast(operands.length > 0 ?
          operands.removeLast() + operand.toDouble()*divisor : operand.toDouble()*divisor);
        } else {
          operands.addLast(operands.length > 0 ?
          operands.removeLast() * 10 + operand.toDouble() : operand.toDouble());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayValue = 0.0;
    String shortDisplayValue = "0";
    if (operands.length == 1) {
      displayValue = operands.removeFirst();
      operands.add(displayValue);
    } else if (operands.length == 2){
      displayValue = operands.removeLast();
      operands.add(displayValue);
    }
    shortDisplayValue = displayValue.toStringAsPrecision(6);
    if (!shortDisplayValue.contains("e")) {
      int index = shortDisplayValue.length-1;
      while (shortDisplayValue[index] == "0" && shortDisplayValue[index-3] != ".") {
        index--;
      }
      shortDisplayValue = shortDisplayValue.substring(0, index);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(
              '$shortDisplayValue',
              style: new TextStyle(
                color: Colors.black,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Padding(padding: new EdgeInsets.only(bottom: 100.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxedButtonCommand(Operators.AC),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonCommand(Operators.NEGATIVE),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonCommand(Operators.PERCENT),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperator(Operators.DIVIDE),
              ],
            ),
            new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxedButtonOperand(7),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(8),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(9),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperator(Operators.MULTIPLY),
              ],
            ),
            new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxedButtonOperand(4),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(5),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(6),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperator(Operators.SUBTRACT),
              ],
            ),
            new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxedButtonOperand(1),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(2),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperand(3),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonOperator(Operators.ADD),
              ],
            ),
            new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                boxedButtonOperand(0),
                new Padding(padding: new EdgeInsets.only(right: buttonPadding)),
                boxedButtonCommand(Operators.DECIMAL),
                new Padding( padding: new EdgeInsets.only(right: buttonPadding + 25)),
                boxedWideButtonOperator(Operators.EQUALS),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox boxedButtonOperand(int num) {
    return new SizedBox(
      width: 75.0,
      height: 75.0,
      child: buttonOperand(num)
    );
  }

  SizedBox boxedWideButtonOperator(String operator) {
    return new SizedBox(
      width: 135.0,
      height: 70.0,
      child: wideButtonOperator(operator)
    );
  }

  SizedBox boxedButtonOperator(String operator) {
    return new SizedBox(
      width: 75.0,
      height: 75.0,
      child: buttonOperator(operator)
    );
  }

  SizedBox boxedButtonCommand(String operator) {
    return new SizedBox(
        width: 75.0,
        height: 75.0,
        child: buttonCommand(operator)
    );
  }

  FloatingActionButton buttonOperand(int num) {
    return new FloatingActionButton(
        onPressed: () => _setOperand(num),
        child: new Text(num.toString(),
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
          ),
        ),
    );
  }
  RaisedButton wideButtonOperator(String operator) {
    return new RaisedButton (
        color: Colors.orangeAccent,
        onPressed: () => _setOperator(operator),
        child: new Text(operator,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
          ),
        ),
    );
  }

  FloatingActionButton buttonOperator(String operator) {
    return new FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _setOperator(operator),
        child: new Text(operator,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
          ),
        ),
    );
  }

  FloatingActionButton buttonCommand(String operator) {
    return new FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () => _commandOperator(operator),
        child: new Text(operator,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
          ),
        ),
    );
  }
}

