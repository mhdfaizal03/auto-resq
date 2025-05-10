import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';

class TermsAndCo extends StatelessWidget {
  const TermsAndCo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: mq.width * 0.050,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mq.width * 0.050,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Terms and Policy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mq.width * 0.050,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
