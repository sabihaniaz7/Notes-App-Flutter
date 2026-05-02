import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/sizes.dart';

class NotesEmptyState extends StatelessWidget {
  const NotesEmptyState({super.key, required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSize.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSize.xxxl * 3),
            Container(
              width: AppSize.xxxl * 3,
              height: AppSize.xxxl * 3,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_alt,
                size: AppSize.xxxl + AppSize.lg,
                color: cs.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSize.xl),
            Text(
              'Tap the + button to create\nyour first note.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppText.body,
                color: cs.onSurface.withValues(alpha: 0.45),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
