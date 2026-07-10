import 'package:hive/hive.dart';

class DiaryEntry {
  final String id;
  String title;
  String content;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });
}

class DiaryEntryAdapter extends TypeAdapter<DiaryEntry> {
  @override
  final int typeId = 0;

  @override
  DiaryEntry read(BinaryReader reader) {
    return DiaryEntry(
      id: reader.readString(),
      title: reader.readString(),
      content: reader.readString(),
      date: DateTime.parse(reader.readString()),
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, DiaryEntry obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.content);
    writer.writeString(obj.date.toIso8601String());
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}
