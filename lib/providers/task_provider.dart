import 'package:flutter/material.dart'; // Import the Flutter Material package
import '../models/task.dart'; // Import the Task model
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication package

// TaskProvider class, which manages task-related operations
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks =
      []; // List to store unfinished tasks // รายการสำหรับเก็บ tasks ที่ยังไม่เสร็จ
  final List<Task> _completedTasks =
      []; // List to store completed tasks // รายการสำหรับเก็บ tasks ที่เสร็จแล้ว
  final FirebaseFirestore db = FirebaseFirestore
      .instance; // Create an instance of Firestore // สร้างตัวอย่างของ FirebaseFirestore

  List<Task> get tasks =>
      _tasks; // Getter for unfinished tasks // รายการ tasks ที่ยังไม่เสร็จ
  List<Task> get completedTasks =>
      _completedTasks; // Getter for completed tasks

  Stream<List<Task>>? _tasksStream; // Stream for real-time task updates
  Stream<List<Task>>? get tasksStream =>
      _tasksStream; // Getter for the tasks stream // รายการ tasks ที่เสร็จแล้ว

  // Constructor that initializes the tasks stream
  TaskProvider() {
    _initTasksStream();
  }

  // Initialize the tasks stream to listen for changes in Firestore
  void _initTasksStream() {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function

    // Create a stream to listen for task updates in Firestore
    _tasksStream = db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .snapshots() // Listen for snapshot updates
        .map((snapshot) {
      _tasks.clear(); // Clear the current list of tasks
      _completedTasks.clear(); // Clear the list of completed tasks
      return snapshot.docs.map((doc) {
        // Map each document in the snapshot to a Task
        final task = Task.fromMap(
            doc.data()); // Convert Firestore document to Task object
        if (task.isCompleted) {
          _completedTasks.add(task); // Add to completed tasks if it's completed
        } else {
          _tasks.add(task); // Otherwise, add to unfinished tasks
        }
        return task; // Return the Task object
      }).toList(); // Convert the mapped tasks to a list
    });

    // Listen for changes and notify listeners to update UI
    _tasksStream?.listen((_) {
      notifyListeners();
    });
  }

  // Function to add or update a task
  Future<void> addTask(Task task) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    final index = _tasks
        .indexWhere((t) => t.id == task.id); // Check if task already exists
    if (index == -1) {
      // If the task doesn't exist, add it
      _tasks.add(task);
      // Add the task to Firestore
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(task.id)
          .set(task.toMap()); // Use user ID
    } else {
      // If the task exists, update it
      await updateTask(task);
    }
    notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // Function to update an existing task  // ฟังก์ชันสำหรับอัปเดต task ที่มีอยู่
  Future<void> updateTask(Task updatedTask) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    final index = _tasks
        .indexWhere((task) => task.id == updatedTask.id); // Find task index
    if (index != -1) {
      // If the task exists, update it
      _tasks[index] = updatedTask.copyWith(
        title: updatedTask.title,
        description: updatedTask.description,
        isAllDay: updatedTask.isAllDay,
        startDateTime: updatedTask.startDateTime,
        endDateTime: updatedTask.endDateTime,
        color: updatedTask.color,
        sliderValue: updatedTask.sliderValue,
      );
      // Update the task in Firestore
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(updatedTask.id)
          .update(updatedTask.toMap()); // Use user ID
      if (updatedTask.isCompleted) {
        markTaskAsCompleted(
            updatedTask); // Mark the task as completed if applicable
      }
      notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      throw Exception(
          'Task not found: ${updatedTask.id}'); // Throw an error if task is not found
    }
  }

  // Function to remove a task // ฟังก์ชันสำหรับลบ task
  Future<void> removeTask(Task task) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    _tasks.remove(task); // Remove the task from the local list
    _completedTasks.remove(task); // Remove from completed tasks if necessary
    // Delete the task from Firestore
    await db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .doc(task.id)
        .delete(); // Use user ID
    notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // Function to update the notification option for a task // ฟังก์ชันสำหรับอัปเดตตัวเลือกการแจ้งเตือน
  Future<void> setNotificationOption(
      String taskId, String newNotificationOption) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    final index =
        _tasks.indexWhere((task) => task.id == taskId); // Find the task by ID
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(
          notificationOption:
              newNotificationOption); // Update notification option
      _tasks[index] = updatedTask; // Update the task in local state
      // Update the task in Firestore
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(taskId)
          .update(updatedTask.toMap()); // Use user ID
      notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      throw Exception(
          'Task not found: $taskId'); // Throw an error if task is not found
    }
  }

  // Function to mark a task as completed // ฟังก์ชันสำหรับทำเครื่องหมายว่า task เสร็จสมบูรณ์
  Future<void> markTaskAsCompleted(Task task) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    if (_tasks.remove(task)) {
      // Remove the task from unfinished tasks
      _completedTasks.add(task); // Add it to completed tasks
      // Update Firestore to mark the task as completed
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(task.id)
          .update({'isCompleted': true}); // Use user ID
      notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  Future<void> unmarkTaskAsCompleted(Task task) async {
    final uid = FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function

    // Remove the task from completed tasks
    if (_completedTasks.remove(task)) {
      _tasks.add(task); // Add it back to unfinished tasks
      // Update Firestore to unmark the task as completed
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(task.id)
          .update({'isCompleted': false}); // Use user ID
      notifyListeners(); // Notify listeners of changes
    }
  }

  // Function to update the progress of a task   // ฟังก์ชันสำหรับอัปเดตความก้าวหน้า (progress) ของ task
  Future<void> updateTaskProgress(int index, double newProgress) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) return; // If no user is logged in, exit the function
    if (index >= 0 && index < _tasks.length) {
      // Ensure index is within bounds
      _tasks[index] = _tasks[index]
          .copyWith(sliderValue: newProgress); // Update the task's progress
      // Update Firestore with the new progress value
      await db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID')
          .doc(_tasks[index].id)
          .update({'sliderValue': newProgress}); // Use user ID
      notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

// ฟังก์ชันสำหรับโหลด tasks จาก Firestore
  // Function to load tasks from Firestore
  Future<void> loadTasks() async {
    _initTasksStream(); // Initialize the tasks stream
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
    if (uid == null) {
      print('No user logged in'); // Log a message if no user is logged in
      return;
    }
    try {
      final taskCollection = db
          .collection('userTasks')
          .doc(uid)
          .collection('tasksID'); // Reference to the user's task collection
      final snapshot = await taskCollection.get(); // Get tasks from Firestore
      _tasks.clear(); // Clear the current list of tasks
      _completedTasks.clear(); // Clear the list of completed tasks
      for (var doc in snapshot.docs) {
        // Iterate through the documents in the snapshot
        final task = Task.fromMap(
            doc.data()); // Convert Firestore document to Task object
        if (task.isCompleted) {
          _completedTasks.add(task); // Add to completed tasks if it's completed
        } else {
          _tasks.add(task); // Otherwise, add to unfinished tasks
        }
      }
      notifyListeners(); // Notify listeners of changes // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } catch (e) {
      print(
          'Error loading tasks: $e'); // Log any errors encountered during loading
    }
  }
}
