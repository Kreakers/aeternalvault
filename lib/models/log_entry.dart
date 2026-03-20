class LogEntry {
  final int? id;
  final int? contactId; // Hangi kişiyle ilgili? (Opsiyonel)
  final String action; // Örn: 'Kayıt Edildi', 'Güncellendi', 'Görüşme Yapıldı'
  final DateTime timestamp;
  final bool isManual; // Kullanıcının el ile eklediği not mu?

  LogEntry({
    this.id,
    this.contactId,
    required this.action,
    required this.timestamp,
    this.isManual = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactId': contactId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'isManual': isManual ? 1 : 0,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'],
      contactId: map['contactId'],
      action: map['action'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      isManual: (map['isManual'] ?? 0) == 1,
    );
  }
}
