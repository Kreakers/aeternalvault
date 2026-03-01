class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String socialMedia;
  final String company;
  final String jobTitle;
  final String address;
  final DateTime? lastContactDate;
  final DateTime? birthday;
  final DateTime? anniversary;
  final String connectionSource;
  final String tags; 
  final String category;
  final bool isPrivate;
  final String? imagePath;
  final int contactFrequency;
  final String notes;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email = '',
    this.socialMedia = '',
    this.company = '',
    this.jobTitle = '',
    this.address = '',
    this.lastContactDate,
    this.birthday,
    this.anniversary,
    this.connectionSource = '',
    this.tags = '',
    required this.category,
    this.isPrivate = false,
    this.imagePath,
    this.contactFrequency = 0,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'socialMedia': socialMedia,
      'company': company,
      'jobTitle': jobTitle,
      'address': address,
      'lastContactDate': lastContactDate?.toIso8601String(),
      'birthday': birthday?.toIso8601String(),
      'anniversary': anniversary?.toIso8601String(),
      'connectionSource': connectionSource,
      'tags': tags,
      'category': category,
      'isPrivate': isPrivate ? 1 : 0,
      'imagePath': imagePath,
      'contactFrequency': contactFrequency,
      'notes': notes,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      socialMedia: map['socialMedia'] ?? '',
      company: map['company'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      address: map['address'] ?? '',
      lastContactDate: map['lastContactDate'] != null ? DateTime.tryParse(map['lastContactDate']) : null,
      birthday: map['birthday'] != null ? DateTime.tryParse(map['birthday']) : null,
      anniversary: map['anniversary'] != null ? DateTime.tryParse(map['anniversary']) : null,
      connectionSource: map['connectionSource'] ?? '',
      tags: map['tags'] ?? '',
      category: map['category'] ?? '',
      isPrivate: (map['isPrivate'] ?? 0) == 1,
      imagePath: map['imagePath'],
      contactFrequency: map['contactFrequency'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }

  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? socialMedia,
    String? company,
    String? jobTitle,
    String? address,
    DateTime? lastContactDate,
    DateTime? birthday,
    DateTime? anniversary,
    String? connectionSource,
    String? tags,
    String? category,
    bool? isPrivate,
    String? imagePath,
    int? contactFrequency,
    String? notes,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      socialMedia: socialMedia ?? this.socialMedia,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      address: address ?? this.address,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      birthday: birthday ?? this.birthday,
      anniversary: anniversary ?? this.anniversary,
      connectionSource: connectionSource ?? this.connectionSource,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPrivate: isPrivate ?? this.isPrivate,
      imagePath: imagePath ?? this.imagePath,
      contactFrequency: contactFrequency ?? this.contactFrequency,
      notes: notes ?? this.notes,
    );
  }
}
