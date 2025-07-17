import 'package:flutter/material.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';

class ModuleTitle extends StatelessWidget {
  const ModuleTitle({super.key, required this.title, this.callback, this.type});

  final String title;
  final Function()? callback;
  final bool? type;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                      title,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: !(type ?? false) ? Colors.white : null)
                  )
                ),
                if (callback != null) GestureDetector(
                    onTap: callback,
                    child: Row(
                        children: [
                          Text('Посмотреть все', style: TextStyle(color: Colors.blue)),
                          w(12),
                          Image.asset('assets/icon/right.png')
                        ]
                    )
                )
              ]
          ),
          h(4),
          Divider(color: Color(!(type ?? false) ? 0xFF2F2F2F : 0xFFDDE8EA)),
          h(8)
        ]
    );
  }
}