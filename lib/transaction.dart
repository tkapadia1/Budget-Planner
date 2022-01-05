import 'package:budget_planner/google_sheets_api.dart';
import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  MyTransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          color: Colors.grey[200],
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[500]),
                    child: Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(transactionName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                ],
              ),
              Text(
                (expenseOrIncome == 'expense' ? '-' : '+') + '\u{20B9}' + money,
                style: TextStyle(
                    color: (expenseOrIncome == 'expense'
                        ? Colors.red
                        : Colors.green)),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
