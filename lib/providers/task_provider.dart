import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

// TaskProvider class, which manages task-related operations.
class TaskProvider with ChangeNotifier {
  // List to store unfinished tasks.
  final List<Task> _tasks = [];
  // List to store completed tasks.
  final List<Task> _completedTasks = [];
  // Create an instance of Firestore.
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // Getter for unfinished tasks.
  List<Task> get tasks => _tasks; 
  // Getter for completed tasks.
  List<Task> get completedTasks => _completedTasks; 
  // Stream for real-time task updates.
  Stream<List<Task>>? _tasksStream;
  // Getter for the tasks stream.
  Stream<List<Task>>? get tasksStream => _tasksStream; 

  // Constructor that initializes the tasks stream
  TaskProvider() {
    _initTasksStream();
  }

  // Initialize the tasks stream to listen for changes in Firestore.
  void _initTasksStream() {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid; 
    // If no user is logged in, exit the function.
    if (uid == null) return; 

    // Create a stream to listen for task updates in Firestore.
    _tasksStream = db
      .collection('userTasks')
      .doc(uid)
      .collection('tasksID')
      .snapshots()
      .map((snapshot) {
      _tasks.clear(); // Clear the current list of tasks.
      _completedTasks.clear(); // Clear the list of completed tasks.
      return snapshot.docs.map((doc) {
        // Map each document in the snapshot to a Task.
        final task = Task.fromMap(
          doc.data()); // Convert Firestore document to Task object.
        if (task.isCompleted) {
          _completedTasks.add(task); // Add to completed tasks if it's completed.
        } else {
          _tasks.add(task); // Otherwise, add to unfinished tasks.
        }
        return task; // Return the Task object.
      }).toList(); // Convert the mapped tasks to a list.
    });
    // Notify listeners whenever a change occurs, prompting the UI to update.
    _tasksStream?.listen((_) {
      notifyListeners();
    });
  }

  // Function to add or update a task.
  Future<void> addTask(Task task) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // If no user is logged in, exit the function.
    // Check if the task already exists in the current task list by its ID.
    final index = _tasks.indexWhere((t) => t.id == task.id);
    // If the task doesn't exist, add it to the list and Firestore.
    if (index == -1) {
      // Add the task to the local task list.
      _tasks.add(task);
      // Add the new task to Firestore under the user's tasks collection.
      await db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .doc(task.id)
        .set(task.toMap()); // Save the task data as a map.
    } else {
      // If the task already exists, update it using the updateTask method.
      await updateTask(task);
    }
    // Notify any listeners that the task list has changed, so the UI can update.
    notifyListeners();
  }

  // Function to update an existing task.
  Future<void> updateTask(Task updatedTask) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // If no user is logged in, exit the function.
    if (uid == null) return;
    // Find the index of the task to be updated in the local task list.
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    // If the task exists in the local list, update its details.
    if (index != -1) {
      _tasks[index] = updatedTask.copyWith(
        title: updatedTask.title,
        description: updatedTask.description,
        isAllDay: updatedTask.isAllDay,
        startDateTime: updatedTask.startDateTime,
        endDateTime: updatedTask.endDateTime,
        color: updatedTask.color,
        sliderValue: updatedTask.sliderValue,
      );
      // Update the task in Firestore with the new data.
      await db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .doc(updatedTask.id)
        .update(updatedTask.toMap());
      // If the task is marked as completed, call the method to handle completion.
      if (updatedTask.isCompleted) {
        markTaskAsCompleted(updatedTask);
      }
      // Notify listeners to update the UI accordingly.
      notifyListeners();
    } else {
      // Throw an error if the task is not found in the local list.
      throw Exception(
        'Task not found: ${updatedTask.id}'); 
    }
  }

  // Function to remove a task.
  Future<void> removeTask(Task task) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // If no user is logged in, exit the function.
    if (uid == null) return;
    // Remove the task from the local list of active tasks.
    _tasks.remove(task);
    // Remove the task from the completed tasks list, if it's completed.
    _completedTasks.remove(task);
    // Delete the task from Firestore.
    await db
      .collection('userTasks')
      .doc(uid)
      .collection('tasksID')
      .doc(task.id)
      .delete(); // Delete the task document in Firestore.
    // Notify listeners that the tasks list has changed to update the UI.
    notifyListeners();
  }

  // Function to update the notification option for a task.
  Future<void> setNotificationOption(
    String taskId, String newNotificationOption) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // If no user is logged in, exit the function.
    if (uid == null) return;
    final index =
      _tasks.indexWhere((task) => task.id == taskId); // Find the task by ID.
    // If the task exists, update its notification option.
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(
        notificationOption: newNotificationOption); // Update notification option.
      // Update the task in local state.
      _tasks[index] = updatedTask;
      // Update the task in Firestore.
      await db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .doc(taskId)
        .update(updatedTask.toMap()); // Use the task's ID to update the document.
      // Notify listeners of changes.
      notifyListeners();
    } else {
      // Throw an error if the task is not found.
      throw Exception(
        'Task not found: $taskId');
    }
  }

  // Function to mark a task as completed.
  Future<void> markTaskAsCompleted(Task task) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // If no user is logged in, exit the function.
    if (uid == null) return;
    // Remove the task from unfinished tasks.
    if (_tasks.remove(task)) {
      _completedTasks.add(task); // Add it to completed tasks.
      // Update Firestore to mark the task as completed.
      await db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .doc(task.id)
        .update({'isCompleted': true}); // Update the task status in Firestore.
      // Notify listeners of changes.
      notifyListeners();
    }
  }

  // Function to unmark a task as completed.
  Future<void> unmarkTaskAsCompleted(Task task) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // Check if there is a logged-in user; if not, exit the function.
    if (uid == null) return;
    // Remove the task from the completed tasks list if it exists.
    if (_completedTasks.remove(task)) {
      // Add the task back to unfinished tasks.
      _tasks.add(task);
      // Update Firestore to unmark the task as completed.
      await db
        .collection('userTasks') 
        .doc(uid)
        .collection('tasksID')
        .doc(task.id)
        .update({'isCompleted': false}); // Change the isCompleted status to false.
      // Notify listeners that there has been a change in the tasks' status.
      notifyListeners();
    }
  }

  // Function to update the progress of a task.
  Future<void> updateTaskProgress(int index, double newProgress) async {
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // Check if there is a logged-in user; if not, exit the function.
    if (uid == null) return;
    // Ensure the provided index is within the valid range of tasks.
    if (index >= 0 && index < _tasks.length) {
      // Update the task's progress using the new progress value.
      _tasks[index] = _tasks[index]
        .copyWith(sliderValue: newProgress);
      // Update Firestore with the new progress value.
      await db
        .collection('userTasks') 
        .doc(uid)
        .collection('tasksID')
        .doc(_tasks[index].id) // Access the specific task by its ID.
        .update({'sliderValue': newProgress}); // Update the sliderValue in Firestore.
      // Notify listeners that there has been a change in the task's progress.
      notifyListeners();
    }
  }

  // Function to load tasks from Firestore.
  Future<void> loadTasks() async {
    // Initialize the tasks stream.
    _initTasksStream();
    // Get the UID of the currently logged-in user.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // Check if there is a logged-in user; if not, log a message and exit.
    if (uid == null) {
      'No user logged in';
      return;
    }
    try {
      // Reference to the user's task collection in Firestore.
      final taskCollection = db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID');
      // Retrieve the tasks from Firestore.
      final snapshot = await taskCollection.get(); 
      // Clear the current list of tasks.
      _tasks.clear();
      // Clear the list of completed tasks.
      _completedTasks.clear();
      // Iterate through the documents in the snapshot.
      for (var doc in snapshot.docs) {
        // Convert Firestore document to Task object.
        final task = Task.fromMap(
          doc.data());
        if (task.isCompleted) {
          // Add to completed tasks if it's completed.
          _completedTasks.add(task);
        } else {
          // Otherwise, add to unfinished tasks.
          _tasks.add(task);
        }
      }
      // Notify listeners of changes to the task list.
      notifyListeners();
    } catch (e) {
      // Log any errors encountered during loading.
      'Error loading tasks: $e';
    }
  }
}