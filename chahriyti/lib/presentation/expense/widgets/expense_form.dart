import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/extensions/l10n_extension.dart';

class ExpenseForm extends StatefulWidget {
  final Future<void> Function({
    required String itemName,
    required int amount,
    String? notes,
  }) onSave;

  final String? initialItemName;
  final int? initialAmount;
  final String? initialNotes;
  final bool isSaving;

  /// Selected expense category (drives hint text + suggestion source).
  final String? category;

  const ExpenseForm({
    super.key,
    required this.onSave,
    this.initialItemName,
    this.initialAmount,
    this.initialNotes,
    this.isSaving = false,
    this.category,
  });

  static String hintForCategory(String? category) {
    switch (category) {
      case 'essentials':
        return 'مثال: خبز، دجاج، ماء، دواء...';
      case 'homeFamily':
        return 'مثال: أدوات منزلية، هدية، مصروف البيت...';
      case 'luxuries':
        return 'مثال: قهوة، تيشيرت، ترفيه...';
      case 'health':
        return 'مثال: كشف طبي، دواء، تحاليل...';
      case 'transport':
        return 'مثال: وقود، تاكسي، تذكرة...';
      case 'clothing':
        return 'مثال: قميص، حذاء، بنطلون...';
      case 'restaurants':
        return 'مثال: بيتزا، برغر، قهوة...';
      case 'education':
        return 'مثال: كتاب، دروس خصوصية، دورة...';
      default:
        return 'مثال: صف ما اشتريته...';
    }
  }

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  // Autocomplete manages its own controller; we track the value here for submit.
  String _itemName = '';

  // Captured once from Autocomplete's fieldViewBuilder to avoid multi-listener.
  TextEditingController? _itemCtrl;

  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _itemName = widget.initialItemName ?? '';
    _amountController = TextEditingController(
      text: widget.initialAmount?.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    if (widget.category == null) return;
    try {
      final results = await Injection.getItemSuggestionsUseCase(widget.category!);
      if (mounted) setState(() => _suggestions = results);
    } catch (_) {}
  }

  @override
  void didUpdateWidget(ExpenseForm old) {
    super.didUpdateWidget(old);
    if (old.category != widget.category) _loadSuggestions();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    await widget.onSave(
      itemName: _itemName.trim(),
      amount: amount,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  Iterable<String> _optionsBuilder(TextEditingValue value) {
    if (_suggestions.isEmpty) return const [];
    final q = value.text.trim().toLowerCase();
    if (q.isEmpty) return _suggestions.take(8);
    return _suggestions.where((s) => s.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Amount ──────────────────────────────────────────────────────────
          _SectionLabel(label: context.l10n.price),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: '0',
              suffixText: context.l10n.currencySymbol,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return context.l10n.priceRequired;
              final n = int.tryParse(v.trim());
              if (n == null || n <= 0) return context.l10n.pricePositive;
              return null;
            },
          ),

          const SizedBox(height: 20),

          // ── Item name with dropdown suggestions ──────────────────────────
          _SectionLabel(label: context.l10n.whatDidYouBuy),
          const SizedBox(height: 8),
          Autocomplete<String>(
            initialValue: TextEditingValue(text: widget.initialItemName ?? ''),
            optionsBuilder: _optionsBuilder,
            displayStringForOption: (s) => s,
            onSelected: (value) => _itemName = value,
            fieldViewBuilder: (ctx, controller, focusNode, onFieldSubmitted) {
              // Sync controller reference once (fieldViewBuilder called on every build)
              if (_itemCtrl != controller) {
                _itemCtrl?.removeListener(_onItemChanged);
                _itemCtrl = controller;
                controller.addListener(_onItemChanged);
              }
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: ExpenseForm.hintForCategory(widget.category),
                ),
                validator: (_) => null, // item name is optional
              );
            },
            optionsViewBuilder: (ctx, onSelected, options) {
              return Align(
                alignment: AlignmentDirectional.topStart,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: AppColors.border),
                      itemBuilder: (_, i) {
                        final option = options.elementAt(i);
                        return InkWell(
                          onTap: () => onSelected(option),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(option, style: AppTypography.bodyMedium),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // ── Notes ────────────────────────────────────────────────────────
          _SectionLabel(label: context.l10n.notesOptional),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 2,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(hintText: context.l10n.additionalDetails),
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: widget.isSaving ? null : _submit,
            child: widget.isSaving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  void _onItemChanged() => _itemName = _itemCtrl?.text ?? '';
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.start,
    );
  }
}
