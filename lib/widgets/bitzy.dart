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

  // Custom logic for generating bot responses
  String _getBotResponse(String userInput) {
    List<String> greetings = [
      "hello",
      "hell",
      "hi",
      "hey",
      "hola",
      "morning",
      "evening",
    ];
    for (var greeting in greetings) {
      if (userInput.toLowerCase().contains(greeting)) {
        return "Hello! How can I assist you today?";
      }
    }

    List<String> greet = [
      "How do I enroll in a training?",
      "I want to join a new training.",
      "How do i get started ?",
      "Can you guide me on training registration?",
    ];
    for (var greet in greet) {
      if (userInput.toLowerCase().contains(greet)) {
        return "To enroll in a training, go to the 'Trainings' section in the app, select your desired training, and follow the payment instructions. Let me know if you need more help!";
      }
    }

    List<String> payments = [
      "Do you support online payments?",
      "What payment methods are available?",
      "How can I pay for a training?",
    ];
    for (var payments in payments) {
      if (userInput.toLowerCase().contains(payments)) {
        return "Traintrack supports online payments via credit/debit cards and mobile wallets. You can pay securely through the app when enrolling in a training.";
      }
    }

    List<String> modules = [
      "Where can I find training modules?",
      "How do I access the course materials?",
      "Can you show me the available modules?",
    ];
    for (var modules in modules) {
      if (userInput.toLowerCase().contains(modules)) {
        return "You can access training modules in the 'Resources' section of the app. Just select your subject, and you'll find all the available modules.";
      }
    }

    List<String> goals = [
      "I want to improve my study habits.",
      "Can you suggest a study plan for me?",
      "How does the study goal feature work?",
    ];
    for (var goals in goals) {
      if (userInput.toLowerCase().contains(goals)) {
        return "Traintrack analyzes your learning patterns and study time to create personalized study goals. You can check your study progress in the 'Study Goals' section.";
      }
    }

    List<String> trainingCategories = [
      "What trainings are available?",
      "Do you have Technical trainings?",
      "Can I learn Leadership Management here?",
    ];
    for (var category in trainingCategories) {
      if (userInput.toLowerCase().contains(category.toLowerCase())) {
        return "Yes! Traintrack offers various trainings in Onboarding & Orientation, Leadership & Management, Compliance & Legal, Workplace Safety & Health and more. Check them in the 'Explore' section.";
      }
    }

    if (userInput.toLowerCase().contains("ddd")) {
      return "Hello! How can I assist you today?";
    } else if (userInput.toLowerCase().contains("price")) {
      return "The prices vary based on the item. Could you specify which item you're asking about?";
    } else if (userInput.toLowerCase().contains("training")) {
      return "I can help you find available trainings. Which subject are you interested in?";
    } else {
      return "Sorry, I didn't quite get that. Could you please rephrase?";
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add({"text": text, "isUser": true});

      // Simulate bot response with delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          String botResponse = _getBotResponse(text); // Get custom bot response
          _messages.add({"text": botResponse, "isUser": false});
        });
      });
    });

    _controller.clear();
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
