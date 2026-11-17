import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/medical_record.dart';
import 'medical_record_detail_screen.dart';

class CategoryRecordsScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryKey; // 'Prescriptions', 'Lab Reports', 'Surgical', 'Vitals'
  final IconData icon;
  final Color themeColor;
  final List<MedicalRecord> records;

  const CategoryRecordsScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryKey,
    required this.icon,
    required this.themeColor,
    required this.records,
  });

  @override
  State<CategoryRecordsScreen> createState() => _CategoryRecordsScreenState();
}

class _CategoryRecordsScreenState extends State<CategoryRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicalRecord> _getFilteredRecords() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return widget.records;
    return widget.records.where((r) {
      return r.title.toLowerCase().contains(query) ||
          r.doctorOrLab.toLowerCase().contains(query) ||
          r.summary.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 5.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: 1.2,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.border),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  void _openRecordDetails(MedicalRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalRecordDetailScreen(
          record: record,
          themeColor: widget.themeColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredRecords();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.categoryTitle,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance centered title
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1.2),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search within ${widget.categoryTitle}...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: widget.themeColor,
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 42, minHeight: 42),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              size: 18, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // 2. Count Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} Documents Found',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Verified Clinical Records',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.themeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // 3. Document Cards List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.folder_open_rounded,
                              size: 30,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Documents Found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try adjusting your search query.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Column(
                        children: [
                          _buildCardItem(item),
                          _buildDottedLine(),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(MedicalRecord record) {
    return InkWell(
      onTap: () => _openRecordDetails(record),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Header Badge & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: widget.themeColor.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, size: 12, color: widget.themeColor),
                      const SizedBox(width: 4),
                      Text(
                        widget.categoryTitle,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: widget.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Title & Doctor / Lab
            Text(
              record.title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              record.doctorOrLab,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),

            // Solid Divider (No dotted line inside card)
            const Divider(height: 14, color: AppColors.border),

            // Row 3: File size & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 14,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.fileSize,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => _openRecordDetails(record),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Downloading ${record.title} (PDF)...'),
                            backgroundColor: widget.themeColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Download PDF',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}