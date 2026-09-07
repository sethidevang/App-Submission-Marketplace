import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// A self-contained search field: it owns its own [TextEditingController]
/// so it keeps focus and cursor position across the parent's rebuilds
/// (which happen often, since Provider rebuilds on every state change).
class SearchField extends StatefulWidget {
  final String hint;
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.hint,
    this.initialValue = '',
    this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 19, color: c.text3),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              enabled: widget.onChanged != null,
              style: TextStyle(fontSize: 14, color: c.text),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                hintText: widget.hint,
                hintStyle: TextStyle(color: c.text3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
