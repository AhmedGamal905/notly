import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    this.id,
    this.note,
    this.date,
    this.color,
    this.title,
  });

  String id;
  String note;
  String date;
  String color;
  String title;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        note: json["note"],
        date: json["date"],
        color: json["color"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "date": date,
        "color": color,
        "title": title,
      };
}
