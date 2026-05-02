import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';

void showSortMenu(BuildContext context, NotesProvider provider) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
  final selected = await showMenu<SortOption>(
    context: context,
    position: position,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.md),
    ),
    elevation: 4,
    items: [
      _buildSortItem(
        SortOption.newest,
        'Newest First',
        Icons.arrow_downward_rounded,
        provider.sortOption,
        Theme.of(context).colorScheme.primary,
      ),
      _buildSortItem(
        SortOption.oldest,
        'Oldest First',
        Icons.arrow_upward_rounded,
        provider.sortOption,
        Theme.of(context).colorScheme.primary,
      ),
      _buildSortItem(
        SortOption.titleAZ,
        'Title A → Z',
        Icons.sort_by_alpha_rounded,
        provider.sortOption,
        Theme.of(context).colorScheme.primary,
      ),
      _buildSortItem(
        SortOption.titleZA,
        'Title Z → A',
        Icons.sort_by_alpha_rounded,
        provider.sortOption,
        Theme.of(context).colorScheme.primary,
      ),
    ],
  );
  if (selected != null) {
    provider.setSortOption(selected);
  }
}

PopupMenuItem<SortOption> _buildSortItem(
  SortOption value,
  String label,
  IconData icon,
  SortOption current,
  Color primaryColor,
) {
  final isSelected = value == current;
  return PopupMenuItem<SortOption>(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
          size: AppSize.iconSm,
          color: isSelected ? primaryColor : null,
        ),
        const SizedBox(width: AppSize.sm),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? primaryColor : null,
              fontSize: AppText.body,
            ),
          ),
        ),
        if (isSelected)
          Icon(Icons.check_rounded, size: AppSize.iconSm, color: primaryColor),
      ],
    ),
  );
}
