import 'package:flutter/material.dart';

import 'account-screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  // 아이템 리스트 (경로, 이름, 포인트, 선택 여부)
  final List<Map<String, dynamic>> _items = [
    {
      'image': 'assets/images/fish1.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/fish2.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/fish3.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/fish4.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/fish5.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/fish6.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/seaweed1.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/seaweed2.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/seaweed3.png',
      'points': 10,
      'selected': true,
    },
    {
      'image': 'assets/images/seaweed4.png',
      'points': 10,
      'selected': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // GameScreen과 동일한 색상
        title: const Text(
          'Items',
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
      body: Column(
        children: [
          // 아이템 그리드
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(index);
                },
              ),
            ),
          ),

          // 구매 버튼
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // 구매 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFDD57), // 노란색 배경
                foregroundColor: Colors.black87, // 텍스트 색상
                minimumSize: const Size(120, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Buy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 아이템 카드 위젯
  Widget _buildItemCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 체크박스 영역
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: _items[index]['selected']
                    ? const Icon(
                  Icons.check,
                  color: Color(0xFF673AB7), // 보라색 체크
                  size: 24,
                )
                    : null,
              ),
            ),
          ),

          // 아이템 이미지
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                _items[index]['image'],
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 포인트 표시
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              '${_items[index]['points']} Points',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}