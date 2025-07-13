import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../utils/app_colors.dart';

class CreateTaskDialog extends StatefulWidget {
  final AuthController auth;
  final TaskController taskController;

  const CreateTaskDialog({
    Key? key,
    required this.auth,
    required this.taskController,
  }) : super(key: key);

  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dueDateCtrl = TextEditingController();
  final List<String> _statusList = ['pending', 'in_progress', 'completed'];
  String _selectedStatus = 'pending';
  int _priority = 1;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dueDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Padding(
              padding:
              const EdgeInsets.only(top: 16, left: 16, right: 8),
              child: Row(
                children: [
                  Text(
                    'Create New Task',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.background, thickness: 1),

            // Form content
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildFilledField(
                      controller: _titleCtrl,
                      label: 'Title',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 12),
                    _buildFilledField(
                      controller: _descCtrl,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Status',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: _selectedStatus,
                      items: _statusList
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child:
                        Text(status.capitalizeFirst!),
                      ))
                          .toList(),
                      onChanged: (val) => setState(
                              () => _selectedStatus = val!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _dueDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        hintText: 'YYYY-MM-DD',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          _dueDateCtrl.text = date
                              .toIso8601String()
                              .split('T')
                              .first;
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Priority:',
                            style: TextStyle(
                                color: AppColors.textSecondary)),
                        Expanded(
                          child: Slider(
                            value: _priority.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: AppColors.primary,
                            label: '$_priority',
                            onChanged: (val) => setState(
                                    () => _priority = val.toInt()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Create
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.taskController.addTask(
                          widget.auth.user!.id!,
                          _titleCtrl.text.trim(),
                          _descCtrl.text.trim(),
                          _selectedStatus,
                          _dueDateCtrl.text.trim(),
                          _priority,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark
                            ],
                          ),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Create Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build filled text fields with prefix icons
  Widget _buildFilledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}