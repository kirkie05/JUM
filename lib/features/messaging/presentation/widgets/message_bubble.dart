import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFromMe = message.isFromMe(currentUserId);
    final formattedTime = '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: isFromMe ? AppColors.accent : AppColors.surface2,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isFromMe ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isFromMe ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.body,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isFromMe ? Colors.black : AppColors.textPrimary,
                ),
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
    );
  }
}
