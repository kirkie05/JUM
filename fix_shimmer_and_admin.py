import re

with open('lib/shared/widgets/jum_shimmer.dart', 'r') as f:
    content = f.read()

content = content.replace('''        child: JumShimmer(
          width: double.infinity,
          height: 80,
          borderRadius: 8,
        ),''', '''        child: JumShimmer.card(height: 80),''')

content = content.replace('''      itemBuilder: (context, index) => JumShimmer(
        width: double.infinity,
        height: 120,
        borderRadius: 8,
      ),''', '''      itemBuilder: (context, index) => JumShimmer.card(height: 120),''')

with open('lib/shared/widgets/jum_shimmer.dart', 'w') as f:
    f.write(content)


with open('lib/features/admin/presentation/screens/admin_screens.dart', 'r') as f:
    admin_content = f.read()

# Fix the saveChannelConfig comment
admin_content = re.sub(
    r'await ref\s*\.read\(mediaRepositoryProvider\)\s*\/\/\.saveChannelConfig\(\s*context,\s*channelId: _channelIdController\.text,\s*\);',
    '/* await ref.read(mediaRepositoryProvider).saveChannelConfig(context, channelId: _channelIdController.text); */',
    admin_content,
    flags=re.DOTALL
)

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'w') as f:
    f.write(admin_content)

