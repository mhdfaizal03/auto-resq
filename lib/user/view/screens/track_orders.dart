import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';

class TrackOrderPage extends StatelessWidget {
  final Map<String, dynamic> order;

  TrackOrderPage({super.key, required this.order});

  final List<Map<String, dynamic>> steps = [
    {
      'status': 'Order Placed',
      'date': 'createAt',
    },
    {
      'status': 'Confirmed',
      'date': 'order_confirmed_date',
    },
    {
      'status': 'Shipped',
      'date': 'order_shipped_date',
    },
    {
      'status': 'Out for Delivery',
      'date': 'out_of_delivery_date',
    },
    {
      'status': 'Delivered',
      'date': 'delivered_date',
    }
  ];

  @override
  Widget build(BuildContext context) {
    String currentStatus = order['status'];
    int currentStep =
        steps.indexWhere((step) => step['status'] == currentStatus);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(),
                const SizedBox(height: 10),
                const Text(
                  'My Orders',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildOrderInfoCard(),
                const SizedBox(height: 20),
                const Text(
                  'Tracking Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildStepper(currentStep),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey[300]!, blurRadius: 2.5)
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: order['image'] ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel(order['productName']),
                const SizedBox(height: 5),
                Text(order['brandName'] ?? ''),
                const SizedBox(height: 5),
                Text('Qty: ${order['quantity']}'),
                const SizedBox(height: 5),
                Text('Total: ₹${order['totalPrice']}'),
                const SizedBox(height: 5),
                Text('Order Date: ${dateFormatter(order['createAt'])}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        int idx = entry.key;
        Map<String, dynamic> step = entry.value;

        bool isCompleted = idx <= currentStep;

        String statusLabel = step['status'];
        String fieldName = step['date'];
        Timestamp? rawDate = order[fieldName];

        String formattedDate = rawDate != null ? dateFormatter(rawDate) : '';

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrackingStep(
                idx,
                statusLabel,
                formattedDate,
                Icons.check_circle,
                isCompleted ? Colors.green : Colors.grey.shade400,
                idx != steps.length - 1,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrackingStep(
    int index,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool showLine,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: color, size: 24),
            if (showLine)
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
