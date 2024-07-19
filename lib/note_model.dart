class NoteModel {
  int? id;
  String title;
  String subtitle;
  String date;

  NoteModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date,
    };
  }
}
