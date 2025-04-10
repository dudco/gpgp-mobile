import 'package:flutter/material.dart';

import 'account-screen.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({Key? key}) : super(key: key);

  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  // 미션 데이터
  final List<Mission> _missions = [
    Mission(
      title: "Avoid skincare products with microbeads",
      points: 100,
      isCompleted: false,
    ),
    Mission(
      title: "Choose biodegradable laundry detergents and dish soaps",
      points: 100,
      isCompleted: false,
    ),
    Mission(
      title: "Use energy-efficient appliances and LED bulbs",
      points: 100,
      isCompleted: false,
    ),
    Mission(
      title: "Reduce single-use plastic consumption",
      points: 100,
      isCompleted: false,
    ),
    Mission(
      title: "Participate in local beach or river cleanup events",
      points: 150,
      isCompleted: false,
    ),
    Mission(
      title: "Properly dispose of fishing lines and tackle",
      points: 80,
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4243F2), // Figma에서의 배경색
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // GameScreen과 동일한 색상
        title: const Text(
          'Mission',
          style: TextStyle(
            color: Colors.white, // 텍스트 색상 흰색으로 변경
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // 햄버거 메뉴로 변경, 흰색
          onPressed: () {
            // 메뉴 열기 로직
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white), // 프로필 아이콘으로 변경, 흰색
            onPressed: () {
              // 프로필 액션
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카드 헤더 (제목, 설명)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mission List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1D1B20),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Complete missions to earn points and help protect our oceans from plastic pollution.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF49454F),
                        letterSpacing: 0.25,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1),

              // 미션 리스트 (단일 리스트로 통합)
              Expanded(
                child: ListView.builder(
                  itemCount: _missions.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return _buildMissionListItem(
                        _missions[index],
                        index < _missions.length - 1
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 미션 항목 위젯
  Widget _buildMissionListItem(Mission mission, bool showDivider) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              mission.isCompleted = !mission.isCompleted;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 미션 제목 영역
                Expanded(
                  child: Text(
                    mission.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D1B20),
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 포인트 표시
                Text(
                  '${mission.points}+',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF49454F),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(width: 10),

                // 체크박스
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: mission.isCompleted ? const Color(0xFF65558F) : Colors.transparent,
                    border: Border.all(
                      color: mission.isCompleted ? const Color(0xFF65558F) : const Color(0xFF49454F),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: mission.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),

        // 구분선
        if (showDivider)
          const Divider(
            color: Color(0xFFCAC4D0),
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// 미션 데이터 클래스
class Mission {
  final String title;
  final int points;
  bool isCompleted;

  Mission({
    required this.title,
    required this.points,
    required this.isCompleted,
  });
}