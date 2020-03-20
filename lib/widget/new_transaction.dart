import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';


class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;
  
  void  _submitData(){
    if(amountController.text.isEmpty){
      return;
    }

    final enteredTitle = titleController.text;
    final enteredAmount = int.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate==null ){
      return;
    }

    widget.addTx(
       enteredTitle,
       enteredAmount,
       _selectedDate,
       );

    Navigator.of(context).pop();
  }

  void _presentDatePicker(){
    showDatePicker(
      context: context,
       initialDate: DateTime.now(),
        firstDate: DateTime(2020),
         lastDate: DateTime.now(),
         ).then((pickedDate) {
           if(pickedDate==null){
             return;
           }
           setState(() {
             _selectedDate = pickedDate;
           });
           
         });
  }

  @override
  Widget build(BuildContext context) {
    return 
            Card(
              child: Container(
              padding: EdgeInsets.all(7),
              child: Column(
              children : <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: titleController,
                   onSubmitted: (_) => _submitData(),
                  ),
                   TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) {
                   // amountInput =val;
                  //},
                  ),

                  Container(
                    height: 60,
                    child: Row(children: <Widget>[
                      Text( _selectedDate== null
                       ? 'No Date Chosen'
                       : 'Picked Date: ${ DateFormat.yMd().format(_selectedDate)}'),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                        'Choose Date', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                        onPressed: _presentDatePicker,
                      )
                    ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Transaction'),
                    textColor: Colors.red,
                    onPressed: _submitData,
                   ),
              ],
            ),
            ),
            );
  }
}