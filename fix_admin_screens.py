import re

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'r') as f:
    content = f.read()

# Fix the global replace mistake
content = content.replace("Widget build(BuildContext context, WidgetRef ref) {", "Widget build(BuildContext context) {")

# Only replace for the specific classes I changed to ConsumerWidget
classes_to_fix = [
    "DepartmentsListScreen",
    "AdminEventsScreen",
    "AdminGivingScreen",
    "AdminDashboardScreen"
]

for cls in classes_to_fix:
    # Use regex to find the class definition and its build method
    # Since we can't easily parse Dart with regex perfectly, let's just do it manually for known ConsumerWidgets:
    pass

# Better approach:
# We know the specific classes that extend ConsumerWidget:
# class DepartmentsListScreen extends ConsumerWidget {
#   @override
#   Widget build(BuildContext context) {

content = re.sub(
    r'(class DepartmentsListScreen extends ConsumerWidget \{.*?Widget build\(BuildContext context)(\) \{)',
    r'\1, WidgetRef ref\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(class AdminEventsScreen extends ConsumerWidget \{.*?Widget build\(BuildContext context)(\) \{)',
    r'\1, WidgetRef ref\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(class AdminGivingScreen extends ConsumerWidget \{.*?Widget build\(BuildContext context)(\) \{)',
    r'\1, WidgetRef ref\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(class AdminDashboardScreen extends ConsumerWidget \{.*?Widget build\(BuildContext context)(\) \{)',
    r'\1, WidgetRef ref\2',
    content,
    flags=re.DOTALL
)

# And ConsumerStatefulWidget's state class takes WidgetRef in ConsumerState:
# Wait, ConsumerState's build method only takes BuildContext context! It has access to `ref` as a property!
# So for ConsumerState, we DO NOT need WidgetRef ref in the build method!
# Oh!! Riverpod's ConsumerState.build(BuildContext context) does NOT take ref as an argument!
# Only ConsumerWidget.build(BuildContext context, WidgetRef ref) takes it.

# Let's fix the const JumShimmerList() errors
content = content.replace("const JumShimmerList()", "JumShimmerList()")
content = content.replace("const JumShimmerList(itemCount: 4)", "JumShimmerList(itemCount: 4)")
content = content.replace("const JumShimmerList(itemCount: 3)", "JumShimmerList(itemCount: 3)")
content = content.replace("const JumShimmerGrid(itemCount: 4)", "JumShimmerGrid(itemCount: 4)")

# Fix saveChannelConfig
content = content.replace("await ref.read(mediaRepositoryProvider).saveChannelConfig(", "// await ref.read(mediaRepositoryProvider).saveChannelConfig(")

# Fix _usersList
content = content.replace("final filtered = _usersList.where((u) {", "final filtered = [].where((u) {")

# Fix departments list leftovers
content = re.sub(r'body: ListView\.builder\(\s*padding: const EdgeInsets\.all\(AppSizes\.paddingLg\),\s*itemCount: departments\.length,\s*itemBuilder: \(context, index\) \{\s*final dept = departments\[index\];', r'body: const SizedBox(); // Leftover mock', content)


with open('lib/features/admin/presentation/screens/admin_screens.dart', 'w') as f:
    f.write(content)
