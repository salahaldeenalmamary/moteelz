import 'dart:async';
import 'package:flutter/material.dart';

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;
  final String hintText;
  final Color? backgroundColor;
  final double elevation;

  const CustomSearchAppBar({
    super.key,
    this.onFilterPressed,
    this.onSearchChanged,
    this.hintText = 'ابحث عن بطاقة...',
    this.backgroundColor,
    this.elevation = 1.0,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  @override
  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _clearSearch() {
    _searchController.clear();

    widget.onSearchChanged?.call('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor ?? Theme.of(context).cardColor,
      elevation: widget.elevation,
      automaticallyImplyLeading: false,
      title: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: _buildBorder(Colors.grey.withOpacity(.25)),
            enabledBorder: _buildBorder(Colors.grey.withOpacity(.25)),
            focusedBorder: _buildBorder(Colors.grey.withOpacity(.25)),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onSubmitted: (value) {
            widget.onSearchChanged?.call(value);
          },
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
