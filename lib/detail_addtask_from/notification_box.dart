import 'package:flutter/material.dart';

// Widget for Notification that allows users to select notification options.
class Notification extends StatefulWidget {
  // The currently selected notification option, can be null.
  final String? notificationOption;
  // Callback function that is called when a notification option is selected.
  final Function(String) onOptionSelected;

  const Notification({
    super.key,
    this.notificationOption,
    required this.onOptionSelected,
  });

  @override
  NotificationState createState() => NotificationState();
}

// State for Notification to manage the selected notification option.
class NotificationState extends State<Notification> {
  // These options represent various timing options for notifications.
  final List<String> _options = [
    'None',
    'At time of event',
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
    '2 days before',
    '1 week before',
  ];

  // Variable to hold the selected option in the dialog.
  // This variable tracks the currently selected option within the dialog.
  String? _selectedOptionInDialog;

  @override
  void initState() {
    super.initState();
    // Defaults to 'None' if no option is specified.
    _selectedOptionInDialog = widget.notificationOption ?? 'None';
  }

  // Function to show a popup dialog when the Notification is tapped.
  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: const Color(0xFFd0d0d0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((option) {
              final isSelected = option == _selectedOptionInDialog;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFf2f2f2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      // Update selected option
                      setState(() {
                        _selectedOptionInDialog = option;
                      });
                      // Call function when an option is selected
                      // Notify parent about the selected option
                      widget.onOptionSelected(option);
                      // Close the dialog
                      Navigator.of(context).pop(); 
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the UI for Notification.
    return GestureDetector(
      onTap: _showOptionsDialog,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: const Color(0xFFffffff),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showOptionsDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFd0d0d0), width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      // Display the selected option or 'None'
                      _selectedOptionInDialog ?? 'None',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF717273).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
