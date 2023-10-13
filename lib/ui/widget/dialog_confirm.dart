import 'package:flutter/cupertino.dart';

class DialogConfim extends StatelessWidget{
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const DialogConfim({Key? key,required this.message,required this.onCancel, required this.onConfirm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Xác nhận'),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: onCancel,
          child: const Text('Hủy'),
        ),
        CupertinoDialogAction(
            onPressed: onConfirm,
            child: const Text('Xác nhận')
        )
      ],
    );
  }
}