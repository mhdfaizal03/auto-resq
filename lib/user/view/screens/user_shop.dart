import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/user/view/screens/inner_categories_page.dart';
import 'package:mini_project_1/utils/widgets.dart';

class UserShop extends StatelessWidget {
  UserShop({super.key});

  final List<Map<String, dynamic>> filters = [
    {"title": "Emergency Tool", "image": "assets/images/tools.png"},
    {"title": "Battery & Electrical", "image": "assets/images/battery.png"},
    {"title": "Exterior & Interior", "image": "assets/images/exterior.png"},
    {"title": "Mechanical Parts", "image": "assets/images/mechanical.jpg"},
    {"title": "Safety & Security", "image": "assets/images/safety.png"},
    {"title": "Cleaning & Maintainance", "image": "assets/images/cleaning.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            validator: (val) {},
            controller: TextEditingController(),
            text: 'Search products here',
            suffix: Icon(Icons.search_rounded),
          ),
          SizedBox(
            height: 10,
          ),
          buildLabel('Choose from Category'),
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            itemCount: filters.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InnerCategoriesPage(
                          title: filters[index]["title"],
                        ),
                      ));
                },
                child: Opacity(
                  opacity: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(blurRadius: 1.5, color: Colors.grey),
                      ],
                    ),
                    margin: const EdgeInsets.all(5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(blurRadius: 1.5, color: Colors.grey)
                              ],
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                    width: 60, filters[index]["image"]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            filters[index]["title"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
