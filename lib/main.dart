import 'package:flutter/material.dart';
import 'package:expense/widget/new_transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fb;

import './models/transaction.dart';
import './widget/transaction_list.dart';
import './widget/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput;
  String amountInput;

  // @override
  // void initState() {
  //   super.initState();
  //   fb.Firestore.instance.collection("new").add({"data": "new data"});
  // }

  final List<Transaction> _userTransactions = [
    /*Transaction(
      id :'t1',
      title: 'Shoe', 
      amount: 700 , 
      date: DateTime.now(),
      ),
    Transaction(
      id :'t2',
      title: 'Food', 
      amount: 200 , 
      date: DateTime.now(),
      ),*/
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, int txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });

    fb.Firestore.instance
        .collection("expenses")
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      "title": txTitle,
      "amount": txAmount,
      "date": chosenDate.millisecondsSinceEpoch,
    }).then((onValue) {
      print("Added data to firebase");
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    fb.Firestore.instance
        .collection("expenses")
        .document(id)
        .delete()
        .then((onValue) {
      print("Deleted expense");
    });
    // setState(
    //   () {
    //     _userTransactions.removeWhere(
    //       (tx) {
    //         return tx.id == id;
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expense'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
