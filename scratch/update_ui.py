import re

with open('lib/features/bible/presentation/screens/bible_screens.dart', 'r') as f:
    content = f.read()

old_picker = """    final currentTrans = ref.watch(bibleTranslationProvider);
    const supported = ['BSB', 'KJV', 'ASV', 'WEB', 'FBV', 'RV'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Translation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Gap(24),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: supported.map((t) => ListTile(
                  title: Text(t, style: TextStyle(
                    fontWeight: t == currentTrans ? FontWeight.bold : FontWeight.normal,
                    color: t == currentTrans ? AppColors.primary : Colors.black87,
                  )),
                  trailing: t == currentTrans ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(bibleTranslationProvider.notifier).state = t;
                    Navigator.pop(ctx);
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );"""

new_picker = """    final currentTrans = ref.watch(bibleTranslationProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Translation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Gap(16),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: bibleTranslationsMap.entries.map((entry) {
                    final t = entry.key;
                    final name = entry.value;
                    return ListTile(
                      title: Text(name, style: TextStyle(
                        fontWeight: t == currentTrans ? FontWeight.bold : FontWeight.normal,
                        color: t == currentTrans ? AppColors.primary : Colors.black87,
                      )),
                      subtitle: Text(t, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      trailing: t == currentTrans ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        ref.read(bibleTranslationProvider.notifier).state = t;
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );"""

content = content.replace(old_picker, new_picker)

with open('lib/features/bible/presentation/screens/bible_screens.dart', 'w') as f:
    f.write(content)
