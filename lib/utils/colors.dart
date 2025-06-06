import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(218, 35, 87, 217);

Color? pickColor(String data) {
  Color color;
  data == 'No Mechanic Picked' || data == 'Pending' || data == 'Requested'
      ? color = Colors.red
      : data == 'Mechanic Picked'
          ? color = Colors.orange
          : data == 'Work In Progress'
              ? color = Colors.amber
              : data == 'On the Way'
                  ? color = primaryColor
                  : color = Colors.green;
  return color;
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'packed':
      return Colors.red;
    case 'confirmed':
      return Colors.amber;
    case 'delivered':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
