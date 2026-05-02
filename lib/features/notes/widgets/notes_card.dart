import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:notes_app/core/theme/colors.dart';
import 'package:notes_app/features/notes/screens/add_notes.dart';
import 'package:provider/provider.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.note,
    required this.cardColor,
    required this.isDark,
    required this.onTap,
  });
  final dynamic note;
  final Color cardColor;
  final bool isDark;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<NotesProvider>();
    final onCard = isDark ? Colors.black : AppColors.textOnCardLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppSize.cardRadius),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: 0.08),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(AppSize.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Hero
            Hero(
              tag: note.id,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: AppText.titleMd,
                    fontWeight: FontWeight.w600,
                    color: onCard,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (note.contentType == 'plain' && note.description.isNotEmpty) ...[
              const SizedBox(height: AppSize.xs),
              Text(
                note.description,
                style: TextStyle(
                  fontSize: AppText.body - 1, // slightly larger than caption
                  color: onCard,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Content type badge (bullet/checkbox)
            if (note.contentType != null &&
                note.contentType != 'plain' &&
                note.contentType.isNotEmpty) ...[
              const SizedBox(height: AppSize.sm),

              ...note.items.take(4).toList().asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                if (note.contentType == 'checkbox') {
                  return Row(
                    children: [
                      SizedBox(
                        height: AppSize.xxl,
                        width: AppSize.xxl,
                        child: Checkbox(
                          checkColor: Colors.white,

                          value: note.checked[i],
                          activeColor: onCard,
                          side: BorderSide(color: onCard, width: 1.5),
                          onChanged: (_) {
                            provider.toggleCheck(note.id, i);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSize.xs),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: AppText.caption + 1,
                            fontWeight: FontWeight.w500,
                            decoration: note.checked[i]
                                ? TextDecoration.lineThrough
                                : null,
                            color: note.checked[i]
                                ? cs.onSurface.withValues(alpha: 0.4)
                                : onCard,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSize.xs / 2),
                    child: Row(
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: AppText.body,
                            color: onCard,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: AppText.caption,
                              color: onCard,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
              if (note.items.length > 4)
                Text(
                  '...',
                  style: TextStyle(
                    fontSize: AppText.caption,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
            const SizedBox(height: AppSize.xs),
            Row(
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(note.date),
                  style: TextStyle(
                    fontSize: AppText.caption,
                    color: cs.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddNotes(editNotes: note),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSize.xs + 2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: AppSize.iconSm,
                      color: onCard.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
