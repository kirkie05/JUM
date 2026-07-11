with open('lib/features/community/presentation/screens/community_feed_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("import '../data/models/post_model.dart';", "import '../../data/models/post_model.dart';")
content = content.replace("import '../data/repositories/community_repository.dart';", "import '../../data/repositories/community_repository.dart';")

with open('lib/features/community/presentation/screens/community_feed_screen.dart', 'w') as f:
    f.write(content)
