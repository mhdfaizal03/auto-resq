import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/screens/home/user_home_screen.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class WalletTab extends StatefulWidget {
  bool isExpanded;
  WalletTab({super.key, this.isExpanded = false});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  int selectIndex = 0;
  List<String> tabs = ['All', 'Pending', 'Completed'];

  // Add list of transactions
  final List<Map<String, dynamic>> transactions = [
    {
      'fromUserName': 'John Doe',
      'toMechanicName': 'Mechanic Name',
      'status': 'Pending',
      'date': '10/02/25',
      'amount': '₹ 5455/-',
      'services': [
        'Oil Change',
        'Brake Service',
        'Tire Rotation',
        'Mirror Change'
      ],
    },
    {
      'fromUserName': 'John Deck',
      'toMechanicName': 'Mechanic Name',
      'status': 'Completed',
      'date': '10/02/25',
      'amount': '₹ 4505/-',
      'services': [
        'Oil Change',
        'Brake Service',
        'Tire Rotation',
      ],
    },
    {
      'fromUserName': 'John Doe',
      'toMechanicName': 'Mechanic Name',
      'status': 'Pending',
      'date': '10/02/25',
      'amount': '₹ 3000/-',
      'services': [
        'Oil Change',
        'Brake Service',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTransaction = transactions.where((transaction) {
      if (selectIndex == 0) return true;
      if (selectIndex == 1) return transaction['status'] == 'Pending';
      return transaction['status'] == 'Completed';
    });

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              tabs.length,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectIndex = index;
                        });
                      },
                      child: Container(
                        height: mq.height * 0.045,
                        width: mq.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(mq.width * 0.015),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 6,
                            ),
                          ],
                          color: selectIndex == index
                              ? primaryColor
                              : Colors.white,
                        ),
                        child: Center(
                            child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: transactions.isEmpty
                ? Text(
                    'No transactions found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                : filteredTransaction.isEmpty
                    ? Text(
                        'No ${tabs[selectIndex]} transactions found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredTransaction.length,
                        itemBuilder: (context, index) {
                          final filteredTransactionList =
                              filteredTransaction.toList();

                          final transaction = filteredTransactionList[index];
                          return CustomWalletCards(
                            fromUserName: transaction['fromUserName'],
                            toMechanicName: transaction['toMechanicName'],
                            status: transaction['status'],
                            date: transaction['date'],
                            amount: transaction['amount'],
                            services: transaction['services'],
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
