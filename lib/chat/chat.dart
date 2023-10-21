enum ChatType { user, bot }

class ChatInput {
  final String text;
  final ChatType type;
  bool isDone;
  ChatInput({required this.text, required this.type, this.isDone = false});
}
