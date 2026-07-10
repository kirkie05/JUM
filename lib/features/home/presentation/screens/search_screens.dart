import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({Key? key}) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = ['Spiritual Disciplines 101', 'Worship Night November'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Surface background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF3F4F6),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Input Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search sermons, users, or events...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    color: Color(0xFF9CA3AF),
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            
            const Gap(24),
            
            const Gap(8),
            
            const Gap(32),
            
            // Recent Searches Section
            if (_searchQuery.isEmpty && _recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                    },
                    child: const Text(
                      'CLEAR ALL',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              ..._recentSearches.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Color(0xFF9CA3AF)),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _recentSearches.remove(item);
                        });
                      },
                      child: const Icon(Icons.close, color: Color(0xFFD1D5DB)),
                    ),
                  ],
                ),
              )).toList(),
              const Gap(24),
            ],
            
            const Gap(1),
          ],
        ),
      ),
    );
  }
}
