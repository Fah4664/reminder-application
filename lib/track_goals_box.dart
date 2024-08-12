import 'package:flutter/material.dart';

class TrackGoals extends StatefulWidget {
  const TrackGoals({Key? key}) : super(key: key);

  @override
  _TrackGoalsState createState() => _TrackGoalsState();
}

class _TrackGoalsState extends State<TrackGoals> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,  // ระยะห่างด้านซ้าย
        right: 20.0, // ระยะห่างด้านขวา
        top: 15.0,   // ระยะห่างด้านบน
        bottom: 2.0 // ระยะห่างด้านล่าง
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Track Goals',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 1), // เพิ่มระยะห่างระหว่างหัวข้อกับแถบเลื่อน
          Row(
            children: <Widget>[
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF717273),
                    inactiveTrackColor: const Color(0xFFd0d0d0),
                    thumbColor: const Color(0xFF4c4949),
                    overlayColor: const Color(0xFFd0d0d0).withAlpha(30),
                    trackHeight: 10.0, // ปรับความสูงของแถบเลื่อน
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 0.0,
                    max: 100.0,
                    divisions: 100,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10), // เพิ่มระยะห่างระหว่างแถบเลื่อนกับตัวเลข %
              Text(
                '${_sliderValue.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
