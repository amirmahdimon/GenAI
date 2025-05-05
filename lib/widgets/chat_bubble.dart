import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_ai/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:gen_ai/providers/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  // تابع تشخیص متن فارسی
  bool _isPersian(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isPersian = _isPersian(message.text);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Colors.green
              : (isDark ? Colors.grey[900] : Colors.grey[300]),
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white),
                textDirection:
                    isPersian ? TextDirection.rtl : TextDirection.ltr,
                textAlign: isPersian ? TextAlign.right : TextAlign.left,
              )
            : Html(
                data: message.text,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    color: isDark ? Colors.white : Colors.black,
                    direction:
                        isPersian ? TextDirection.rtl : TextDirection.ltr,
                    textAlign: isPersian ? TextAlign.right : TextAlign.left,
                  ),
                  "h1": Style(
                    fontSize: FontSize(24),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(bottom: 8),
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  "h2": Style(
                    fontSize: FontSize(20),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(bottom: 8),
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 8),
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  "code": Style(
                    backgroundColor: isDark ? Colors.black54 : Colors.grey[200],
                    padding: HtmlPaddings.all(4),
                    fontFamily: "monospace",
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  "pre": Style(
                    backgroundColor: isDark ? Colors.black54 : Colors.grey[200],
                    padding: HtmlPaddings.all(8),
                    margin: Margins.symmetric(vertical: 8),
                    color: isDark ? Colors.white : Colors.black,
                  ),
                },
              ),
      ),
    );
  }
}
