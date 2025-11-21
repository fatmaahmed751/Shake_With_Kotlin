import 'package:flutter/material.dart';
import 'package:shake_app/Features/web_socket/web_socket_controller.dart';

class WebSocketChatView extends StatefulWidget {
  const WebSocketChatView({super.key});

  @override
  State<WebSocketChatView> createState() => _WebSocketChatViewState();
}

class _WebSocketChatViewState extends State<WebSocketChatView> {
  final WebSocketController controller = WebSocketController();
  final TextEditingController messageController = TextEditingController();
  final List<String> messages = [];

  @override
  void initState() {
    super.initState();
    controller.connect();

    controller.stream.listen((event) {
      setState(() {
        messages.add("Server: $event");
      });
    });
  }

  @override
  void dispose() {
    controller.disconnect();
    messageController.dispose();
    super.dispose();
  }

  void send() {
    if (messageController.text.isEmpty) return;

    String msg = messageController.text;
    controller.sendMessage(msg);

    setState(() {
      messages.add("You: $msg");
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("WebSocket Chat")),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: messages[index].startsWith("You:")
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: messages[index].startsWith("You:")
                            ? Colors.blue.shade200
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(messages[index]),
                    ),
                  );
                },
              ),
            ),

            // input
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Enter message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: send,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
