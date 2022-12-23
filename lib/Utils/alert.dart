import 'package:flutter/material.dart';

alert(context, title, msg, function, {no = 1}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          alertActionButton(
              title == 'Success'
                  ? 'OK'
                  : title == 'Confirm'
                      ? 'Yes'
                      : 'Close',
              function)
        ],
      );
    },
  );
}

alertActionButton(text, function) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
    child: MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      textColor: Colors.white,
      color: const Color(0xff132e72),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
      onPressed: function,
    ),
  );
}
