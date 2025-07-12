class TaskModel {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? status;
  Null? dueDate;
  int? priority;
  String? createdAt;
  String? updatedAt;

  TaskModel(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.status,
        this.dueDate,
        this.priority,
        this.createdAt,
        this.updatedAt});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    dueDate = json['due_date'];
    priority = json['priority'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['due_date'] = this.dueDate;
    data['priority'] = this.priority;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}