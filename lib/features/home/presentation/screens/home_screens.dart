import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_avatar.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// HOME SCREEN
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Surface background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF3F4F6),
            height: 1.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'JUM',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () => context.push('/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA2R0xtoVk7LZ762kWYKIk03hx_eCInPWYeRk_2RGMkBlHHsevyCSHI6wLUaiT3sqyCPYOEt5gRUfeiCzxD6n0EcSqTHCrzrzqK8uhGtBdVRt3k6SVPV7pq1U_O9lz7CrEYb0u9mTsMnowpeNf6tbXzG8GpAvDp5fFKRYoqRrv358yC-vnAE5rRafIG3v4bGiUAVXinsHJvuBsWjf4Imo9nKzaTZYf08-lGYj5nMgAo-5dUyaaCprEAKzbHuTsTr2jcnO7g_K7KEg',
                  width: 32.0,
                  height: 32.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Color(0xFFEEEEEE),
                    child: Icon(Icons.person, size: 16.0, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting Section
            const Text(
              'Grace & Peace, JUM Member',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const Gap(4),
            const Text(
              'May your day be filled with intentional reflection.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                color: Color(0xFF6B7280),
              ),
            ),
            
            const Gap(24),
            
            // Bento Grid Actions
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: JumCard(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.favorite_outline, size: 28.0, color: Colors.black),
                          Gap(8),
                          Text(
                            'GIVE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: JumCard(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.live_tv, size: 28.0, color: Colors.black),
                          Gap(8),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: JumCard(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.volunteer_activism_outlined, size: 28.0, color: Colors.black),
                          Gap(8),
                          Text(
                            'PRAYER',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const Gap(32),
            
            // Featured Sermon Card
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuArX1Lt6rJFedRucDSWnu5eloTUStmQNpsGC4CTJwwkIZ9Z1AfWRR5IwaEwwvEhvEte57IpHsAHHgMUSapTvcJibHcO8SRV98QRREX0VJ85VWk4RyNKhyrXiSuQT89amPFAG3uzMmXTwRwjUJxE5S47gEoMtq_oLshwZVkE_hcGcRg-QbYAiIi9sK014EpC51uJz9K1ANqgw0ZHMpNzBjjhe2dAln1SVPt07BAymWY1xTEBIQ1XzXmnNKGYoX1we8JDOMIhhvLMTA',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFEEEEEE),
                              child: const Icon(Icons.church, size: 48.0, color: Colors.black26),
                            ),
                          ),
                        ),
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, size: 28.0, color: Colors.black),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Text(
                              'LATEST SERMON',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Gap(12),
                          const Text(
                            'The Path of Silence',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(4),
                          const Text(
                            'Rev. Elijah Thorne • 42 mins',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Gap(32),
            
            // Upcoming Events
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            
            const Gap(16),
            
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Event Card 1
                  Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDLDqsa_YrWP-r-680LkSCAwEmi7iCy2TY4QLPdVx1wj_K_x5PlrFcWqHTkO5QSOMQ3px39aBDuiwJWeHsZOA5A9DD9iHKtzw2xbKEGzBJIRy3Bcu4n5jDfRFHL5de9VaP-PBKvLg43BZ248TtKow1PExsQS9VhnLzLD3c2becnj1yJNfn2LvACQmKZnwYLc06MUmlJ96_0hnFEQ3egv4ZEbd0Cqf9vja_XSV-vA93tetIoh9_kkza6MxetgxjNw53ygxyF1YtgGQ',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'NOV 14 • 7:00 PM',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gap(4),
                              Text(
                                'Community Night',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Event Card 2
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCtksa2wW8oLkHeTgICRq-8PYMqNb0NpVdlqleV-V7WG_94czLJaua7uGdEb1lblOLdhIrPbYgSri-YzcW5s44pbY_pw5GeA36i1sVIwoaMM-j6wxM1VbBVa61KWB-tQGjlZglAYGzK4cJ-Gg2izLG4gh3ldVszaoPnyeAobRzhMFq4R2O_94lh0zI3MiSxi2JKg1Zi0wbp1DpfFgwWRuhu1_LLXRvawGuz0lYEDePQJ2PFIOZaJ4CvaIJ4oyhaHM8lXFvJaHKDSQ',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'NOV 16 • 6:30 AM',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gap(4),
                              Text(
                                'Morning Prayer',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Gap(32),
            
            // Community Highlights
            const Text(
              'Community Highlights',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const Gap(16),
            
            JumCard(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_stories, color: Colors.black),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New Reading Plan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Gap(4),
                        const Text(
                          'Join 240 others in \'The Wisdom of Ecclesiastes\' 10-day journey.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const Gap(8),
                        Row(
                          children: const [
                            Text(
                              'JOIN PLAN',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Gap(4),
                            Icon(Icons.chevron_right, size: 16.0, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Gap(16),
            
            JumCard(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.volunteer_activism_outlined, color: Colors.black),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Holiday Outreach',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Gap(4),
                        const Text(
                          'Volunteer spots are now open for the Annual Winter Soup Kitchen.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const Gap(8),
                        Row(
                          children: const [
                            Text(
                              'VOLUNTEER',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Gap(4),
                            Icon(Icons.chevron_right, size: 16.0, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
  }
}

// -------------------------------------------------------------
// MORE MENU SCREEN
// -------------------------------------------------------------
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'label': 'Gospel Army School', 'icon': Icons.school_outlined, 'route': '/school'},
      {'label': 'Holy Bible', 'icon': Icons.book_outlined, 'route': '/bible'},
      {'label': 'Upcoming Events', 'icon': Icons.event_note_outlined, 'route': '/events'},
      {'label': 'Messaging', 'icon': Icons.chat_bubble_outline_rounded, 'route': '/messaging'},
      {'label': 'Marketplace', 'icon': Icons.shopping_bag_outlined, 'route': '/marketplace'},
      {'label': 'Giving History', 'icon': Icons.history_edu_outlined, 'route': '/giving/history'},
      {'label': 'My Profile', 'icon': Icons.person_outline, 'route': '/profile'},
      {'label': 'Admin Dashboard', 'icon': Icons.admin_panel_settings_outlined, 'route': '/admin'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'More Menu',
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
      body: GridView.builder(
        padding: const EdgeInsets.all(24.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.15,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            onTap: () => context.push(item['route'] as String),
            borderRadius: BorderRadius.circular(12.0),
            child: JumCard(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 32.0,
                    color: Colors.black,
                  ),
                  const Gap(12),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
