import 'package:flutter/material.dart';

Color colorFromString(String s) {
  // ตรวจสอบสตริงสีว่ามี # หรือไม่
  if (s.startsWith('#')) {
    s = s.substring(1); // ลบ # ออก
  }
  
  // ตรวจสอบว่ามี 6 ตัวอักษร (RRGGBB) หรือไม่
  if (s.length == 6) {
    s = 'FF$s'; // เพิ่ม FF สำหรับความโปร่งใสเต็มที่
  }
  
  // แปลงสตริงเป็นตัวเลขฐาน 16
  return Color(int.parse(s, radix: 16));
}
