import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
  final VoidCallback? onLongPress;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFromMe = message.isFromMe(currentUserId);
    final isDeleted = message.deletedAt != null;
    final formattedTime = '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: BoxDecoration(
                  color: isDeleted 
                      ? AppColors.background 
                      : (isFromMe ? AppColors.accent : AppColors.surface2),
                  border: isDeleted ? Border.all(color: AppColors.border, width: 1) : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isFromMe ? const Radius.circular(16) : Radius.zero,
                    bottomRight: isFromMe ? Radius.zero : const Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDeleted && message.attachments.isNotEmpty)
                      ...message.attachments.map((att) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: att.fileType == 'image' 
                              ? Image.network(att.fileUrl, fit: BoxFit.cover)
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.black12,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.insert_drive_file),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(att.fileName ?? 'Attachment', overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ),
                        ),
                      )).toList(),
                    Text(
                      message.body,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDeleted 
                            ? AppColors.textMuted 
                            : (isFromMe ? Colors.black : AppColors.textPrimary),
                        fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDeleted && message.reactions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Wrap(
                    spacing: 4.0,
                    children: message.reactions.map((r) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(r.emoji, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                  ),
                ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedTime,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                  if (message.isEdited) ...[
                    const SizedBox(width: 4.0),
                    Text('(edited)', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 10)),
                  ],
                  if (isFromMe) ...[
                    const SizedBox(width: 4.0),
                    Icon(
                      message.readAt != null ? Icons.done_all : Icons.check,
                      size: 14.0,
                      color: message.readAt != null ? AppColors.info : AppColors.textMuted,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
