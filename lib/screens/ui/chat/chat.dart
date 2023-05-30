import 'package:flutter/material.dart';

class User {
  final String name;
  final String image;
  bool hasNotification;
  bool hasViewed;

  User({
    required this.name,
    required this.image,
    this.hasNotification = false,
    this.hasViewed = false,
  });
}

class UserSelectionPage extends StatefulWidget {
  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  final List<User> users = [
    User(name: 'John', image: 'assets/images/user1.jpg'),
    User(name: 'Emma', image: 'assets/images/user2.jpg', hasNotification: true),
    User(name: 'Michael', image: 'assets/images/user3.jpg'),
    User(
        name: 'Sophia',
        image: 'assets/images/user4.jpg',
        hasNotification: true),
    User(name: 'William', image: 'assets/images/user5.jpg'),
    User(name: 'Olivia', image: 'assets/images/user6.jpg'),
  ];

  List<User> filteredUsers = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users
            .where((user) =>
                user.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Selection'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.image),
                  ),
                  title: Row(
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      if (user.hasNotification && !user.hasViewed)
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    user.hasViewed =
                        true; // Set hasViewed to true when entering the chat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(user: user),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final User user;

  ChatPage({required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> chatLog = [
    ChatMessage(message: 'Hello!', isUserMessage: false),
    ChatMessage(message: 'Welcome to the chat!', isUserMessage: false),
    ChatMessage(message: 'How can I assist you today?', isUserMessage: false),
  ];

  TextEditingController _textEditingController = TextEditingController();

  void _handleSubmitted(String message) async {
    _textEditingController.clear();
    setState(() {
      chatLog.add(ChatMessage(message: message, isUserMessage: true));
    });

    // Simulate a delayed response based on the length of the message
    int delayMilliseconds = message.length * 300;
    await Future.delayed(Duration(milliseconds: delayMilliseconds));

    String autoResponse = getAutoResponse(message);
    setState(() {
      chatLog.add(ChatMessage(message: autoResponse, isUserMessage: false));
    });
  }

  String getAutoResponse(String message) {
    // Add your auto-response logic here
    // This is just a simple example
    if (message.toLowerCase().contains('hi') ||
        message.toLowerCase().contains('hello')) {
      return 'Hi there!';
    } else if (message.toLowerCase().contains('how are you')) {
      return 'I am a chatbot, I do not have feelings!';
    } else {
      return 'I am sorry, I cannot understand that.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Chat with ${widget.user.name}'),
            Spacer(),
            CircleAvatar(
              backgroundImage: AssetImage(widget.user.image),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatLog.length,
              itemBuilder: (BuildContext context, int index) {
                final chatMessage = chatLog[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: Align(
                    alignment: chatMessage.isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: chatMessage.isUserMessage
                            ? Color(0xFF448F79).withOpacity(0.2)
                            : Color(0xFFC2D1A1).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        chatMessage.message,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Color(0xFFC2D1A1)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _handleSubmitted(_textEditingController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUserMessage;

  ChatMessage({required this.message, required this.isUserMessage});
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserSelectionPage(),
  ));
}
