class Reminder {
  final int? id;
  final int contactId;
  final String title;
  final DateTime dateTime;
  final bool isCompleted;

  Reminder({
    this.id,
    required this.contactId,
    required this.title,
    required this.dateTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactId': contactId,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      contactId: map['contactId'],
      title: map['title'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      isCompleted: (map['isCompleted'] ?? 0) == 1,
    );
  }

  Reminder copyWith({int? id, bool? isCompleted}) {
    return Reminder(
      id: id ?? this.id,
      contactId: contactId,
      title: title,
      dateTime: dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
