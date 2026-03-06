class Registration {
  final int? id;
  final String name;
  final String email;
  final String workshops;
  final String modality;

  Registration({
    this.id,
    required this.name,
    required this.email,
    required this.workshops,
    required this.modality,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'workshops': workshops,
      'modality': modality,
    };
  }

  factory Registration.fromMap(Map<String, dynamic> map) {
    return Registration(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      workshops: map['workshops'] as String,
      modality: map['modality'] as String,
    );
  }
}
