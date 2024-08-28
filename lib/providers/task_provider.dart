import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = []; // รายการสำหรับเก็บ tasks ที่ยังไม่เสร็จ
  final List<Task> _completedTasks = []; // รายการสำหรับเก็บ tasks ที่เสร็จแล้ว
  final FirebaseFirestore db = FirebaseFirestore.instance; // สร้างตัวอย่างของ FirebaseFirestore

  List<Task> get tasks => _tasks; // รายการ tasks ที่ยังไม่เสร็จ
  List<Task> get completedTasks => _completedTasks; // รายการ tasks ที่เสร็จแล้ว
  
  Stream<List<Task>>? _tasksStream;
  Stream<List<Task>>? get tasksStream => _tasksStream;

  TaskProvider() {
    _initTasksStream();
  }

  void _initTasksStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _tasksStream = db
        .collection('userTasks')
        .doc(uid)
        .collection('tasksID')
        .snapshots()
        .map((snapshot) {
      _tasks.clear();
      _completedTasks.clear();
      return snapshot.docs.map((doc) {
        final task = Task.fromMap(doc.data());
        if (task.isCompleted) {
          _completedTasks.add(task);
        } else {
          _tasks.add(task);
        }
        return task;
      }).toList();
    });

    _tasksStream?.listen((_) {
      notifyListeners();
    });
  }

  // ฟังก์ชันสำหรับเพิ่มหรืออัปเดต task
  Future<void> addTask(Task task) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      _tasks.add(task);
      await db.collection('userTasks').doc(uid).collection('tasksID').doc(task.id).set(task.toMap()); // ใช้ uid
    } else {
      await updateTask(task);
    }
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับอัปเดต task ที่มีอยู่
  Future<void> updateTask(Task updatedTask) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
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
      await db.collection('userTasks').doc(uid).collection('tasksID').doc(updatedTask.id).update(updatedTask.toMap()); // ใช้ uid
      if (updatedTask.isCompleted) {
        markTaskAsCompleted(updatedTask);
      }
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      throw Exception('ไม่พบงาน: ${updatedTask.id}');
    }
  }

  // ฟังก์ชันสำหรับลบ task
  Future<void> removeTask(Task task) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    _tasks.remove(task);
    _completedTasks.remove(task);
    await db.collection('userTasks').doc(uid).collection('tasksID').doc(task.id).delete(); // ใช้ uid
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับอัปเดตตัวเลือกการแจ้งเตือน
  Future<void> setNotificationOption(String taskId, String newNotificationOption) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(notificationOption: newNotificationOption);
      _tasks[index] = updatedTask;
      await db.collection('userTasks').doc(uid).collection('tasksID').doc(taskId).update(updatedTask.toMap()); // ใช้ uid
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      throw Exception('ไม่พบงาน: $taskId');
    }
  }

  // ฟังก์ชันสำหรับทำเครื่องหมายว่า task เสร็จสมบูรณ์
  Future<void> markTaskAsCompleted(Task task) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    if (_tasks.remove(task)) {
      _completedTasks.add(task);
      await db.collection('userTasks').doc(uid).collection('tasksID').doc(task.id).update({'isCompleted': true}); // ใช้ uid
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับอัปเดตความก้าวหน้า (progress) ของ task
  Future<void> updateTaskProgress(int index, double newProgress) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // ตรวจสอบ uid
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = _tasks[index].copyWith(sliderValue: newProgress);
      await db.collection('userTasks').doc(uid).collection('tasksID').doc(_tasks[index].id).update({'sliderValue': newProgress}); // ใช้ uid
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับโหลด tasks จาก Firestore
  Future<void> loadTasks() async {
    _initTasksStream();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('No user logged in');
      return;
    }
    try {
      final taskCollection = db.collection('userTasks').doc(uid).collection('tasksID');
      final snapshot = await taskCollection.get();
      _tasks.clear();
      _completedTasks.clear();
      for (var doc in snapshot.docs) {
        final task = Task.fromMap(doc.data());
        if (task.isCompleted) {
          _completedTasks.add(task);
        } else {
          _tasks.add(task);
        }
      }
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }
}
