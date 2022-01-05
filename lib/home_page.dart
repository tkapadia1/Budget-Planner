import 'dart:async';
import 'package:budget_planner/deletion_list.dart';
import 'package:budget_planner/google_sheets_api.dart';
import 'package:budget_planner/loading_circle.dart';
import 'package:budget_planner/top_card.dart';
import 'package:budget_planner/transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }

  //Deletion
  void _deletion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('D E L E T E'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                        child: ListView.builder(
                            itemCount:
                                GoogleSheetsApi.currentTransactions.length,
                            itemBuilder: (context, index) {
                              return MyDeletionPage(
                                transactionName: GoogleSheetsApi
                                    .currentTransactions[index][0],
                              );
                            }))
                  ],
                ),
              ),
            );
          });
        });
  }

  // new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  // check fetching google sheet
  bool timeHasStarted = false;
  void startLoading() {
    timeHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timeHasStarted == false) {
      startLoading();
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0087, 0.90],
          colors: const [
            Color(0xFF000428),
            Color(0xFF004e92),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              TopCard(
                balance: (GoogleSheetsApi.calculateIncome() -
                        GoogleSheetsApi.calculateExpense())
                    .toString(),
                income: GoogleSheetsApi.calculateIncome().toString(),
                expence: GoogleSheetsApi.calculateExpense().toString(),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Expanded(
                            child: GoogleSheetsApi.loading == true
                                ? LoadingCircle()
                                : ListView.builder(
                                    itemCount: GoogleSheetsApi
                                        .currentTransactions.length,
                                    itemBuilder: (context, index) {
                                      return MyTransaction(
                                        transactionName: GoogleSheetsApi
                                            .currentTransactions[index][0],
                                        money: GoogleSheetsApi
                                            .currentTransactions[index][1],
                                        expenseOrIncome: GoogleSheetsApi
                                            .currentTransactions[index][2],
                                      );
                                    }))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            _newTransaction();
          },
          child: Icon(
            Icons.add,
            color: Color(0xFF004e92),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Color(0xFF004e92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    _deletion();
                  },
                  icon: Icon(
                    Icons.clear_all_rounded,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
