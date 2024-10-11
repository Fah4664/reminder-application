import 'package:flutter/material.dart';

Color colorFromString(String colorString) {
  // ตรวจสอบให้แน่ใจว่าสตริงสีอยู่ในรูปแบบที่ถูกต้อง
  if (colorString.startsWith('#')) {
    colorString = colorString.substring(1); // ลบ # ออก
  }
  if (colorString.length == 6) {
    colorString = 'FF' + colorString; // เพิ่มค่า alpha ถ้าขาด
  } else if (colorString.length != 8) {
    throw FormatException('Invalid color format');
  }
  // แปลงสตริงสีเป็นตัวเลขฐาน 16
  try {
    return Color(int.parse(colorString, radix: 16));
  } catch (e) {
    throw FormatException('Invalid color value');
  }
}
