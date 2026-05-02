import 'package:hive_flutter/hive_flutter.dart';

part 'notes.g.dart';

@HiveType(typeId: 0)
class Notes extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String id;

  @HiveField(4)
  late String contentType; // 'plain', 'bullet', 'checkbox'

  @HiveField(5)
  late List<String> items; // list items (for bullet/checkbox)

  @HiveField(6)
  late List<bool> checked; // checkbox states

  Notes({
    required this.title,
    required this.description,
    required this.date,
    required this.id,
    required this.checked,
    required this.contentType,
    required this.items,
  });
}
