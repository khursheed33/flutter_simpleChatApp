import 'package:flutter/material.dart';

class BubbleMessage extends StatelessWidget {
  BubbleMessage(
      {this.message, this.isMe, this.key, this.userName, this.imageUrl});
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String imageUrl;

  Widget buildProfilePicture(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
          color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorDark,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.45,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  topLeft: Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Name
                  Padding(
                    padding: isMe
                        ? const EdgeInsets.only(right: 25)
                        : const EdgeInsets.only(left: 25),
                    child: Text(
                      "~ $userName",
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe
                            ? Colors.grey[700]
                            : Theme.of(context).canvasColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  // Message
                  Padding(
                    padding: isMe
                        ? const EdgeInsets.only(right: 20)
                        : const EdgeInsets.only(left: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: isMe
                            ? Colors.grey[900]
                            : Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isMe)
          Positioned(
            top: 2.5,
            right: 4,
            child: Container(
              alignment: Alignment.center,
              child: buildProfilePicture(context),
            ),
          ),
        if (!isMe)
          Positioned(
            top: 2,
            left: 4,
            child: Container(
              alignment: Alignment.center,
              child: buildProfilePicture(context),
            ),
          ),
      ],
    );
  }
}
