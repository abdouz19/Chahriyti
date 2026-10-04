import 'package:flutter/material.dart';

import '../../../core/constants/communes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CommunePickerSheet extends StatefulWidget {
  final int wilayaCode;
  final void Function(String commune) onSelected;

  const CommunePickerSheet({
    super.key,
    required this.wilayaCode,
    required this.onSelected,
  });

  @override
  State<CommunePickerSheet> createState() => _CommunePickerSheetState();
}

class _CommunePickerSheetState extends State<CommunePickerSheet> {
  final TextEditingController _search = TextEditingController();
  late List<String> _all;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _all = communesByWilaya[widget.wilayaCode] ?? [];
    _filtered = _all;
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _search.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filtered = _all;
      } else {
        _filtered = _all.where((c) => c.contains(query)).toList();
      }
    });
  }

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اختر بلديتك', style: AppTypography.headlineSmall),
                const SizedBox(height: 12),
                TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن بلديتك...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final commune = _filtered[index];
                return ListTile(
                  title: Text(commune),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelected(commune);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
