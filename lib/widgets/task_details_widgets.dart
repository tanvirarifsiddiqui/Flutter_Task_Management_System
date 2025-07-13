// lib/widgets/task_details_widgets.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';

/// A reusable row inside a card-style container
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String content;
  final Color? color;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.content,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.textPrimary;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? AppColors.primaryDark, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// VIEW MODE: Full task details in an elevated card
class TaskDetailView extends StatelessWidget {
  final TaskModel task;

  const TaskDetailView({Key? key, required this.task}) : super(key: key);

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      return DateFormat.yMMMMd().format(DateTime.parse(raw));
    } catch (_) {
      return 'Invalid date';
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return AppColors.accent;
      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = (task.title?.trim().isNotEmpty == true)
        ? task.title!
        : 'Untitled Task';
    final desc = (task.description?.trim().isNotEmpty == true)
        ? task.description!
        : 'No description';
    final date = _formatDate(task.dueDate);
    final status = task.status?.capitalizeFirst ?? 'Pending';
    final priority = task.priority ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(desc, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),

          InfoRow(
            icon: Icons.calendar_today_outlined,
            content: date,
          ),
          InfoRow(
            icon: Icons.flag_outlined,
            content: 'Priority: $priority',
          ),
          InfoRow(
            icon: Icons.check_circle_outline,
            content: 'Status: $status',
            color: _statusColor(status),
          ),
        ],
      ),
    );
  }
}

/// EDIT MODE: Wrapped, refined form fields
class TaskEditForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final TextEditingController dueDateCtrl;
  final TextEditingController statusCtrl;
  final TextEditingController priorityCtrl;

  const TaskEditForm({
    Key? key,
    required this.formKey,
    required this.titleCtrl,
    required this.descCtrl,
    required this.dueDateCtrl,
    required this.statusCtrl,
    required this.priorityCtrl,
  }) : super(key: key);

  @override
  _TaskEditFormState createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  late double _currentPriority;

  @override
  void initState() {
    super.initState();
    // Seed initial slider position from the controller
    _currentPriority = double.tryParse(widget.priorityCtrl.text) ?? 1.0;
  }

  Widget _filledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.background),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            _filledField(
              controller: widget.titleCtrl,
              label: 'Title',
              icon: Icons.title,
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            _filledField(
              controller: widget.descCtrl,
              label: 'Description',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Status',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              value: widget.statusCtrl.text,
              items: ['pending', 'in_progress', 'completed']
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.capitalizeFirst!),
              ))
                  .toList(),
              onChanged: (v) => widget.statusCtrl.text = v ?? '',
            ),
            const SizedBox(height: 16),
            _filledField(
              controller: widget.dueDateCtrl,
              label: 'Due Date',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).unfocus();
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.tryParse(widget.dueDateCtrl.text) ??
                      DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  final formatted = DateFormat('yyyy-MM-dd').format(date);
                  widget.dueDateCtrl.text = formatted;
                }
              },
            ),
            const SizedBox(height: 16),

            // ─── NOW THE MOVING SLIDER ───────────────────────────
            Row(
              children: [
                Text('Priority:',
                    style: TextStyle(color: AppColors.textSecondary)),
                Expanded(
                  child: Slider(
                    value: _currentPriority,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppColors.primary,
                    label: _currentPriority.toInt().toString(),
                    onChanged: (newVal) {
                      setState(() {
                        _currentPriority = newVal;
                        // Also update your controller for when you save:
                        widget.priorityCtrl.text =
                            newVal.toInt().toString();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}