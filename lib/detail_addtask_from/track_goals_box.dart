import 'package:flutter/material.dart';

// Widget for tracking progress towards goals using a slider.
class TrackGoals extends StatefulWidget {
  // Receives the initial progress (0-1) and a function to notify progress changes.
  final double progress;
  final ValueChanged<double> onProgressUpdated;
  // Constructor for TrackGoals.
  const TrackGoals({
    super.key,
    // Set the initial progress value.
    required this.progress,
    // Set the function to notify progress changes.
    required this.onProgressUpdated,
  });

  @override
  TrackGoalsState createState() => TrackGoalsState();
}

class TrackGoalsState extends State<TrackGoals> {
  // Variable to hold the value of the slider.
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    // Convert the progress to a percentage (0-100) for the slider.
    sliderValue = widget.progress * 100.0;
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
        borderRadius:
          BorderRadius.circular(15.0),
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
          // Title of the widget.
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
                    thumbColor:const Color(0xFF4c4949),
                    overlayColor: const Color(0xFFd0d0d0).withAlpha(30),
                    trackHeight: 10.0,
                  ),
                  child: Slider(
                    value: sliderValue, // Current value of the slider.
                    min: 0.0, // Minimum value of the slider.
                    max: 100.0, // Maximum value of the slider.
                    divisions: 100, // Divide the slider into 100 parts.
                    onChanged: (double value) {
                      // Callback when the slider value changes.
                      setState(() {
                        // Update the slider value and notify the parent of the progress update.
                        sliderValue = value;
                        // Convert back to a percentage (0.0-1.0) before notifying.
                        widget.onProgressUpdated(value / 100.0);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Display the percentage without decimal points.
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
