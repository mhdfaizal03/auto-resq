import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class NotificationsCreate extends StatefulWidget {
  const NotificationsCreate({super.key});

  @override
  State<NotificationsCreate> createState() => _NotificationsCreateState();
}

class _NotificationsCreateState extends State<NotificationsCreate> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> roles = ['All', 'User', 'Mechanic', 'Shop'];
  String selectedRole = 'All';

  bool _isLoading = false;

  bool get isFilled =>
      _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty;

  Future<void> _submitNotification(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance.collection('notifications').add({
          'heading': _nameController.text.trim(),
          'content': _descriptionController.text.trim(),
          'role': selectedRole,
          'timestamp': FieldValue.serverTimestamp(),
        });

        CustomSnackBar.show(
          context: context,
          message: 'Notification published',
          color: Colors.green,
        );

        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          selectedRole = 'All';
          _isLoading = false;
        });
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: 'Error: $e',
          color: Colors.red,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: customLoading())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      CustomBackButton(),
                      const SizedBox(height: 10),
                      buildLabel('Add Notification'),
                      const SizedBox(height: 30),
                      buildLabel('Heading'),
                      const SizedBox(height: 10),
                      CustomTextField(
                        keyBoardType: TextInputType.text,
                        text: 'Enter Notification Heading',
                        controller: _nameController,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter heading' : null,
                      ),
                      const SizedBox(height: 20),
                      buildLabel('Content'),
                      const SizedBox(height: 10),
                      CustomTextField(
                        maxLines: 10,
                        minLines: 10,
                        text: 'Enter Notification Content',
                        controller: _descriptionController,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter content' : null,
                      ),
                      const SizedBox(height: 20),
                      buildLabel('Select Target Role'),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        items: roles
                            .map((role) => DropdownMenuItem(
                                value: role, child: Text(role)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => selectedRole = val);
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomMaterialButtom(
                        color: isFilled
                            ? primaryColor
                            : const Color.fromARGB(195, 104, 135, 212),
                        onPressed: () => _submitNotification(context),
                        buttonText: 'Publish Notification',
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
