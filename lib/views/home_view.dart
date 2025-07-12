import 'package:crud_practice_with_laravel/controllers/task_controller.dart';
import 'package:crud_practice_with_laravel/models/task.dart';
import 'package:crud_practice_with_laravel/routes/route_helper.php.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (taskController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  auth.logout();
                  taskController.clearTasks();
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: taskController.allTasks.length,
            itemBuilder: (context, index) {
              TaskModel task = taskController.allTasks[index];
              return InkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.homeDetails,
                    arguments: {'task': task, 'index': index},
                  );
                },
                child: ListTile(
                  title: Text(task.title ?? "No Title"),
                  subtitle: Text(task.createdAt!),
                  trailing: Text(task.status!),
                ),
              );
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final titleCtrl = TextEditingController();
              final descCtrl = TextEditingController();
              final dueDateCtrl = TextEditingController();
              final statusList = ['pending', 'in_progress', 'completed'];
              String selectedStatus = 'pending';
              int priority = 1;

              Get.defaultDialog(
                title: 'Create New Task',
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: titleCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextField(
                            controller: descCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            maxLines: 3,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Status',
                            ),
                            value: selectedStatus,
                            items: statusList
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status.capitalizeFirst!),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedStatus = value!),
                          ),
                          TextField(
                            controller: dueDateCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Due Date',
                              hintText: 'YYYY-MM-DD',
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) {
                                dueDateCtrl.text = date
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          Row(
                            children: [
                              const Text('Priority:'),
                              Expanded(
                                child: Slider(
                                  value: priority.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: '$priority',
                                  onChanged: (value) {
                                    setState(() => priority = value.toInt());
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Create Task'),
                            onPressed: () {
                              taskController.addTask(
                                auth.user!.id!,
                                titleCtrl.text.trim(),
                                descCtrl.text.trim(),
                                selectedStatus,
                                dueDateCtrl.text.trim(),
                                priority,
                              );
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
