import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:uuid/uuid.dart';

enum SortOption { newest, oldest, titleAZ, titleZA }

class NotesProvider extends ChangeNotifier {
  final _notesBox = Hive.box('notes');
  final _uuid = const Uuid();

  // ========= THEME =======
  final String _themeKey = 'darkMode';
  bool get isDark => _notesBox.get(_themeKey, defaultValue: false);

  void toggleTheme() {
    _notesBox.put(_themeKey, !isDark);
    notifyListeners();
  }

  // ===== SEarch ===========
  String _searchQuery = '';

  void searchFilter(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  // ============= Sort ==========================
  SortOption _sortOption = SortOption.newest;
  SortOption get sortOption => _sortOption;

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // ── Notes getter (filtered + sorted) ─────────────────
  List get notes {
    final all = _notesBox.values.whereType<Notes>().toList();

    // sort
    switch (_sortOption) {
      case SortOption.newest:
        all.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.oldest:
        all.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.titleAZ:
        all.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.titleZA:
        all.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
    }
    // filtering
    if (_searchQuery.isEmpty) return all;
    return all.where((note) {
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // =============== CRUD ============================
  Future<void> addNotes({
    required String title,
    required String description,
    DateTime? date,
    String contentType = 'plain',
    List<String> items = const [],
    List<bool> checked = const [],
  }) async {
    final note = Notes(
      title: title,
      description: description,
      date: date ?? DateTime.now(),
      id: _uuid.v4(),
      contentType: contentType,
      checked: checked,
      items: items,
    );
    await _notesBox.put(note.id, note);
    notifyListeners();
  }

  Future<void> editNotes({
    required String title,
    required String description,
    DateTime? date,
    required String id,
    String contentType = 'plain',
    List<String> items = const [],
    List<bool> checked = const [],
  }) async {
    final note = _notesBox.get(id);
    if (note != null) {
      note.title = title;
      note.description = description;
      note.date = date ?? note.date;
      note.checked = checked;
      note.contentType = contentType;
      note.items = items;
      await note.save();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
    notifyListeners();
  }

  Future<void> toggleCheck(String noteId, int index) async {
    final note = _notesBox.get(noteId) as Notes?;
    if (note != null && index < note.checked.length) {
      final updatedChecked = List<bool>.from(note.checked);
      updatedChecked[index] = !updatedChecked[index];
      note.checked = updatedChecked;
      await note.save();
      notifyListeners();
    }
  }
}
