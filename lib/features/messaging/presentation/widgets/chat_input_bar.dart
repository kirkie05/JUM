import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String text, List<File> attachments) onSend;

  const ChatInputBar({
    Key? key,
    required this.onSend,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  List<File> _attachments = [];
  final _imagePicker = ImagePicker();
  bool _isCompressing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _isCompressing = true;
      });
      
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
      
      final XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 70,
      );

      if (compressedImage != null) {
        setState(() {
          _attachments.add(File(compressedImage.path));
        });
      }
      
      setState(() {
        _isCompressing = false;
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.onSend(text, List.from(_attachments));
    
    _controller.clear();
    setState(() {
      _attachments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_attachments.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8.0, top: 8.0),
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: FileImage(_attachments[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => _removeAttachment(index),
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.textMuted,
                  onPressed: _isCompressing ? null : _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                if (_isCompressing)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    color: AppColors.accent,
                    onPressed: (_controller.text.trim().isEmpty && _attachments.isEmpty) ? null : _handleSend,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
