import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/core/theme/colors.dart';
import 'package:notes_app/features/notes/models/notes.dart';
import 'package:notes_app/features/notes/providers/notes_provider.dart';
import 'package:notes_app/features/notes/widgets/content_type_selector.dart';
import 'package:notes_app/features/notes/widgets/list_items_editor.dart';

import 'package:provider/provider.dart';

class AddNotes extends StatefulWidget {
  final Notes? editNotes;
  const AddNotes({super.key, this.editNotes});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController(); // used for plain mode type

  String _contentType = 'plain'; // 'plain' | 'bullet' | 'checkbox'
  final List<TextEditingController> _itemController = [];
  final List<bool> _checkedStates = [];

  bool get isEdit => widget.editNotes != null;

  @override
  void initState() {
    super.initState();
    final e = widget.editNotes;
    if (e != null) {
      _titleController.text = e.title;
      _contentType = e.contentType;
      if (_contentType == 'plain') {
        _descController.text = e.description;
      } else {
        for (int i = 0; i < e.items.length; i++) {
          _itemController.add(TextEditingController(text: e.items[i]));
          _checkedStates.add(i < e.checked.length ? e.checked[i] : false);
        }
        if (_itemController.isEmpty) _addItem();
      }
    } else {
      // Start with one empty item for list modes when user switches
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (final controller in _itemController) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _itemController.add(TextEditingController());
      _checkedStates.add(false);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _itemController[index].dispose();
      _itemController.removeAt(index);
      _checkedStates.removeAt(index);
    });
  }

  void _switchContentType(String type) {
    if (type == _contentType) return;
    setState(() {
      _contentType = type;
      // When switching to list mode and no items yet, add one
      if (type != 'plain' && _itemController.isEmpty) {
        _addItem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.watch<NotesProvider>().isDark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      // Rounded top corners sheet
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.sheetBgColorDark
            : AppColors.sheetBgColorLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSize.xxl),
        ),
        border: isDark
            ? Border(
                top: BorderSide(
                  color: cs.onSurface.withValues(alpha: 0.08),
                  width: 1,
                ),
              )
            : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            AppSize.lg, //  Pushes content above keyboard
        left: AppSize.xl,
        right: AppSize.xl,
        top: AppSize.lg,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: AppSize.xxxl + AppSize.sm,
                  height: AppSize.xs,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSize.xs / 2),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.lg),
              // Sheet Header
              Row(
                children: [
                  Text(
                    isEdit ? 'Edit Note' : 'Add Note',
                    style: TextStyle(
                      fontSize: AppText.displayMd,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: AppSize.lg),
  
              // Content type selector
              ContentTypeSelector(
                selected: _contentType,
                onChanged: _switchContentType,
              ),
              const SizedBox(height: AppSize.lg),
  
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: AppText.titleLg,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: AppSize.md),
                    // Content area
                    if (_contentType == 'plain')
                      TextFormField(
                        controller: _descController,
                        maxLines: 5,
                        minLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                      )
                    else
                      ListItemsEditor(
                        contentType: _contentType,
                        controllers: _itemController,
                        checkedStates: _checkedStates,
                        onAdd: _addItem,
                        onRemove: _removeItem,
                        onCheckChanged: (i, val) => setState(() {
                          _checkedStates[i] = val;
                        }),
                      ),
                    const SizedBox(height: AppSize.sm),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _save,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: AppText.titleLg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final title = _titleController.text.trim();
    final provider = context.read<NotesProvider>();

    String description;
    List<String> items;
    List<bool> checked;

    if (_contentType == 'plain') {
      description = _descController.text.trim();
      items = [];
      checked = [];
    } else {
      items = _itemController.map((c) => c.text.trim()).toList();
      description = items.join('\n');
      checked = _contentType == 'checkbox'
          ? List<bool>.from(_checkedStates)
          : <bool>[];
    }

    if (isEdit) {
      await provider.editNotes(
        title: title,
        description: description,
        id: widget.editNotes!.id,
        contentType: _contentType,
        items: items,
        checked: checked,
      );
    } else {
      await provider.addNotes(
        title: title,
        description: description,
        contentType: _contentType,
        items: items,
        checked: checked,
      );
      _formKey.currentState!.reset();
    }

    if (mounted) Navigator.pop(context);
  }
}
