class VaultItem {
  final int? id;
  final String title;
  final String secretContent;
  final String category;
  final String note;
  final String? filePath; // Yeni: Dosya yolu

  VaultItem({
    this.id,
    required this.title,
    required this.secretContent,
    required this.category,
    this.note = '',
    this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'secretContent': secretContent,
      'category': category,
      'note': note,
      'filePath': filePath,
    };
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    return VaultItem(
      id: map['id'],
      title: map['title'] ?? '',
      secretContent: map['secretContent'] ?? '',
      category: map['category'] ?? '',
      note: map['note'] ?? '',
      filePath: map['filePath'],
    );
  }

  VaultItem copyWith({
    int? id,
    String? title,
    String? secretContent,
    String? category,
    String? note,
    String? filePath,
  }) {
    return VaultItem(
      id: id ?? this.id,
      title: title ?? this.title,
      secretContent: secretContent ?? this.secretContent,
      category: category ?? this.category,
      note: note ?? this.note,
      filePath: filePath ?? this.filePath,
    );
  }
}
