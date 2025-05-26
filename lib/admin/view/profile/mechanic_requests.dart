// import 'package:flutter/material.dart';
// import 'package:mini_project_1/admin/view/profile/mechanic_request_detailspage.dart';
// import 'package:mini_project_1/admin/view/screens/home/user_home_screen.dart';
// import 'package:mini_project_1/main.dart';
// import 'package:mini_project_1/utils/colors.dart';
// import 'package:mini_project_1/utils/widgets.dart';

// class MechanicRequests extends StatefulWidget {
//   const MechanicRequests({super.key});

//   @override
//   State<MechanicRequests> createState() => _MechanicRequestsState();
// }

// class _MechanicRequestsState extends State<MechanicRequests> {
//   int selectIndex = 0;
//   List<String> tabs = ['Pending', 'Accepted', 'Rejected'];

//   // Add list of transactions
//   final List<Map<String, dynamic>> transactions = [
//     {
//       'name': 'John Doe',
//       'place': 'Mechanic Name',
//       'status': 'Pending',
//       'phone': '+91 1234567890',
//       'countof_services': '10+ Services',
//       'image': '',
//     },
//     {
//       'name': 'John Deck',
//       'place': 'Mechanic Name',
//       'status': 'Accepted',
//       'phone': '+91 0987654321',
//       'countof_services': '10+ Services',
//       'image': '',
//     },
//     {
//       'name': 'John Dove',
//       'place': 'Mechanic Name',
//       'status': 'Rejected',
//       'phone': '+91 2345678910',
//       'countof_services': '8 Services',
//       'image': '',
//     },
//     {
//       'name': 'Johny',
//       'place': 'Mechanic Name',
//       'status': 'Rejected',
//       'phone': '+91 1234509876',
//       'countof_services': '5 Services',
//       'image': '',
//     },
//     {
//       'name': 'Jishnu',
//       'place': 'Mechanic Name',
//       'status': 'Pending',
//       'phone': '+91 1234509876',
//       'countof_services': '10+ Services',
//       'image': '',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final filteredTransaction = transactions.where((transaction) {
//       if (selectIndex == 0) return transaction['status'] == 'Pending';
//       if (selectIndex == 1) return transaction['status'] == 'Accepted';
//       return transaction['status'] == 'Rejected';
//     });

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.arrow_back_ios,
//                         size: mq.width * 0.050,
//                       ),
//                       Text(
//                         'Back',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: mq.width * 0.050,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Mechanic Requests',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: mq.width * 0.050,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   3,
//                   (index) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectIndex = index;
//                             });
//                           },
//                           child: Container(
//                             height: mq.height * 0.045,
//                             width: mq.width * 0.28,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.circular(mq.width * 0.015),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 0.5,
//                                   blurRadius: 6,
//                                 ),
//                               ],
//                               color: selectIndex == index
//                                   ? primaryColor
//                                   : Colors.white,
//                             ),
//                             child: Center(
//                                 child: Text(
//                               tabs[index],
//                               style: TextStyle(
//                                 color: selectIndex == index
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             )),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: transactions.isEmpty
//                     ? Text(
//                         'No transactions found',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       )
//                     : filteredTransaction.isEmpty
//                         ? Text(
//                             'No ${tabs[selectIndex]} transactions found',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           )
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: filteredTransaction.length,
//                             itemBuilder: (context, index) {
//                               final filteredTransactionList =
//                                   filteredTransaction.toList();

//                               final transaction =
//                                   filteredTransactionList[index];
//                               return InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               MechanicRequestDetailspage()));
//                                 },
//                                 child: CustomMechanicRequestCards(
//                                   index: selectIndex,
//                                   isAccepted:
//                                       transaction['status'] == 'Accepted',
//                                   image: transaction['image'],
//                                   name: transaction['name'],
//                                   phone: transaction['phone'],
//                                   place: transaction['place'],
//                                   services_count:
//                                       transaction['countof_services'],
//                                 ),
//                               );
//                             },
//                           ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:mini_project_1/main.dart';
import 'mechanic_request_detailspage.dart';

class MechanicRequests extends StatefulWidget {
  const MechanicRequests({super.key});

  @override
  State<MechanicRequests> createState() => _MechanicRequestsState();
}

class _MechanicRequestsState extends State<MechanicRequests> {
  int selectedIndex = 0;
  List<String> tabs = ['Pending', 'Accepted', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 18),
                    Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Mechanic Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(tabs.length, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                        ],
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),

              // Requests List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('mechanics')
                      .where('isAdminAccept',
                          isEqualTo: selectedIndex == 0
                              ? 0
                              : selectedIndex == 1
                                  ? 1
                                  : 2)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No ${tabs[selectedIndex]} requests found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    final requests = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final data =
                            requests[index].data() as Map<String, dynamic>;
                        final docId = requests[index].id;

                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MechanicRequestDetailspage(
                                mechanicId: docId,
                              ),
                            ),
                          ),
                          child: CustomMechanicRequestCards(
                            index: selectedIndex,
                            isAccepted: data['isAdminAccept'] == 0,
                            image: data['image'] ?? '',
                            name: data['name'] ?? '',
                            phone: data['mobile'] ?? '',
                            place: data['location'] ?? '',
                            services_count:
                                data['specializations'].length.toString() ?? '',
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
