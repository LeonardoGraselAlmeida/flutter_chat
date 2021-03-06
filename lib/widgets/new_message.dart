import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    try {
      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      await FirebaseFirestore.instance.collection('chat').add({
        'text': _enteredMessage,
        'createAt': Timestamp.now(),
        'userId': user.uid,
        'userName': userData.get('name'),
        'imageUrl': userData.get('imageUrl'),
      });
      _controller.clear();
    } on FirebaseException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enviar mensagem...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
