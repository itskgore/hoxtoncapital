import 'package:flutter/material.dart';

class CircularCheckBox extends StatefulWidget {
  final bool value;
  ValueChanged<bool>? onChanged;

  CircularCheckBox({super.key, required this.value, this.onChanged});

  @override
  _CircularCheckBoxState createState() => _CircularCheckBoxState();
}

class _CircularCheckBoxState extends State<CircularCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(!widget.value);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(right: 5, top: 2),
        child: widget.value
            ? const Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.green,
              )
            : const Icon(
                Icons.circle_outlined,
                size: 18,
                color: Colors.grey,
              ),
      ),
    );
  }
}
