class Task {
  String? id;
  String? taskName;
  String? description;
  String? owner;

  Task({this.id, this.taskName, this.description, this.owner});

  factory Task.fromMap(Map<String?, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      taskName: map['taskName'] ?? '',
      description: map['description'] ?? '',
      owner: map['owner'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'taskName': taskName, 'description': description, 'owner': owner};
  }
}
