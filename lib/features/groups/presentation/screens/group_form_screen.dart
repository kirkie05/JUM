import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/groups_providers.dart';

class GroupFormScreen extends ConsumerStatefulWidget {
  final String? groupId;
  const GroupFormScreen({Key? key, this.groupId}) : super(key: key);

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _visibility = 'open';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      _loadGroupData();
    }
  }

  Future<void> _loadGroupData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      final group = await repo.getGroupById(widget.groupId!);
      _nameController.text = group.name;
      _descriptionController.text = group.description ?? '';
      _visibility = group.visibility;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveGroup() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'visibility': _visibility,
      };
      
      if (widget.groupId == null) {
        await repo.createGroup(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group created successfully!')));
      } else {
        await repo.updateGroup(widget.groupId!, data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group updated successfully!')));
        ref.invalidate(groupDetailProvider(widget.groupId!));
      }
      ref.invalidate(groupsProvider(null));
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupId == null ? 'Create Group' : 'Edit Group'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Group Name', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _visibility,
                      decoration: const InputDecoration(labelText: 'Visibility', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('Open (Anyone can join)')),
                        DropdownMenuItem(value: 'private', child: Text('Private (Requires approval)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _visibility = val);
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _saveGroup,
                      child: Text(widget.groupId == null ? 'Create Group' : 'Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
