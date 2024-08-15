import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _activeTasks = []; // รายการสำหรับเก็บ tasks ที่ยังไม่เสร็จ
  final List<Task> _completedTasks = []; // รายการสำหรับเก็บ tasks ที่เสร็จแล้ว
  List<Task> get tasks => _activeTasks; // รายการ tasks ที่ยังไม่เสร็จ
  List<Task> get completedTasks => _completedTasks; // รายการ tasks ที่เสร็จแล้ว

  // ฟังก์ชันสำหรับเพิ่มหรืออัปเดต task
  void addTask(Task task) {
    final index = _activeTasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      // ถ้า task ยังไม่มีในรายการ ให้เพิ่ม task ใหม่
      _activeTasks.add(task);
    } else {
      // ถ้า task มีอยู่แล้วในรายการ ให้ทำการอัปเดต task ที่มีอยู่
      updateTask(task); // ใช้ฟังก์ชัน updateTask แทน
    }
    saveAllTasks(); // บันทึกการเปลี่ยนแปลง
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับอัปเดต task ที่มีอยู่
  void updateTask(Task updatedTask) {
    final index = _activeTasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _activeTasks[index] = updatedTask.copyWith(
        title: updatedTask.title,
        description: updatedTask.description,
        isAllDay: updatedTask.isAllDay,
        startDateTime: updatedTask.startDateTime,
        endDateTime: updatedTask.endDateTime,
        color: updatedTask.color,
        goalProgress: updatedTask.goalProgress,
      );
      // ถ้า task ถูกทำเครื่องหมายว่าเสร็จสมบูรณ์ให้ย้ายไปที่ _completedTasks
      if (updatedTask.isCompleted) {
        markTaskAsCompleted(updatedTask);
      }
      saveAllTasks(); // บันทึกการเปลี่ยนแปลง
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    } else {
      // จัดการกรณีที่ไม่พบ task
      throw Exception('ไม่พบงาน: ${updatedTask.id}');
    }
  }

  // ฟังก์ชันสำหรับลบ task ออกจากทั้ง _activeTasks และ _completedTasks
  void removeTask(Task task) {
    _activeTasks.remove(task);
    _completedTasks.remove(task);
    saveAllTasks(); // บันทึกการเปลี่ยนแปลง
    notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับทำเครื่องหมายว่า task เสร็จสมบูรณ์
  void markTaskAsCompleted(Task task) {
    if (_activeTasks.remove(task)) {
      _completedTasks.add(task);
      saveAllTasks(); // บันทึกการเปลี่ยนแปลง
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับอัปเดตความก้าวหน้า (progress) ของ task
  void updateTaskProgress(int index, double newProgress) {
    if (index >= 0 && index < _activeTasks.length) {
      _activeTasks[index] = _activeTasks[index].copyWith(goalProgress: newProgress);
      saveAllTasks(); // บันทึกการเปลี่ยนแปลง
      notifyListeners(); // แจ้งให้ผู้ฟังทราบว่ามีการเปลี่ยนแปลง
    }
  }

  // ฟังก์ชันสำหรับบันทึก tasks ลงในที่เก็บข้อมูล
  void saveAllTasks() {
    // เพิ่มตรรกะสำหรับการเก็บ tasks (เช่น shared preferences, local storage หรือฐานข้อมูล)
  }
}
