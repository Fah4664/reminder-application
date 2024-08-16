import 'package:flutter/material.dart';

class TrackGoals extends StatefulWidget {
  // รับค่าความก้าวหน้า (progress) และฟังก์ชันที่ใช้ในการแจ้งการเปลี่ยนแปลงของความก้าวหน้า
  final double progress;
  final ValueChanged<double> onProgressUpdated;

  // คอนสตรัคเตอร์ของ TrackGoals
  const TrackGoals({
    super.key,
    required this.progress,
    required this.onProgressUpdated,
  });
  
  @override
  TrackGoalsState createState() => TrackGoalsState();
}

class TrackGoalsState extends State<TrackGoals> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.progress * 100.0; // Convert to percentage
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 15.0,
        bottom: 2.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Track Goals',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF717273),
                    inactiveTrackColor: const Color(0xFFd0d0d0),
                    thumbColor: const Color(0xFF4c4949),
                    overlayColor: const Color(0xFFd0d0d0).withAlpha(30),
                    trackHeight: 10.0,
                  ),
                  child: Slider(
                    value: sliderValue,
                    min: 0.0,
                    max: 100.0,
                    divisions: 100,
                    onChanged: (double value) {
                      setState(() {
                        sliderValue = value;
                        widget.onProgressUpdated(value / 100.0); // Notify parent of progress update
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${sliderValue.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
