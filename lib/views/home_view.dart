import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'package:crud_practice_with_laravel/controllers/task_controller.dart';
import 'package:crud_practice_with_laravel/controllers/auth_controller.dart';
import 'package:crud_practice_with_laravel/models/task.dart';
import 'package:crud_practice_with_laravel/routes/route_helper.php.dart';
import 'package:crud_practice_with_laravel/widgets/custom_dialog.dart';
import '../utils/app_colors.dart';

class HomeView extends StatelessWidget {
  final auth = Get.find<AuthController>();
  final taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (tc) {
        return Scaffold(
          extendBody: true,

          // Gradient background
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Greeting + Logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello,', style: TextStyle(color: AppColors.surface, fontSize: 16)),
                            Text(
                              auth.user?.name ?? 'User',
                              style: TextStyle(color: AppColors.surface, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.logout, color: AppColors.surface),
                          onPressed: ()async {
                            await auth.logout();
                            tc.clearTasks();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Summary Cards or Shimmer
                    tc.isLoading
                        ? _buildShimmerSummaryCards()
                        : SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildSummaryCard('Total Tasks', tc.allTasks.length),
                          _buildSummaryCard(
                              'Completed', tc.allTasks.where((t) => t.status == 'completed').length),
                          _buildSummaryCard(
                              'Pending', tc.allTasks.where((t) => t.status != 'completed').length),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Task List or Shimmer + Pull-to-Refresh
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: tc.isLoading
                            ? _buildShimmerTaskList()
                            : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            tc.clearTasks();
                            await tc.getAllTasks();
                          },
                          child: tc.allTasks.isEmpty
                              ? Center(
                            child: Text(
                              'No tasks yet. Pull down to refresh or tap +',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                              : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: tc.allTasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final task = tc.allTasks[index];
                              return _buildTaskCard(context, task, index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // FAB + BottomAppBar
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              Get.dialog(CreateTaskDialog(auth: auth, taskController: tc));
            },
            child: Icon(Icons.add, color: AppColors.surface),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: AppColors.surface,
            child: const SizedBox(height: 20),
          ),
        );
      },
    );
  }

  // ─── SHIMMER PLACEHOLDERS ─────────────────────────────────────────────────────

  Widget _buildShimmerSummaryCards() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 3,
      ),
    );
  }

  Widget _buildShimmerTaskList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // ─── WIDGET BUILDERS ───────────────────────────────────────────────────────────

  Widget _buildSummaryCard(String title, int count) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            '$count',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task, int index) {
    // Format date safely
    String formattedDate;
    try {
      formattedDate = DateFormat.yMMMMd().format(DateTime.parse(task.dueDate!));
    } catch (_) {
      formattedDate = 'No due date';
    }

    final status = task.status ?? 'pending';
    final isDone = status == 'completed';
    final statusColor = isDone ? AppColors.success : AppColors.primaryDark;

    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.homeDetails, arguments: {'task': task, 'index': index}),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: statusColor, width: 4)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            title: Text(task.title?.trim().isNotEmpty == true ? task.title! : 'Untitled Task',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            subtitle: Text(formattedDate, style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
            trailing: Chip(
              label: Text(status.capitalizeFirst!, style: TextStyle(color: AppColors.surface)),
              backgroundColor: statusColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}