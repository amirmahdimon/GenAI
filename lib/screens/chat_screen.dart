import 'package:flutter/material.dart';
import 'package:gen_ai/constant/secret_key.dart';
import 'package:gen_ai/widgets/chat_bubble.dart';
import 'package:gen_ai/widgets/chat_message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:gen_ai/providers/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Content> _chatHistory = []; // تاریخچه چت برای Gemini
  bool _isGenerating = false;

  late GenerativeModel _model;
  late ChatSession _chat; // چت فعلی
  List<ChatSession> _chatSessions = []; // لیست تمام چت‌ها
  int _currentSessionIndex = -1; // ایندکس چت فعلی

  // نگهداری پیام‌های هر چت به صورت مجزا
  final Map<int, List<ChatMessage>> _sessionMessages = {};

  // نگهداری نام هر چت
  final Map<int, String> _chatNames = {};

  @override
  void initState() {
    super.initState();
    // راه‌اندازی اولیه Gemini
    const String apiKey = GenAiKey;
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _startNewChat(); // شروع یک چت جدید در ابتدا
  }

  // ایجاد یک چت جدید
  void _startNewChat() {
    _chat = _model.startChat();
    _chatSessions.add(_chat);
    _currentSessionIndex = _chatSessions.length - 1;

    // ایجاد لیست خالی برای پیام‌های چت جدید
    _sessionMessages[_currentSessionIndex] = [];

    setState(() {
      _messages.clear();
      _chatHistory.clear();
    });
  }

  // بارگذاری یک چت قبلی
  void _loadChatSession(int index) {
    setState(() {
      _currentSessionIndex = index;
      _chat = _chatSessions[index];
      _messages.clear();
      _messages.addAll(_sessionMessages[index] ?? []);
    });
  }

  // تولید نام برای چت بر اساس اولین پیام
  String _generateChatName(String message) {
    return message.length > 20 ? '${message.substring(0, 20)}...' : message;
  }

  // ارسال پیام و دریافت پاسخ
  Future<void> _sendMessage() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true);

    // تنظیم نام چت برای اولین پیام
    if (_sessionMessages[_currentSessionIndex]?.isEmpty ?? true) {
      _chatNames[_currentSessionIndex] = _generateChatName(text);
    }

    setState(() {
      _messages.add(userMessage);
      _sessionMessages[_currentSessionIndex]?.add(userMessage);
      _chatHistory.add(Content.text(text)); // اضافه کردن پیام کاربر به تاریخچه
      _textController.clear();
      _isGenerating = true;
    });

    try {
      // ارسال تمام تاریخچه چت به Gemini
      final response = await _chat.sendMessage(
        Content.text(
          _messages.map((msg) => msg.text).join('\n'),
        ),
      );

      final aiText = response.text;
      if (aiText != null) {
        final cleanedText = _cleanText(aiText);
        final aiMessage = ChatMessage(text: cleanedText, isUser: false);
        setState(() {
          _messages.add(aiMessage);
          _sessionMessages[_currentSessionIndex]?.add(aiMessage);
          _chatHistory
              .add(Content.text(cleanedText)); // اضافه کردن پاسخ AI به تاریخچه
          _isGenerating = false;
        });
      }
    } catch (e) {
      // مدیریت خطا
      final errorMessage = ChatMessage(text: 'Error: $e', isUser: false);
      setState(() {
        _messages.add(errorMessage);
        _sessionMessages[_currentSessionIndex]?.add(errorMessage);
        _isGenerating = false;
      });
    }

    // اسکرول به آخرین پیام
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // حذف یک چت
  void _deleteChat(int index) {
    setState(() {
      _chatSessions.removeAt(index);
      _sessionMessages.remove(index);
      _chatNames.remove(index);

      // بازسازی ایندکس‌های چت‌های باقیمانده
      final newSessionMessages = <int, List<ChatMessage>>{};
      final newChatNames = <int, String>{};
      for (int i = 0; i < _chatSessions.length; i++) {
        if (_sessionMessages.containsKey(i)) {
          newSessionMessages[i] = _sessionMessages[i + 1] ?? [];
          newChatNames[i] = _chatNames[i + 1] ?? 'Chat ${i + 1}';
        }
      }
      _sessionMessages.clear();
      _sessionMessages.addAll(newSessionMessages);
      _chatNames.clear();
      _chatNames.addAll(newChatNames);

      // مدیریت چت فعلی پس از حذف
      if (_currentSessionIndex == index) {
        if (_chatSessions.isEmpty) {
          _startNewChat();
        } else {
          _loadChatSession(_chatSessions.length - 1);
        }
      } else if (_currentSessionIndex > index) {
        _currentSessionIndex--; // تنظیم ایندکس چت فعلی
      }
    });
  }

  // اضافه کردن این متد برای پاکسازی متن
  String _cleanText(String text) {
    var cleanText = text
        .replaceAll(r'\n', '<br><br>') // دو خط فاصله برای نیولاین‌ها
        .replaceAll(
            r'```', '\n<pre><code>') // اضافه کردن نیولاین قبل از کد بلاک
        .replaceAll(r'`', '<code>') // تبدیل کد این‌لاین
        .replaceAllMapped(
            RegExp(r'\*\*(.+?)\*\*'),
            (match) =>
                '<strong>${match[1]}</strong>\n' // اضافه کردن نیولاین بعد از بولد
            )
        .replaceAllMapped(
            RegExp(r'\*(.+?)\*'),
            (match) =>
                '<em>${match[1]}</em>\n' // اضافه کردن نیولاین بعد از ایتالیک
            )
        .replaceAll(r'`', '</code>\n') // اضافه کردن نیولاین بعد از کد
        .replaceAll(r'</pre></code>',
            '</code></pre>\n\n'); // دو خط فاصله بعد از کد بلاک

    // تبدیل کدهای یونیکد
    cleanText = cleanText.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );

    // اضافه کردن فاصله بین پاراگراف‌ها
    cleanText = '<p>${cleanText.split('\n\n').join('</p><p>')}</p>';

    return cleanText;
  }

  // اضافه کردن تابع تشخیص متن فارسی به کلاس
  bool _isPersian(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: AppBar(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              side: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
                width: 1,
              ),
            ),
            title: const Text('Gemini Chat'),
            elevation: 0,
            backgroundColor: isDark ? Colors.black : Colors.white,
            foregroundColor: isDark ? Colors.white : Colors.black,
            actions: [
              PopupMenuButton<int>(
                color: isDark ? Colors.black : Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? Colors.white12 : Colors.black12,
                    width: 1,
                  ),
                ),
                icon: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white : Colors.black,
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: -1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'New Chat',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(
                      height: 1,
                    ),
                    ..._chatSessions.asMap().entries.map((entry) {
                      final index = entry.key;
                      return PopupMenuItem<int>(
                        value: index,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _chatNames[index] ?? 'Chat ${index + 1}',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              onPressed: () {
                                _deleteChat(index);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    })
                  ];
                },
                onSelected: (value) {
                  if (value == -1) {
                    _startNewChat();
                  } else {
                    _loadChatSession(value);
                  }
                },
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.android, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'AI Assistant',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return ChatBubble(message: message);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          textDirection: _isPersian(_textController.text)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign: _isPersian(_textController.text)
                              ? TextAlign.right
                              : TextAlign.left,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.white12 : Colors.black12,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (text) {
                            // برای آپدیت جهت متن حین تایپ
                            setState(() {});
                          },
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color:
                                _isGenerating ? Colors.grey[300] : Colors.white,
                          ),
                          onPressed: _isGenerating ? null : _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isGenerating)
            Container(
              color: isDark ? Colors.black54 : Colors.white54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.white12 : Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Generating response...',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
