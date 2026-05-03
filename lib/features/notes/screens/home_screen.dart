import 'package:flutter/material.dart';
import 'package:notes_app/features/notes/widgets/notes_empty_state.dart';
import 'package:notes_app/features/notes/screens/add_notes.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/core/theme/colors.dart';
import 'package:notes_app/features/notes/screens/detail_screen.dart';
import 'package:notes_app/features/notes/widgets/notes_card.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:notes_app/features/notes/widgets/sort_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // Open Add/Edit Sheet
  void _openAddSheet(BuildContext context) {
    focusNode.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddNotes(),
    ).then((_) {
      // Ensure focus is cleared again when the sheet is dismissed
      focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final notes = provider.notes;
    final cs = Theme.of(context).colorScheme;
    final isDark = provider.isDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? AppSize.xl * 1.5 : AppSize.lg;

    int crossAxisCount = 2;
    if (screenWidth < 350) {
      crossAxisCount = 1;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            overflow: TextOverflow.ellipsis,
          ),

          actions: [
            IconButton(
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  provider.isDark ? Icons.wb_sunny : Icons.dark_mode,
                  key: ValueKey(isDark),
                ),
              ),
              onPressed: provider.toggleTheme,
            ),
            const SizedBox(width: AppSize.xs),
          ],
        ),
        //// ================= FAB =============
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddSheet(context),
          tooltip: 'New Note',
          child: const Icon(Icons.add),
        ),

        // =========BODY ==============
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSize.sm),
              // Search + Sort Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: focusNode,
                      onChanged: (value) =>
                          context.read<NotesProvider>().searchFilter(value),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        suffixIcon: ValueListenableBuilder(
                          valueListenable: searchController,
                          builder: (context, value, child) {
                            return value.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      context
                                          .read<NotesProvider>()
                                          .searchFilter('');
                                    },
                                    icon: const Icon(Icons.clear),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        labelText: 'Search Notes',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.sm),
                  // Sort Button — uses Builder to capture correct RenderBox
                  Builder(
                    builder: (btnCtx) => Material(
                      color: cs.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppSize.inputRadius),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppSize.inputRadius,
                        ),
                        onTap: () => showSortMenu(btnCtx, provider),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.md),
                          child: Icon(
                            Icons.sort_rounded,
                            color: provider.sortOption != SortOption.newest
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.lg),
              // ── Notes count label ───────────────────────────────────────
              if (notes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.sm),
                  child: Text(
                    '${notes.length} Note${notes.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: AppText.caption,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

              // ── Grid or Empty state ────────────────────────────────────
              Expanded(
                child: notes.isEmpty
                    ? NotesEmptyState(onAdd: () => _openAddSheet(context))
                    : MasonryGridView.count(
                        crossAxisCount: crossAxisCount, // Number of columns

                        mainAxisSpacing: AppSize.sm, // vertical gap
                        crossAxisSpacing: AppSize.sm, //horizontal gap
                        padding: const EdgeInsets.only(
                          bottom: AppSize.xxxl * 2,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          // Pick a card color (cycle through palette)

                          final cardColor = AppColors.cardColorsLight;
                          final color = cardColor[index % cardColor.length];
                          return NotesCard(
                            note: note,
                            cardColor: color,
                            isDark: isDark,
                            onTap: () {
                              focusNode.unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(note: note),
                                ),
                              ).then((_) => focusNode.unfocus());
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
