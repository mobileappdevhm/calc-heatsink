import 'package:flutter/material.dart';
import 'dart:collection';
import 'operators.dart';
import 'components.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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
    /*
    if (!shortDisplayValue.contains("e")) {
      int index = shortDisplayValue.length-1;
      while (shortDisplayValue[index] == "0" && shortDisplayValue[index-3] != ".") {
        index--;
      }
      shortDisplayValue = shortDisplayValue.substring(0, index);
    }
    */
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: renderAllButtons(buttonPadding, '$shortDisplayValue'),
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
            fontSize: Constants.getFontSize(),
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
              fontSize: Constants.getFontSize(),
          ),
        ),
    );
  }
  List<Widget> renderAllButtons(double padding, String displayValue) {
    List<Widget> list = new List<Widget>();
    list.add(new Text(
      displayValue,
      style: new TextStyle(
        color: Colors.black,
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
      ),
    ));
    list.add( new Padding(padding: new EdgeInsets.only(bottom: 100.0)));
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowOneChildren(buttonPadding)
    ));
    list.add(new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)));
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowTwoChildren(buttonPadding),
    ));
    list.add(new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)));
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowThreeChildren(buttonPadding),
    ));
    list.add(new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)));
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowFourChildren(buttonPadding),
    ));
    list.add(new Padding(padding: new EdgeInsets.only(bottom: buttonPadding)));
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowFiveChildren(buttonPadding),
    ));
    return list;
  }

  FloatingActionButton buttonOperator(String operator) {
    return new FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _setOperator(operator),
        child: new Text(operator,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Constants.getFontSize(),
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
              fontSize: Constants.getFontSize(),
          ),
        ),
    );
  }

  List<Widget> rowOneChildren(double padding) {
    List<Widget> buttons = new List();
    buttons.add(boxedButtonCommand(Operators.AC));
    buttons.add(boxedButtonCommand(Operators.NEGATIVE));
    buttons.add(boxedButtonCommand(Operators.PERCENT));
    buttons.add(boxedButtonOperator(Operators.DIVIDE));
    return Components.genericRow(buttons, padding);
  }

  List<Widget> rowTwoChildren(double padding) {
    List<Widget> buttons = new List();
    buttons.add(boxedButtonOperand(7));
    buttons.add(boxedButtonOperand(8));
    buttons.add(boxedButtonOperand(9));
    buttons.add(boxedButtonOperator(Operators.MULTIPLY));
    return Components.genericRow(buttons, padding);
  }

  List<Widget> rowThreeChildren(double padding) {
    List<Widget> buttons = new List();
    buttons.add(boxedButtonOperand(4));
    buttons.add(boxedButtonOperand(5));
    buttons.add(boxedButtonOperand(6));
    buttons.add(boxedButtonOperator(Operators.SUBTRACT));
    return Components.genericRow(buttons, padding);
  }
  List<Widget> rowFourChildren(double padding) {
    List<Widget> buttons = new List();
    buttons.add(boxedButtonOperand(1));
    buttons.add(boxedButtonOperand(2));
    buttons.add(boxedButtonOperand(3));
    buttons.add(boxedButtonOperator(Operators.ADD));
    return Components.genericRow(buttons, padding);
  }
  List<Widget> rowFiveChildren(double padding) {
    List<Widget> buttons = new List();
    buttons.add(boxedButtonOperand(0));
    buttons.add(boxedButtonCommand(Operators.DECIMAL));
    buttons.add(boxedWideButtonOperator(Operators.EQUALS));
    return Components.genericRow(buttons, padding+7);
  }
}

