import 'dart:ui';

import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expence;

  TopCard({required this.balance, required this.expence, required this.income});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'B A L A N C E',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
            Text(
              '\u{20B9}' + balance,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text('Income', style: TextStyle(color: Colors.white)),
                          Text('\u{20B9}' + income,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('\u{20B9}' + expence,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //color: Colors.grey.shade200.withOpacity(0.5),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.12)
            ],
            stops: const [0.0, 1.0],
          )),
    );
  }
}
