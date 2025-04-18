import 'package:flutter/material.dart';
import 'dart:async';

import 'account-screen.dart';
import 'point-service.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({Key? key}) : super(key: key);

  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final PointService _pointService = PointService();
  late StreamSubscription _pointSubscription;
  int _currentPoints = 0;
  
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
  void initState() {
    super.initState();
    _currentPoints = _pointService.points;
    
    // 포인트 변경 이벤트 구독
    _pointSubscription = _pointService.pointsStream.listen((points) {
      setState(() {
        _currentPoints = points;
      });
    });
  }

  @override
  void dispose() {
    _pointSubscription.cancel();
    super.dispose();
  }

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
              // 카드 헤더 (제목, 설명, 포인트 표시)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mission List',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1D1B20),
                          ),
                        ),
                        // 포인트 표시 위젯
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7DD30),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF1D1B20),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 18, color: Color(0xFF1D1B20)),
                              const SizedBox(width: 4),
                              Text(
                                '$_currentPoints pts',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D1B20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
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
            // 이미 완료된 미션은 다시 취소할 수 없음
            if (mission.isCompleted) {
              _showCompletedMissionMessage();
              return;
            }
            
            setState(() {
              mission.isCompleted = true;
            });
            
            // 미션 완료 시 포인트 추가
            _pointService.addPoints(mission.points);
            _showPointEarnedSnackbar(mission.points);
          },
          // 완료된 미션은 포인터 커서 변경 및 배경색 변경
          splashColor: mission.isCompleted 
              ? Colors.transparent 
              : Theme.of(context).splashColor,
          highlightColor: mission.isCompleted 
              ? Colors.transparent 
              : Theme.of(context).highlightColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 미션 제목 영역
                Expanded(
                  child: Text(
                    mission.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: mission.isCompleted 
                          ? const Color(0xFF65558F) 
                          : const Color(0xFF1D1B20),
                      letterSpacing: 0.5,
                      height: 1.5,
                      decoration: mission.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 포인트 표시
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: mission.isCompleted 
                        ? const Color(0xFF65558F).withOpacity(0.1) 
                        : const Color(0xFFF7DD30).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${mission.points}+',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: mission.isCompleted 
                          ? const Color(0xFF65558F) 
                          : const Color(0xFF49454F),
                      letterSpacing: 0.5,
                    ),
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
  
  // 포인트 획득 알림 표시
  void _showPointEarnedSnackbar(int points) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 8),
            Text('You earned $points points!'),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  // 이미 완료된 미션 알림 표시
  void _showCompletedMissionMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Mission already completed!'),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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