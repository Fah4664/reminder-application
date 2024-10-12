// Import necessary packages for Flutter, Provider, and SVG handling
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'providers/task_provider.dart'; // Import TaskProvider for task management
import 'pages/edit_task_page.dart'; // Import the page for editing a task
import '../models/task.dart'; // Import the Task model
import '../utils/color_utils.dart'; // Utility for color manipulation
import '../utils/date_utils.dart'; // Utility for date formatting

// Function to show a popup with task details
void showTaskDetailsPopup(BuildContext context, Task task, int index) {
  // Determine the dialog color based on the task color, default to a light gray
  Color dialogColor = task.color != null
      ? colorFromString(
          task.color!) // Convert the color string to a Color object
      : const Color(0xFFede3e3); // Default color if no color is provided

  // Show a dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15.0), // Padding around content
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(5.0), // Rounded corners for the dialog
        ),
        backgroundColor:
            dialogColor, // Set background color to the determined dialog color // ใช้สีที่รับเข้ามาจาก Task
        content: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.8, // Set width to 80% of screen width
          height: MediaQuery.of(context).size.height *
              0.3, // Set height to 30% of screen height
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Allow the column to take minimum space
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the start
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between title and edit button
                children: [
                  Text(
                    task.title, // Display task title
                    style: const TextStyle(
                      fontSize: 22, // Font size for the title
                      fontWeight: FontWeight.bold, // Bold text
                      color: Color(
                          0xFF000000), // Black color for text // เปลี่ยนสีข้อความให้เหมาะสมกับพื้นหลัง
                    ),
                  ),
                  IconButton(
                    // Button to navigate to the edit task page // แสดงหน้าจอการแก้ไข task หรือทำการอัปเดต task ตรงนี้
                    icon: SvgPicture.asset(
                        'assets/icons/pencil.svg'), // Edit icon
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                              task:
                                  task), // Navigate to EditTaskPage with task data
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10), // Spacing below the title
              Text(
                task.description, // Display task description
                style: const TextStyle(
                  fontSize: 18, // Font size for description
                  color: Color(0xFF000000), // Black color for text
                ),
              ),
              const SizedBox(height: 10), // Spacing below the description
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Align progress bar to the start // จัดเรียงให้เริ่มจากซ้าย
                children: [
                  Container(
                    width: 200, // Fixed width for progress bar background
                    height: 15, // Fixed height for progress bar
                    decoration: BoxDecoration(
                      color: const Color(0xFFd0d0d0), // Light gray background
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Align(
                      alignment: Alignment
                          .centerLeft, // Align the progress indicator to the left
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 100) *
                            (task.sliderValue *
                                100 /
                                150), // Calculate the width of the progress based on slider value
                        height: 15, // Fixed height for progress indicator
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFF717273), // Dark gray for the progress bar
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width:
                          10), // Spacing between the progress bar and percentage text
                  Text(
                    '${(task.sliderValue * 100).toStringAsFixed(0)}%', // Display the percentage of task completion
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000)), // Text style for percentage
                  ),
                ],
              ),
              const SizedBox(height: 10), // Spacing below the progress bar
              Text(
                formatDateRange(task.startDateTime,
                    task.endDateTime), // Format and display the date range
                style: const TextStyle(
                    fontSize: 16, // Font size for date range
                    color: Color(0xFF000000)), // Black color for text
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color(0xFF000000)), // Back arrow icon
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              const Spacer(), // Add space between back button and action buttons
              TextButton(
                onPressed: () {
                  // Mark the task as completed
                  Provider.of<TaskProvider>(context, listen: false)
                      .markTaskAsCompleted(task);
                  Navigator.of(context).pop(); // Close dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF000000), // Color for button text
                  backgroundColor: Color.fromRGBO(
                      208, 208, 208, 0.8), // Light gray with transparency
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5.0), // Rounded corners for the button
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 0.5), // Padding for the button
                ),
                child: const Text('Mark as Completed'), // Button text
              ),
              const Spacer(), // Add space between action buttons
              IconButton(
                icon: SvgPicture.asset(
                    'assets/icons/trash-xmark.svg'), // Trash icon for deleting the task
                onPressed: () {
                  // Remove the task
                  Provider.of<TaskProvider>(context, listen: false)
                      .removeTask(task);
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
