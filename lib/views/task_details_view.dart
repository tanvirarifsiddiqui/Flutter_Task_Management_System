import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';
import '../widgets/task_details_widgets.dart';

class TaskEditDetailsView extends StatefulWidget {
  final TaskModel task;
  final int index;

  const TaskEditDetailsView({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  _TaskEditDetailsViewState createState() => _TaskEditDetailsViewState();
}

class _TaskEditDetailsViewState extends State<TaskEditDetailsView> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dueDateCtrl;
  late TextEditingController _statusCtrl;
  late TextEditingController _priorityCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title ?? '');
    _descCtrl = TextEditingController(text: widget.task.description ?? '');
    _dueDateCtrl = TextEditingController(text: widget.task.dueDate ?? '');
    _statusCtrl = TextEditingController(text: widget.task.status ?? 'pending');
    _priorityCtrl = TextEditingController(text: widget.task.priority?.toString() ?? '1');
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

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.surface),
        title: Text(
          _isEditing ? 'Edit Task' : 'Task Details',
          style: TextStyle(color: AppColors.surface),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _isEditing ? _saveChanges(taskController) : _toggleEdit,
          ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _toggleEdit,
            ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              taskController.deleteTask(widget.task.id ?? 0, widget.index);
              Get.back();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: _isEditing
                      ? TaskEditForm(
                    formKey: _formKey,
                    titleCtrl: _titleCtrl,
                    descCtrl: _descCtrl,
                    dueDateCtrl: _dueDateCtrl,
                    statusCtrl: _statusCtrl,
                    priorityCtrl: _priorityCtrl,
                  )
                      : TaskDetailView(task: widget.task),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _saveChanges(TaskController taskController) {
    return () {
      if (!_formKey.currentState!.validate()) return;

      final title = _titleCtrl.text.trim().isNotEmpty ? _titleCtrl.text.trim() : 'Untitled';
      final desc = _descCtrl.text.trim();
      final due = _dueDateCtrl.text.trim();
      final status = _statusCtrl.text.trim();
      final priority = int.tryParse(_priorityCtrl.text) ?? 1;

      taskController.updateTask(
        widget.index,
        widget.task.id ?? 0,
        title,
        desc,
        status,
        due,
        priority,
      );

      setState(() {
        widget.task.title = title;
        widget.task.description = desc;
        widget.task.dueDate = due;
        widget.task.status = status;
        widget.task.priority = priority;
        _isEditing = false;
      });
    };
  }
}
