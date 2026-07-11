import re

with open('lib/features/home/presentation/screens/home_screens.dart', 'r') as f:
    content = f.read()

# I need to append the _buildLatestSermonSection function to the end of the class.
# Let's find the end of the file. The last function is `_buildRadioPlaceholder` probably, 
# or we can just inject it before the last `}` of the class.

latest_sermon_func = """
  Widget _buildLatestSermonSection(BuildContext context, WidgetRef ref) {
    final latestSermonAsync = ref.watch(latestSermonProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Sermon',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Gap(16),
        latestSermonAsync.when(
          data: (sermon) {
            if (sermon == null) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () {
                // Assuming route is something like /sermons/:id
                context.push('/sermons/${sermon.id}');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              sermon.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sermon.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(8),
                          Text(
                            sermon.publishedAt.toIso8601String().split('T').first,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }
"""

if "_buildLatestSermonSection" not in content:
    # Insert before the last '}' which ends the _HomeScreenState class
    # The file ends with:
    #   Widget _buildRadioPlaceholder({bool loading = false}) {
    #       ...
    #   }
    # }
    
    # Simple trick: replace the last '}' with the new function + '}'
    parts = content.rsplit('}', 1)
    if len(parts) == 2:
        new_content = parts[0] + latest_sermon_func + '\n}'
        with open('lib/features/home/presentation/screens/home_screens.dart', 'w') as f:
            f.write(new_content)
