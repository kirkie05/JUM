import 'package:hive/hive.dart';

class LocalProgress {
  final int dayNumber;
  final DateTime completedAt;
  final int duration; // in seconds

  LocalProgress({
    required this.dayNumber,
    required this.completedAt,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'day_number': dayNumber,
      'completed_at': completedAt.toIso8601String(),
      'reading_duration': duration,
    };
  }
}

class LocalProgressAdapter extends TypeAdapter<LocalProgress> {
  @override
  final int typeId = 1;

  @override
  LocalProgress read(BinaryReader reader) {
    return LocalProgress(
      dayNumber: reader.readInt(),
      completedAt: DateTime.parse(reader.readString()),
      duration: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalProgress obj) {
    writer.writeInt(obj.dayNumber);
    writer.writeString(obj.completedAt.toIso8601String());
    writer.writeInt(obj.duration);
  }
}

class LocalStreak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  LocalStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletedDate,
  });
}

class LocalStreakAdapter extends TypeAdapter<LocalStreak> {
  @override
  final int typeId = 2;

  @override
  LocalStreak read(BinaryReader reader) {
    final hasDate = reader.readBool();
    return LocalStreak(
      currentStreak: reader.readInt(),
      longestStreak: reader.readInt(),
      lastCompletedDate: hasDate ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, LocalStreak obj) {
    writer.writeInt(obj.currentStreak);
    writer.writeInt(obj.longestStreak);
    writer.writeBool(obj.lastCompletedDate != null);
    if (obj.lastCompletedDate != null) {
      writer.writeString(obj.lastCompletedDate!.toIso8601String());
    }
  }
}

class LocalNote {
  final String id;
  final String bookId;
  final int chapter;
  final int verse;
  final String? title;
  final String body;
  final DateTime updatedAt;

  LocalNote({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verse,
    this.title,
    required this.body,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'title': title,
      'body': body,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class LocalNoteAdapter extends TypeAdapter<LocalNote> {
  @override
  final int typeId = 3;

  @override
  LocalNote read(BinaryReader reader) {
    return LocalNote(
      id: reader.readString(),
      bookId: reader.readString(),
      chapter: reader.readInt(),
      verse: reader.readInt(),
      title: reader.readBool() ? reader.readString() : null,
      body: reader.readString(),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, LocalNote obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.bookId);
    writer.writeInt(obj.chapter);
    writer.writeInt(obj.verse);
    writer.writeBool(obj.title != null);
    if (obj.title != null) {
      writer.writeString(obj.title!);
    }
    writer.writeString(obj.body);
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

class LocalBookmark {
  final String id;
  final String bookId;
  final int chapter;
  final int verse;
  final String type; // 'bookmark', 'favorite', 'highlight'
  final String? color;

  LocalBookmark({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.type,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'type': type,
      'color': color,
    };
  }
}

class LocalBookmarkAdapter extends TypeAdapter<LocalBookmark> {
  @override
  final int typeId = 4;

  @override
  LocalBookmark read(BinaryReader reader) {
    return LocalBookmark(
      id: reader.readString(),
      bookId: reader.readString(),
      chapter: reader.readInt(),
      verse: reader.readInt(),
      type: reader.readString(),
      color: reader.readBool() ? reader.readString() : null,
    );
  }

  @override
  void write(BinaryWriter writer, LocalBookmark obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.bookId);
    writer.writeInt(obj.chapter);
    writer.writeInt(obj.verse);
    writer.writeString(obj.type);
    writer.writeBool(obj.color != null);
    if (obj.color != null) {
      writer.writeString(obj.color!);
    }
  }
}
