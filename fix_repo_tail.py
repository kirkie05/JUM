with open('lib/features/admin/data/repositories/admin_repository.dart', 'r') as f:
    content = f.read()

# remove everything after adminRepositoryProvider
index = content.find('final adminRepositoryProvider')
if index != -1:
    end_index = content.find('});', index)
    if end_index != -1:
        content = content[:end_index + 3] + '\n'

with open('lib/features/admin/data/repositories/admin_repository.dart', 'w') as f:
    f.write(content)
