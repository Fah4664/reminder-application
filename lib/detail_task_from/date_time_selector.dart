import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatefulWidget {
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;
  final bool isAllDay;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;
  final ValueChanged<bool> onAllDayToggle;

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
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  late DateTime? startDate;
  late TimeOfDay? startTime;
  late DateTime? endDate;
  late TimeOfDay? endTime;
  late bool isAllDay;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
    startTime = widget.startTime;
    endDate = widget.endDate;
    endTime = widget.endTime;
    isAllDay = widget.isAllDay;
  }

  void toggleAllDay() {
    setState(() {
      isAllDay = !isAllDay;
    });
    widget.onAllDayToggle(isAllDay);
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
          widget.onStartDateChanged(selectedDate);
        } else {
          endDate = selectedDate;
          widget.onEndDateChanged(selectedDate);
        }
      });
    }
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = selectedTime;
          widget.onStartTimeChanged(selectedTime);
        } else {
          endTime = selectedTime;
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
              const Text(
                'All Day',
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(width: 35),
              GestureDetector(
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
          if (!isAllDay) ...[
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
                                ? DateFormat('yyyy-MM-dd').format(DateTime.now())
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
                          onPressed: () => selectTime(context, true),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
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
                                ? DateFormat('yyyy-MM-dd').format(DateTime.now())
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
                          onPressed: () => selectTime(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1.0),
                            backgroundColor: const Color(0xFFd0d0d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
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
          ] else ...[
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
                                ? DateFormat('yyyy-MM-dd').format(DateTime.now())
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
                                ? DateFormat('yyyy-MM-dd').format(DateTime.now())
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
