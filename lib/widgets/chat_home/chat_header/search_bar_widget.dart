import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController _searchController;
  const SearchBarWidget(
      {super.key, required TextEditingController searchController})
      : _searchController = searchController;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm bạn bè....',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.white),
      autofocus: true,
    );
  }
}
