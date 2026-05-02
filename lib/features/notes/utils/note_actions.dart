import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:notes_app/core/constants/sizes.dart';

class NoteActions {
  static void share(Notes note) {
    final text = '${note.title}\n\n${note.description}';
    SharePlus.instance.share(ShareParams(text: text, subject: note.title));
  }

  static void copyToClipboard(BuildContext context, Notes note) {
    final text = '${note.title}\n\n${note.description}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note copied to clipboard')));
  }

  static Future<void> confirmDelete(
    BuildContext context, {
    required VoidCallback onDelete,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.cardRadius),
        ),
        title: const Text('Delete Note'),
        content: const Text('This note will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.sm,
                vertical: AppSize.md,
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: AppText.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete();
    }
  }

  static Future<void> deleteNote(BuildContext context, String id) async {
    await confirmDelete(
      context,
      onDelete: () async {
        await context.read<NotesProvider>().deleteNote(id);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Note deleted')));
          Navigator.pop(context);
        }
      },
    );
  }
}
