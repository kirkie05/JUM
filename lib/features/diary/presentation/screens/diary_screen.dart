import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/diary_entry.dart';
import '../../data/providers/diary_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(diaryEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        centerTitle: true,
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No diary entries yet.\nTap + to write your thoughts!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      timeago.format(entry.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () => _showEntryEditor(context, ref, entry: entry),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryEditor(context, ref),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showEntryEditor(BuildContext context, WidgetRef ref, {DiaryEntry? entry}) {
    final isEditing = entry != null;
    final titleController = TextEditingController(text: entry?.title ?? '');
    final contentController = TextEditingController(text: entry?.content ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
                maxLines: 10,
                minLines: 5,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isEditing)
                    TextButton.icon(
                      onPressed: () {
                        ref.read(diaryEntriesProvider.notifier).deleteEntry(entry.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty && contentController.text.trim().isEmpty) {
                        Navigator.pop(context);
                        return;
                      }

                      final newEntry = DiaryEntry(
                        id: isEditing ? entry.id : const Uuid().v4(),
                        title: titleController.text.trim().isEmpty ? 'Untitled' : titleController.text.trim(),
                        content: contentController.text.trim(),
                        date: isEditing ? entry.date : DateTime.now(),
                        createdAt: isEditing ? entry.createdAt : DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      if (isEditing) {
                        ref.read(diaryEntriesProvider.notifier).updateEntry(newEntry);
                      } else {
                        ref.read(diaryEntriesProvider.notifier).addEntry(newEntry);
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
