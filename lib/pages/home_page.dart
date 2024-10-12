import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
import '../task_details_popup.dart';
import '../utils/date_utils.dart';
import '../utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

// หน้าหลักของแอปที่มีการแสดงรายการงาน / HomePage that displays the list of tasks
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // โหลดรายการงานทั้งหมดเมื่อหน้าถูกสร้างขึ้น / Load all tasks when the page is initialized
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFFFFFFF), // กำหนดพื้นหลังเป็นสีขาว / Set background to white
      appBar: AppBar(
        title: const Center(
            child: Text(
                'Track Goals')), // ชื่อแอปที่แสดงในแถบด้านบน / App title shown in the top bar
        actions: [
          IconButton(
              icon: const Icon(Icons.logout), // ปุ่ม log out / Log out button
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .signOut(); // ออกจากระบบ / Sign out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()), // นำทางไปหน้า Login / Navigate to LoginPage
                  );
                } catch (e) {
                  // แสดงข้อความแจ้งข้อผิดพลาดหากการออกจากระบบล้มเหลว / Show error message if sign-out fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }),
        ],
      ),
      // ใช้ StreamBuilder ในการฟังการเปลี่ยนแปลงของข้อมูลจาก TaskProvider / Use StreamBuilder to listen for task changes
      body: StreamBuilder<List<Task>>(
        stream: Provider.of<TaskProvider>(context).tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // แสดงตัวหมุนเมื่อข้อมูลกำลังโหลด / Show loading spinner when data is being fetched
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // แสดงข้อความข้อผิดพลาด / Show error message
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'No tasks added yet.')); // แสดงข้อความเมื่อไม่มีงานใดๆ / Show message when no tasks are available
          }

          // ดึงรายการงานที่ยังไม่เสร็จสิ้น / Filter and show only incomplete tasks
          final tasks =
              snapshot.data!.where((task) => !task.isCompleted).toList();
          return ListView.builder(
            itemCount:
                tasks.length, // จำนวนงานที่จะแสดง / Number of tasks to display
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 4,
                color: task.color != null
                    ? colorFromString(task
                        .color!) // กำหนดสีการ์ดตามงาน / Set card color based on task
                    : const Color(0xFFede3e3),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // แสดงชื่อของงาน / Display task title
                      Text(
                        task.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      // แสดงช่วงเวลาของงาน / Display task date range
                      Text(
                        formatDateRange(task.startDateTime, task.endDateTime),
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF000000)),
                      ),
                      const SizedBox(height: 5),
                      // แถบแสดงความคืบหน้าของงาน / Task progress bar
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
                            // ความยาวแถบคืบหน้าขึ้นกับ `sliderValue` / Progress bar width based on `sliderValue`
                            width: (MediaQuery.of(context).size.width - 100) *
                                (task.sliderValue * 100 / 150),
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF717273),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // เมื่อกดที่การ์ดจะแสดง popup รายละเอียดของงาน / Show task details popup when tapped
                    showTaskDetailsPopup(context, task, index);
                  },
                ),
              );
            },
          );
        },
      ),
      // แถบปุ่มนำทางด้านล่าง / Bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 48),
            IconButton(
              icon: Image.asset(
                'assets/icons/target.png',
                height: 27,
                width: 27,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomePage()), // กลับไปที่หน้า Home / Return to HomePage
                );
              },
            ),
            const Spacer(),
            IconButton(
                icon: Image.asset(
                  'assets/icons/Add Task.png',
                  height: 29,
                  width: 29,
                ),
                onPressed: () async {
                  final taskProvider =
                      Provider.of<TaskProvider>(context, listen: false);
                  // เปิดหน้าเพิ่มงาน (AddTaskPage) และรับค่ากลับเป็นงานใหม่ / Open AddTaskPage and receive a new task
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaskPage()),
                  );
                  if (newTask != null) {
                    taskProvider.addTask(
                        newTask); // เพิ่มงานใหม่ในรายการ / Add the new task to the list
                  }
                }),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SearchPage()), // เปิดหน้าค้นหา / Open SearchPage
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/View Tasks.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ViewTasksPage()), // เปิดหน้าแสดงงานที่เสร็จแล้ว / Open ViewTasksPage for completed tasks
                );
              },
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
