import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = []; // รายการสำหรับเก็บ tasks ที่ยังไม่เสร็จ
  final List<Task> _completedTasks = []; // รายการสำหรับเก็บ tasks ที่เสร็จแล้ว
  final FirebaseFirestore db = FirebaseFirestore.instance; // สร้างตัวอย่างของ FirebaseFirestore

  List<Task> get tasks => _tasks; // รายการ tasks ที่ยังไม่เสร็จ
  List<Task> get completedTasks => _completedTasks; // รายการ tasks ที่เสร็จแล้ว

  // ฟังก์ชันสำหรับเพิ่มหรืออัปเดต task
  void addTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      // ถ้า task ยังไม่มีในรายการ ให้เพิ่ม task ใหม่
      _tasks.add(task);
      db.collection('tasks').doc(task.id).set(task.toMap()); // บันทึก task ลงใน Firestore
    } else {
      // ถ้า task มีอยู่แล้วในรายการ ให้ทำการอัปเดต task ที่มีอยู่
      updateTask(task);
    }
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับอัปเดต task ที่มีอยู่
  void updateTask(Task updatedTask) {
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
      // อัปเดต task ใน Firestore
      db.collection('tasks').doc(updatedTask.id).update(updatedTask.toMap());
      // ถ้า task ถูกทำเครื่องหมายว่าเสร็จสมบูรณ์ให้ย้ายไปที่ _completedTasks
      if (updatedTask.isCompleted) {
        markTaskAsCompleted(updatedTask);
      }
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      // จัดการกรณีที่ไม่พบ task
      throw Exception('ไม่พบงาน: ${updatedTask.id}');
    }
  }

  // ฟังก์ชันสำหรับลบ task ออกจากทั้ง _activeTasks และ _completedTasks
  void removeTask(Task task) {
    _tasks.remove(task);
    _completedTasks.remove(task);
    db.collection('tasks').doc(task.id).delete(); // ลบ task จาก Firestore
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับอัปเดตตัวเลือกการแจ้งเตือน
  void setNotificationOption(String taskId, String newNotificationOption) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(notificationOption: newNotificationOption);
      _tasks[index] = updatedTask;
      db.collection('tasks').doc(taskId).update(updatedTask.toMap()); // อัปเดต Firestore
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      throw Exception('ไม่พบงาน: $taskId');
    }
  }

  // ฟังก์ชันสำหรับทำเครื่องหมายว่า task เสร็จสมบูรณ์
  void markTaskAsCompleted(Task task) {
    if (_tasks.remove(task)) {
      _completedTasks.add(task);
      db.collection('tasks').doc(task.id).update({'isCompleted': true}); // อัปเดต Firestore
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับอัปเดตความก้าวหน้า (progress) ของ task
  void updateTaskProgress(int index, double newProgress) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = _tasks[index].copyWith(sliderValue: newProgress);
      db.collection('tasks').doc(_tasks[index].id).update({'sliderValue': newProgress}); // อัปเดต Firestore
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับโหลด tasks จาก Firestore
  void loadTasks() {
    db.collection('tasks').snapshots().listen((snapshot) {
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
      notifyListeners(); // Notify listeners to refresh UI
    });
  }

}
