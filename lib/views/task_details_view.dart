import 'package:crud_practice_with_laravel/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:crud_practice_with_laravel/models/task.dart';

class TaskEditDetailsView extends StatefulWidget {
  final TaskModel task;
  int index;
  TaskEditDetailsView({Key? key, required this.task, required this.index})
    : super(key: key);

  @override
  _TaskEditDetailsViewState createState() => _TaskEditDetailsViewState();
}

class _TaskEditDetailsViewState extends State<TaskEditDetailsView> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // final taskController = Get.find<TaskController>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dueDateCtrl;
  late TextEditingController _statusCtrl;
  late TextEditingController _priorityCtrl;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.description);
    _dueDateCtrl = TextEditingController(text: widget.task.dueDate);
    _statusCtrl = TextEditingController(text: widget.task.status);
    _priorityCtrl = TextEditingController(
      text: widget.task.priority.toString(),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dueDateCtrl.dispose();
    _statusCtrl.dispose();
    _priorityCtrl.dispose();
    super.dispose();
  }

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    return DateFormat.yMMMMd().format(DateTime.parse(raw));
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _saveChanges() async {

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (taskController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  taskController.deleteTask(widget.task.id!, widget.index);
                  Get.back();
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit_outlined),
                onPressed: _isEditing ? (){
                  if (_formKey.currentState!.validate()) return;

                  taskController.updateTask(
                    widget.index,
                    widget.task.id!,
                    _titleCtrl.text,
                    _descCtrl.text,
                    _statusCtrl.text,
                    _dueDateCtrl.text,
                    int.parse(_priorityCtrl.text),
                  );

                  // On success, update local widget.task and exit edit mode:
                  setState(() {
                    widget.task.title = _titleCtrl.text;
                    widget.task.description = _descCtrl.text;
                    widget.task.dueDate = _dueDateCtrl.text;
                    widget.task.status = _statusCtrl.text;
                    widget.task.priority = int.parse(_priorityCtrl.text);
                    _isEditing = false;
                  });
                } : _toggleEdit,
              ),
              if (_isEditing)
                IconButton(icon: const Icon(Icons.close), onPressed: _toggleEdit),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _isEditing ? _buildEditForm() : _buildDetailView(),
          ),
        );
      }
    );
  }

  Widget _buildDetailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _detailCard(Icons.title, 'Title', widget.task.title ?? '—'),
        _detailCard(
          Icons.description_outlined,
          'Description',
          widget.task.description ?? 'No description',
        ),
        _detailCard(
          Icons.calendar_today_outlined,
          'Due Date',
          _formatDate(widget.task.dueDate),
        ),
        _detailCard(Icons.flag_outlined, 'Status', widget.task.status!),
        _detailCard(
          Icons.priority_high,
          'Priority',
          widget.task.priority.toString(),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Title cannot be empty' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'Description',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dueDateCtrl,
            decoration: const InputDecoration(
              labelText: 'Due Date (YYYY-MM-DD)',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return null;
              try {
                DateTime.parse(v);
                return null;
              } catch (_) {
                return 'Invalid date format';
              }
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _statusCtrl,
            decoration: const InputDecoration(
              labelText: 'Status',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            validator: (v) =>
                v != null && ['pending', 'in_progress', 'completed'].contains(v)
                ? null
                : 'Use pending, in_progress, or completed',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _priorityCtrl,
            decoration: const InputDecoration(
              labelText: 'Priority',
              prefixIcon: Icon(Icons.priority_high),
            ),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Priority required';
              final num? n = int.tryParse(v);
              if (n == null || n < 1) return 'Minimum priority is 1';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _detailCard(IconData icon, String label, String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirst =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
