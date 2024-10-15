import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A widget that allows the user to select a start and end date and time for an event.
// It also includes a toggle for all-day events, which eliminates the need for time selection.
class DateTimeSelector extends StatefulWidget {
  final DateTime? startDate; // The start date selected by the user
  final TimeOfDay? startTime; // The start time selected by the user
  final DateTime? endDate; // The end date selected by the user
  final TimeOfDay? endTime; // The end time selected by the user
  final bool isAllDay; // Indicates if the event is all-day or not
  final ValueChanged<DateTime> onStartDateChanged; // Callback when the start date changes
  final ValueChanged<TimeOfDay> onStartTimeChanged; // Callback when the start time changes
  final ValueChanged<DateTime> onEndDateChanged; // Callback when the end date changes
  final ValueChanged<TimeOfDay> onEndTimeChanged; // Callback when the end time changes
  final ValueChanged<bool> onAllDayToggle; // Callback when the all-day toggle changes

  const DateTimeSelector({
    Key? key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAllDay,
    required this.onStartDateChanged,
    required this.onStartTimeChanged,
    required this.onEndDateChanged,
    required this.onEndTimeChanged,
    required this.onAllDayToggle,
  }) : super(key: key);

  @override
  DateTimeSelectorState createState() => DateTimeSelectorState();
}

class DateTimeSelectorState extends State<DateTimeSelector> {
  late DateTime? startDate; // Stores the current start date.
  late TimeOfDay? startTime; // Stores the current start time.
  late DateTime? endDate; // Stores the current end date.
  late TimeOfDay? endTime; // Stores the current end time.
  late bool isAllDay; // Stores whether the event is all-day or not.

  @override
  void initState() {
    super.initState();
    // Initialize state variables with widget properties.
    startDate = widget.startDate;
    startTime = widget.startTime;
    endDate = widget.endDate;
    endTime = widget.endTime;
    isAllDay = widget.isAllDay;
  }

  // Toggles the all-day setting and updates the parent widget.
  void toggleAllDay() {
    setState(() {
      // Toggle the value of isAllDay.
      isAllDay = !isAllDay;
    });
    // Notify parent of the change.
    widget.onAllDayToggle(isAllDay);
  }

  // Opens a date picker to select a date.
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      // Earliest selectable date.
      firstDate: DateTime.now(),
      // Latest selectable date.
      lastDate: DateTime(2100),
    );

    // Update the state with the selected date if not null.
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          // Update start date
          startDate = selectedDate;
          widget.onStartDateChanged(selectedDate);
        } else {
          // Update end date
          endDate = selectedDate;
          widget.onEndDateChanged(selectedDate);
        }
      });
    }
  }

  // Opens a time picker to select a time.
  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
    );

    // Update the state with the selected time if not null.
    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          // Update start time.
          startTime = selectedTime;
          widget.onStartTimeChanged(selectedTime);
        } else {
          endTime = selectedTime;
          // Update end time.
          widget.onEndTimeChanged(selectedTime);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Label for the all-day toggle.
              const Text(
                'All Day',
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(width: 35),
              GestureDetector(
                // Toggle all-day setting on tap.
                onTap: toggleAllDay,
                child: Container(
                  width: 65,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isAllDay ? const Color(0xFF717273) : const Color(0xFFd0d0d0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFFFFF)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: isAllDay ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 29,
                          height: 29,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFffffff),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // If it's not an all-day event.
          if (!isAllDay) ...[
            // Row to display the Start Date label and button, the time button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Start Date',
                  style: TextStyle(fontSize: 19),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: TextButton(
                          // Select start date on button press.
                          onPressed: () => selectDate(context, true),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            startDate == null
                              // Default text when no date selected
                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                              // Display selected start date.
                              : DateFormat('yyyy-MM-dd').format(startDate!),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 75,
                        height: 35,
                        child: TextButton(
                          // Select start time on button press.
                          onPressed: () => selectTime(context, true),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            // Default text when no time selected.
                            startTime == null ? 'Time' : startTime!.format(context),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row to display the End Date label and button, the time button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'End Date',
                  style: TextStyle(fontSize: 19),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: TextButton(
                          // Select end date on button press.
                          onPressed: () => selectDate(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            endDate == null
                              // Default text when no end date selected.
                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                              // Display selected end date.
                              : DateFormat('yyyy-MM-dd').format(endDate!),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 75,
                        height: 35,
                        child: TextButton(
                          // Select start time on button press.
                          onPressed: () => selectTime(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            // Default text when no time selected.
                            endTime == null ? 'Time' : endTime!.format(context),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          // If it's an all-day event, display only Start Date and End Date without time selection.
          ] else ...[
            // Row to display the Start Date label and button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Start Date',
                  style: TextStyle(fontSize: 19),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: TextButton(
                          // Select start date on button press.
                          onPressed: () => selectDate(context, true),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            startDate == null
                              // Default text when no date selected.
                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                              // Display selected start date.
                              : DateFormat('yyyy-MM-dd').format(startDate!),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 85),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row to display the End Date label and button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'End Date',
                  style: TextStyle(fontSize: 19),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: TextButton(
                          // Select end date on button press.
                          onPressed: () => selectDate(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            endDate == null
                              // Default text when no end date selected
                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                              // Display selected end date.
                              : DateFormat('yyyy-MM-dd').format(endDate!),
                            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 85),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
