import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class NotificationsCreate extends StatelessWidget {
  NotificationsCreate({super.key});

  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitNotification(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final heading = _nameController.text.trim();
      final content = _descriptionController.text.trim();

      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'heading': heading,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification published'),
            backgroundColor: Colors.green,
          ),
        );

        _nameController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomBackButton(),
                  ),
                  buildLabel('Add Notification'),
                  const SizedBox(height: 30),
                  buildLabel('Heading'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    text: 'Enter Notification Heading',
                    controller: _nameController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter heading'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Content'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    maxLines: 10,
                    minLines: 10,
                    text: 'Enter Notification Content',
                    controller: _descriptionController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter content'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomMaterialButtom(
                    color: primaryColor,
                    onPressed: () => _submitNotification(context),
                    buttonText: 'Publish Notification',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
