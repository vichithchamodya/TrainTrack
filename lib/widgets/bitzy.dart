import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';

class Bitzy extends StatefulWidget {
  const Bitzy({super.key});

  @override
  BitzyState createState() => BitzyState();
}

class BitzyState extends State<Bitzy> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  String _getBotResponse(String userInput) {
    final message = userInput.toLowerCase().trim();

    bool containsAny(List<String> terms) {
      return terms.any(message.contains);
    }

    if (containsAny([
      "hello",
      "hi",
      "hey",
      "hola",
      "good morning",
      "good afternoon",
      "good evening",
    ])) {
      return "Hello! How can I assist you today?";
    }

    if (containsAny(["enroll", "enrol", "join", "register", "sign up"]) &&
        containsAny(["training", "course", "program"])) {
      return "To enroll in a training, open the Explore section, choose a training, and follow the enrollment or payment steps.";
    }

    if (containsAny(["pay", "payment", "price", "cost", "fee", "premium"])) {
      return "Premium training prices are shown on each training page. You can pay securely through the available payment options when enrolling.";
    }

    if (containsAny([
      "module",
      "lesson",
      "course material",
      "resources",
      "video",
    ])) {
      return "Open a training from Explore to access its lessons and course materials. Your progress is saved as you move through each lesson.";
    }

    if (containsAny([
      "study goal",
      "study plan",
      "study habit",
      "goal",
      "routine",
    ])) {
      return "You can manage your daily study goal from your profile and track your learning progress as you complete trainings.";
    }

    if (containsAny([
          "available",
          "catalog",
          "what can i learn",
          "subjects",
          "categories",
        ]) &&
        containsAny(["training", "course", "learn", "available", "subjects"])) {
      return "TrainTrack offers onboarding, leadership, compliance, workplace safety, health, and other professional development trainings. Browse them in Explore.";
    }

    if (containsAny(["certificate", "certification", "completion proof"])) {
      return "After you complete a training, open the certificate option on the completion screen to preview and download your PDF certificate.";
    }

    if (containsAny([
      "progress",
      "completed",
      "finish",
      "ongoing",
      "my training",
    ])) {
      return "You can view ongoing and completed trainings from My Trainings. Your completed lessons and study time are saved to your profile.";
    }

    if (containsAny(["thank", "thanks"])) {
      return "You're welcome! I'm here whenever you need help with TrainTrack.";
    }

    if (containsAny(["bye", "goodbye", "see you"])) {
      return "Goodbye! Keep making progress with your learning.";
    }

    return "I can help with trainings, enrollment, payments, lessons, study goals, progress, and certificates. What would you like to know?";
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add({"text": text, "isUser": true});

      // Simulate bot response with delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          final botResponse = _getBotResponse(text);
          _messages.add({"text": botResponse, "isUser": false});
        });
      });
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat Header
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kMainColor, kSubMainColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: kShadowColor,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                  bottom: 10,
                  right: 20,
                  left: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/gifs/onboarding_3.gif",
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Hi.. I'm Bitzy!\nHow can I help You ?",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // close button
              Positioned(
                top: 40,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 30, color: kWhiteColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),

        // Chat messages
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(10),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[_messages.length - 1 - index];
              return Align(
                alignment: message['isUser']
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: message["isUser"]
                          ? [kMainColor, kSubMainColor]
                          : [
                              Theme.of(context).appBarTheme.backgroundColor!,
                              Theme.of(context).appBarTheme.backgroundColor!,
                            ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: message['isUser']
                          ? const Radius.circular(20)
                          : const Radius.circular(0),
                      bottomRight: message['isUser']
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: kShadowColor,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: message['isUser'] ? kWhiteColor : null,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // input field
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: kShadowColor,
                  blurRadius: 8,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: "Message Bitzy...",
                      hintStyle: const TextStyle(color: kGreyColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: kSubMainColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
