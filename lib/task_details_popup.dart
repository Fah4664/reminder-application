import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'providers/task_provider.dart';
import 'pages/edit_task_page.dart';
import '../models/task.dart';
import 'utils/color_utils.dart';
import 'utils/date_utils.dart';

// Function to show a popup with task details.
void showTaskDetailsPopup(BuildContext context, Task task, int index) {
  // Determine the dialog color based on the task color, default to a light gray.
  Color dialogColor = task.color != null
    ? colorFromString(task.color!) // Convert the color string to a Color object.
    : const Color(0xFFede3e3); // Default color if no color is provided.

  // Show a dialog.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Adjust button text based on task completion status.
      String buttonText = task.isCompleted ? 'Unmark as Completed' : 'Mark as Completed';

      return AlertDialog(
        contentPadding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(5.0),
        ),
        backgroundColor: dialogColor, // Set background color to the determined dialog color.
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of screen width.
          height: MediaQuery.of(context).size.height * 0.3, // Set height to 30% of screen height.
          child: Column(
            mainAxisSize: MainAxisSize.min, // Allow the column to take minimum space.
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start.
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and edit button.
                children: [
                  Text(
                    task.title, // Display task title.
                    style: const TextStyle(
                      fontSize: 22, // Font size for the title.
                      fontWeight: FontWeight.bold, // Bold text.
                      color: Color(0xFF000000), // Black color for text.
                    ),
                  ),
                  IconButton(
                    // Button to navigate to the edit task page.
                    icon: SvgPicture.asset(
                      'assets/icons/pencil.svg'), // Edit icon.
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(task: task), // Navigate to EditTaskPage with task data.
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10), 
              Text(
                task.description, // Display task description.
                style: const TextStyle(
                  fontSize: 18, 
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 10), 
              Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  Container(
                    width: 200, 
                    height: 15, 
                    decoration: BoxDecoration(
                      color: const Color(0xFFd0d0d0), 
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft, 
                      child: Container(
                        // Calculate the width of the progress based on slider value.
                        width: (MediaQuery.of(context).size.width - 100) * (task.sliderValue * 100 / 150),
                        height: 15,
                        decoration: BoxDecoration(
                          color: const Color(0xFF717273), 
                          borderRadius: BorderRadius.circular(15.0), 
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:10),
                  // Display the percentage of task completion.
                  Text('${(task.sliderValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF000000)), 
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Format and display the date range.
              Text(formatDateRange(task.startDateTime,task.endDateTime),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                  color: Color(0xFF000000)), 
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog.
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Toggle completion status.
                  if (task.isCompleted) {
                    Provider.of<TaskProvider>(context, listen: false)
                      .unmarkTaskAsCompleted(task);
                  } else {
                    Provider.of<TaskProvider>(context, listen: false)
                      .markTaskAsCompleted(task);
                  }
                  Navigator.of(context).pop(); // Close dialog.
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF000000), 
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0, vertical: 0.5),
                ),
                child: Text(buttonText), 
              ),
              const Spacer(),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/trash-xmark.svg'), // Trash icon for deleting the task.
                onPressed: () {
                  // Remove the task.
                  Provider.of<TaskProvider>(context, listen: false)
                    .removeTask(task);
                  Navigator.of(context).pop(); // Close dialog.
                },
              ),
            ],
          )
        ],
      );
    },
  );
}