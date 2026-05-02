import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/sizes.dart';

class ListItemsEditor extends StatelessWidget {
  const ListItemsEditor({
    super.key,
    required this.contentType,
    required this.controllers,
    required this.checkedStates,
    required this.onAdd,
    required this.onRemove,
    required this.onCheckChanged,
  });

  final String contentType;
  final List<TextEditingController> controllers;
  final List<bool> checkedStates;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int index, bool val) onCheckChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controllers.asMap().entries.map((entry) {
          final i = entry.key;
          final ctrl = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSize.sm),
            child: Row(
              children: [
                if (contentType == 'checkbox')
                  Checkbox(
                    value: i < checkedStates.length ? checkedStates[i] : false,
                    onChanged: (val) => onCheckChanged(i, val ?? false),
                    visualDensity: VisualDensity.compact,
                    activeColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppSize.sm,
                      left: AppSize.xs,
                    ),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Item ${i + 1}',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSize.md,
                        vertical: AppSize.sm,
                      ),
                    ),
                    onSubmitted: (_) => onAdd(),
                  ),
                ),
                if (controllers.length > 1)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onRemove(i),
                    icon: Icon(
                      Icons.remove_circle,
                      size: AppSize.iconSm,
                      color: cs.error.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: AppSize.iconSm),
          label: const Text(
            'Add Item',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.sm,
              vertical: AppSize.xs,
            ),
            textStyle: const TextStyle(
              fontSize: AppText.body,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
