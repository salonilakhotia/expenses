import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbols.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fb.Firestore.instance.collection("expenses").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<fb.QuerySnapshot> snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting ||
            snaphot.connectionState == ConnectionState.none) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (!snaphot.hasData || snaphot.data.documents.length == 0) {
            return Center(
              child: Text("No data"),
            );
          }
          if (!snaphot.hasError) {
            return Container(
              height: 300,
              child: ListView.builder(
                itemCount: snaphot.data.documents.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text(
                                '\$${snaphot.data.documents[index].data["amount"].toString()}'),
                          ),
                        ),
                      ),
                      title: Text(
                        snaphot.data.documents[index].data["title"].toString(),
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                            snaphot.data.documents[index].data["date"],
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            deleteTx(snaphot.data.documents[index].documentID),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text("Error"),
            );
          }
        }
      },
    );
  }
}
