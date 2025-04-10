import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // 사용자 정보를 위한 컨트롤러들
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  void dispose() {
    // 컨트롤러 해제
    _emailController.dispose();
    _passwordController.dispose();
    _idNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // GameScreen과 동일한 색상
        title: const Text(
          'My Page',
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
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 파란색 상단 프로필 영역
            Container(
              width: double.infinity,
              color: const Color(0xFF3F32F2), // 진한 파란색/보라색 배경
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: [
                  // 프로필 이미지 (회색 원형)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 60,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 사용자 이름
                  const Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // 사용자 정보 입력 영역
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이메일 필드
                  _buildTextField('Email', _emailController),
                  const SizedBox(height: 20),

                  // 비밀번호 필드
                  _buildTextField('Password', _passwordController, isPassword: true),
                  const SizedBox(height: 20),

                  // ID 이름 필드
                  _buildTextField('ID Name', _idNameController),
                  const SizedBox(height: 20),

                  // 생일 필드
                  _buildTextField('Birthday', _birthdayController),

                  // 확인 버튼
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // 확인 버튼 기능
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F32F2), // 진한 파란색/보라색 배경
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 텍스트 필드 위젯 생성 함수
  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 텍스트
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // 입력 필드
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}