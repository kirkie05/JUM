import re

with open('lib/features/admin/presentation/screens/admin_screens.dart', 'r') as f:
    content = f.read()

# Add a _showEventDialog
dialog_code = """
  void _showEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Event'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(decoration: InputDecoration(labelText: 'Title')),
                TextField(decoration: InputDecoration(labelText: 'Start Time (e.g. 10:00 AM)')),
                TextField(decoration: InputDecoration(labelText: 'End Time (e.g. 12:00 PM)')),
                TextField(decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
                Row(
                  children: [
                    Text('Is Published?'),
                    Spacer(),
                    Checkbox(value: false, onChanged: null),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
"""

if "_showEventDialog" not in content:
    content = content.replace("onAction: () => _showAdminSnack(context, 'Event draft created'),", "onAction: () => _showEventDialog(context),")
    # Insert _showEventDialog right before `Widget build` inside AdminEventsScreen
    content = content.replace("  @override\n  Widget build(BuildContext context, WidgetRef ref) {", dialog_code + "\n  @override\n  Widget build(BuildContext context, WidgetRef ref) {")
    with open('lib/features/admin/presentation/screens/admin_screens.dart', 'w') as f:
        f.write(content)

