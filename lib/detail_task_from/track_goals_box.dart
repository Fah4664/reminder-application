import 'package:flutter/material.dart';

// Widget for tracking progress towards goals using a slider.
class TrackGoals extends StatefulWidget {
  // Receives the initial progress (0-1) and a function to notify progress changes.
  // รับค่าความก้าวหน้า (progress) และฟังก์ชันที่ใช้ในการแจ้งการเปลี่ยนแปลงของความก้าวหน้า
  final double progress;
  final ValueChanged<double> onProgressUpdated;

  // Constructor for TrackGoals
  // คอนสตรัคเตอร์ของ TrackGoals
  const TrackGoals({
    super.key,
    required this.progress, // Set the initial progress value
    required this.onProgressUpdated, // Set the function to notify progress changes
  });

  @override
  TrackGoalsState createState() => TrackGoalsState();
}

class TrackGoalsState extends State<TrackGoals> {
  late double sliderValue; // Variable to hold the value of the slider

  @override
  void initState() {
    super.initState();
    sliderValue =
        widget.progress * 100.0; // Convert the progress to a percentage
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
        color: Colors.white, // Background color of the container
        borderRadius:
            BorderRadius.circular(15.0), // Rounded corners for the container
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.2), // Shadow color for the container
            blurRadius: 5.0, // Blur radius for the shadow
            offset: const Offset(0, 2), // Position of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        children: <Widget>[
          const Text(
            'Track Goals', // Title of the widget
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 5), // Space between the title and the slider
          Row(
            children: <Widget>[
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(
                        0xFF717273), // Color of the active slider track
                    inactiveTrackColor: const Color(
                        0xFFd0d0d0), // Color of the inactive slider track
                    thumbColor:
                        const Color(0xFF4c4949), // Color of the slider thumb
                    overlayColor: const Color(0xFFd0d0d0).withAlpha(
                        30), // Overlay color when the thumb is pressed
                    trackHeight: 10.0, // Height of the slider track
                  ),
                  child: Slider(
                    value: sliderValue, // Current value of the slider
                    min: 0.0, // Minimum value of the slider
                    max: 100.0, // Maximum value of the slider
                    divisions: 100, // Divide the slider into 100 parts
                    onChanged: (double value) {
                      // Callback when the slider value changes
                      setState(() {
                        sliderValue = value; // Update the slider value
                        widget.onProgressUpdated(value /
                            100.0); // Notify the parent of the progress update
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      10), // Space between the slider and the percentage text
              Text(
                '${sliderValue.toStringAsFixed(0)}%', // Display the percentage without decimal points
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
