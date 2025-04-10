import 'package:flutter/material.dart';
import 'package:gpgp_app/game-screen.dart';

// Intro1: Did You Know GPGP?
class Intro1Screen extends StatelessWidget {
  const Intro1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5577FF), // 상단 색상
              Color(0xFF3727EB), // 중간 색상
              Color(0xFF091F79), // 하단 색상
            ],
            stops: [0.0, 0.435, 0.91],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 첫 번째 섹션 제목 텍스트
                    const Text(
                      'Did You Know GPGP?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // 첫 번째 이미지 (해양 이미지)
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/ocean_image.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 첫 번째 섹션 설명 텍스트
                    const Text(
                      'The Great Pacific Garbage Patch(GPGP) is a large area in the Pacific Ocean where plastic and other trash accumulate, creating a huge patch of garbage. This floating soup of plastics, fishing nets, and broken down waste poses a serious threat to marine animals. Scientists and environmental groups have been racing against time to stop this giant from taking over the ocean by cleaning them up and promoting changes in people\'s consumption of plastic. Despite this effort, the battle is far from over and GPGP still remains one of the largest environmental challenges that we have to solve.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),

                    // 두 번째 이미지 (해양 쓰레기 이미지)
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/garbage_patch.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Next 버튼
                    const SizedBox(height: 40),
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Intro2 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Intro2Screen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3727EB),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Intro2: How Bad It Is?
class Intro2Screen extends StatelessWidget {
  const Intro2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5577FF), // 상단 색상
              Color(0xFF3727EB), // 중간 색상
              Color(0xFF091F79), // 하단 색상
            ],
            stops: [0.0, 0.435, 0.91],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 두 번째 섹션 제목 텍스트
                    const Text(
                      'How Bad It Is?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // 두 번째 섹션 설명 텍스트
                    const Text(
                      'The GPGP is not just a floating mass of trash. It is a growing symbol of humanity\'s plastic crisis, lurking in the North Pacific like a vast, synthetic island. Spanning an area twice the size of Texas, this swirling vortex of waste is more than an eyesore. It\'s depth trap for marine life, where creatures mistake microplastics for food and become entangled in ghost nets. As plastic breaks down into toxic particles, they infiltrate the ocean\'s food chain, eventually reaching our dinner plates. The GPGP is a haunting reminder that the plastic we discard never truly disappears, demanding urgent action before our oceans, and our own health, pay the ultimate price.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),

                    // 세 번째 이미지 (두 번째 디자인에서의 이미지)
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/ocean_pollution.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Next 버튼
                    const SizedBox(height: 40),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Intro1 화면으로 돌아가기
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                side: const BorderSide(
                                    color: Colors.white, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Intro3 화면으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Intro3Screen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF3727EB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Intro3: Where It Is? & Why We Made This?
class Intro3Screen extends StatelessWidget {
  const Intro3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5577FF), // 상단 색상
              Color(0xFF3727EB), // 중간 색상
              Color(0xFF091F79), // 하단 색상
            ],
            stops: [0.0, 0.435, 0.91],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 세 번째 섹션 첫 번째 제목 텍스트
                    const Text(
                      'Where It Is?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // 세 번째 섹션 첫 번째 설명 텍스트
                    const Text(
                      'The GPGP is located in the North Pacific Ocean, between Hawaii and California, though its location often changes due to seasonal and interannual variability of winds and currents. It is trapped in the North Pacific Gyre, a system of rotating ocean current that accumulates garbage from continents in the Pacific Rim, including Asia, North America, and South America.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),

                    // 네 번째 이미지 (세 번째 디자인에서의 이미지)
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/game_purpose.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 세 번째 섹션 두 번째 제목 텍스트
                    const Text(
                      'Why We Made This?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // 세 번째 섹션 두 번째 설명 텍스트
                    const Text(
                      'This game is more than an educational tool. It is a wake up call, an adventure and mission to save our oceans. Through immersive gameplay, players will dive deep into the problem, witnessing firsthand the impact of plastic pollution while discovering innovative ways to fight back. Every action in the game mirrors real world solutions, empowering players to realize that change is not just possible—it is necessary. This is not just about learning. It is about inspiring a new generation to protect our planet before it is too late.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    // 버튼 영역
                    const SizedBox(height: 40),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Intro2 화면으로 돌아가기
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                side: const BorderSide(
                                    color: Colors.white, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // 모든 이전 화면 제거하고 게임 화면으로 이동
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GameScreen()),
                                      (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF3727EB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'START',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}