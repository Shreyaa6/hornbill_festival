import 'package:flutter/material.dart';

Future<String?> showAppFilterBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  required String selectedItem,
  String Function(String)? displayLabel,
  bool sortAlphabetically = true,
}) {
  final List<String> sortedItems = List.from(items);
  if (sortAlphabetically) {
    final allItems = sortedItems
        .where((i) =>
            i.toLowerCase().startsWith('all') ||
            i.toLowerCase().startsWith('any'))
        .toList();
    final otherItems = sortedItems
        .where((i) =>
            !i.toLowerCase().startsWith('all') &&
            !i.toLowerCase().startsWith('any'))
        .toList();
    otherItems.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    sortedItems.clear();
    sortedItems.addAll(allItems);
    sortedItems.addAll(otherItems);
  }

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final maxHeight = MediaQuery.of(ctx).size.height * 0.72;
      return SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),

              // List of items
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedItems.length,
                  itemBuilder: (context, idx) {
                    final item = sortedItems[idx];
                    final isSel = item.toLowerCase() == selectedItem.toLowerCase() ||
                        (selectedItem == "All" && item == "All") ||
                        (selectedItem == "All" && item == "Any district");
                    final label = displayLabel != null ? displayLabel(item) : item;

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                      title: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 16,
                          color: isSel
                              ? const Color(0xFF20B08D)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF20B08D),
                              size: 22,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(ctx, item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
