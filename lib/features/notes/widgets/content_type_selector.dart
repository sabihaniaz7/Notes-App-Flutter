import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/sizes.dart';

class ContentTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const ContentTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeChip(
          label: 'Plain',
          icon: Icons.notes,
          selected: selected == 'plain',
          onTap: () => onChanged('plain'),
        ),
        const SizedBox(width: AppSize.sm),
        _TypeChip(
          label: 'Bullets',
          icon: Icons.format_list_bulleted_rounded,
          selected: selected == 'bullet',
          onTap: () => onChanged('bullet'),
        ),
        const SizedBox(width: AppSize.sm),
        _TypeChip(
          label: 'Checklist',
          icon: Icons.check_box_outlined,
          selected: selected == 'checkbox',
          onTap: () => onChanged('checkbox'),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.md,
          vertical: AppSize.sm - 2,
        ),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSize.chipRadius),
          border: Border.all(
            color: selected
                ? cs.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSize.md + 2,
              color: selected
                  ? cs.onPrimaryContainer
                  : cs.onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(width: AppSize.xs + 1),
            Text(
              label,
              style: TextStyle(
                fontSize: AppText.caption,
                fontWeight: FontWeight.w600,
                color: selected
                    ? cs.onPrimaryContainer
                    : cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
