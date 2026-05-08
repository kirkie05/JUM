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

class _GlobalSearchScreenState extends State<GlobalSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = ['Spiritual Disciplines 101', 'Worship Night November'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            
            // Tab Pill Buttons using custom styled container
            SizedBox(
              height: 40,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF6B7280),
                labelStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('ALL'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('SERMONS'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('USERS'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('EVENTS'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('COURSES'))),
                ],
              ),
            ),
            
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
            
            // Suggested / Results Section
            const Text(
              'Suggested for you',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const Gap(16),
            
            // Sermon Result Card
            InkWell(
              onTap: () {},
              child: JumCard(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDZUh1_Mcrj-NiJAZPHFmauzRjfgkxK8wtTTOGvuIxX-Apn605bLvhpmjXV5OQZOavbf-b2rrye1OvhTdnSZftgliuSHt-Nz-Edt8LbriFjlfxqIKWPO_JGRMrTGSXPLJ8KEtv76jBahO4mNQ4rqszmaU508da1BgG132tAGpEzZrWvUkeZYEhu-1YKv89tz-zfoJ080iWNbT8eQ8d3NMPAAQkoY09oCFizhQ9D5wN0uX4p26J_5-zaYWa6JaIqXEKU_OdoKbUbIQ',
                        width: 64.0,
                        height: 64.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64.0,
                          height: 64.0,
                          color: const Color(0xFFEEEEEE),
                          child: const Icon(Icons.book),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'SERMON',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                              const Gap(8),
                              const Text(
                                '24 mins',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          const Text(
                            'Walking in Faith',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(2),
                          const Text(
                            'Pastor David Chen',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
                  ],
                ),
              ),
            ),
            
            const Gap(12),
            
            // User Result Card
            InkWell(
              onTap: () {},
              child: JumCard(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAov8jbLqk60Y-4mClHswCzqyPLOvlA1nglQsKxuCF108YnN5ZC3OF0k4C_UTV5TzYPzpazabvMAs5dLM_CP7vQ-40OXB4lQ4tV51Tb7PGvE4TiOkujp_r4PC04vgmxe3stuE9MxoJYhJnGoJXwV4A2Gnbf3sDllDhQYCNBmec0B7Mgs2bE3eozqqBkdNFiCh8tp6NLy7soXva8RqHAVDAzL_U6Tk8NHabo8LM5le2rvRPVuOgnrrzEW12kmS5RKU_w-BhWNM-N1g',
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                          radius: 24.0,
                          backgroundColor: Color(0xFFEEEEEE),
                          child: Icon(Icons.person, color: Colors.black26),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'James Wilson',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Gap(2),
                          Text(
                            'Community Leader • Youth Ministry',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Gap(12),
            
            // Event Result Card
            InkWell(
              onTap: () {},
              child: JumCard(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '14',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'DEC',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Text(
                              'EVENT',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 8.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ),
                          const Gap(6),
                          const Text(
                            'Winter Prayer Retreat',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(2),
                          const Text(
                            'Main Sanctuary • 6:30 PM',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined, size: 20.0, color: Color(0xFFD1D5DB)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
