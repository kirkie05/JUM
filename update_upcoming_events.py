import re

with open('lib/features/home/presentation/screens/home_screens.dart', 'r') as f:
    content = f.read()

# I want to replace the hardcoded ListView with `eventsAsync.when(...)`
# The current list view starts around:
#                 SizedBox(
#                   height: 220,
#                   child: ListView(
#                     scrollDirection: Axis.horizontal,
#                     children: [
#                       // Event Card 1

replacement_code = """
                ref.watch(upcomingEventsProvider).when(
                  data: (events) {
                    if (events.isEmpty) {
                      return const Center(child: Text('No upcoming events.'));
                    }
                    return SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return GestureDetector(
                            onTap: () => context.push('/events/${event.id}'),
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    child: Image.network(
                                      event.coverUrl.isNotEmpty ? event.coverUrl : 'https://placehold.co/600x400/png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Gap(8),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                            const Gap(4),
                                            Text(
                                              event.date.toIso8601String().split('T').first,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
"""

pattern = r'SizedBox\(\s*height:\s*220,\s*child:\s*ListView\(\s*scrollDirection:\s*Axis\.horizontal,\s*children:\s*\[.*?\]\s*,\s*\)\s*,\s*\)'

content = re.sub(pattern, replacement_code, content, flags=re.DOTALL)

with open('lib/features/home/presentation/screens/home_screens.dart', 'w') as f:
    f.write(content)

