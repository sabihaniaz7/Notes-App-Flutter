import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/notes/screens/add_notes.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:notes_app/features/notes/widgets/note_content_body.dart';
import 'package:notes_app/features/notes/utils/note_actions.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.note});
  final Notes note;

  // Edit
  void _edit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddNotes(editNotes: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => NoteActions.share(note),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _edit(context),
          ),
          IconButton(
            tooltip: 'Copy',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () => NoteActions.copyToClipboard(context, note),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => NoteActions.deleteNote(context, note.id),
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, child) {
          // Get fresh note from provider to ensure sync
          late Notes currentNote;
          try {
            currentNote = provider.notes.firstWhere((n) => n.id == note.id);
          } catch (_) {
            // If note was deleted, we'll be popping the screen anyway
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSize.xl,
              AppSize.lg,
              AppSize.xl,
              AppSize.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: currentNote.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      currentNote.title,
                      style: TextStyle(
                        fontSize: AppText.displayLg,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSize.sm),
                Text(
                  DateFormat('MMM dd, yyyy').format(currentNote.date),
                  style: TextStyle(
                    fontSize: AppText.caption,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.lg),

                NoteContentBody(note: currentNote),
              ],
            ),
          );
        },
      ),
    );
  }
}
