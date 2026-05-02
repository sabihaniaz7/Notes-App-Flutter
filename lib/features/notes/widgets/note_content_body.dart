import 'package:flutter/material.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/core/constants/sizes.dart';

class NoteContentBody extends StatelessWidget {
  final Notes note;

  const NoteContentBody({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<NotesProvider>();

    if (note.contentType == 'plain' || note.items.isEmpty) {
      return Text(
        note.description,
        style: TextStyle(
          fontSize: AppText.titleMd,
          color: cs.onSurface.withValues(alpha: 0.85),
          height: 1.7,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(note.items.length, (i) {
        if (note.contentType == 'checkbox') {
          return CheckboxListTile(
            title: Text(
              note.items[i],
              style: TextStyle(
                height: 1.5,
                decoration: note.checked[i] ? TextDecoration.lineThrough : null,
                color: note.checked[i]
                    ? cs.onSurface.withValues(alpha: 0.4)
                    : null,
              ),
            ),
            value: note.checked.length > i ? note.checked[i] : false,
            onChanged: (_) {
              provider.toggleCheck(note.id, i);
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSize.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSize.sm),
                  child: Container(
                    width: AppSize.sm - 2,
                    height: AppSize.sm - 2,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.sm),
                Expanded(
                  child: Text(
                    note.items[i],
                    style: TextStyle(
                      fontSize: AppText.titleMd,
                      color: cs.onSurface.withValues(alpha: 0.85),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
