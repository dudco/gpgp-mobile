import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gpgp_app/account-screen.dart';
import 'package:gpgp_app/mission-screen.dart';
import 'package:gpgp_app/point-service.dart';

import 'item-service.dart';
import 'item-screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // 아이템 서비스
  final ItemService _itemService = ItemService();
  final PointService _pointService = PointService();
  
  // 구매한 물고기와 해초 관련
  List<Map<String, dynamic>> _purchasedFishes = [];
  List<Map<String, dynamic>> _purchasedSeaweeds = [];
  
  // 물고기 애니메이션을 위한 컨트롤러들
  List<AnimationController> _fishControllers = [];
  List<Animation<Offset>> _fishAnimations = [];

  // 미세플라스틱 애니메이션 컨트롤러
  late AnimationController _microplasticsController;

  // 물고기 정보 (위치, 크기, 방향)
  final List<Fish> _fishes = [];

  // 미세플라스틱 정보
  List<Microplastic> _microplastics = [];
  
  // 스트림 구독
  late StreamSubscription _itemSubscription;
  late StreamSubscription _pointSubscription;
  
  // 현재 포인트
  int _currentPoints = 0;

  // 랜덤 생성기
  final Random _random = Random();

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 미세플라스틱 애니메이션 컨트롤러 초기화
    _microplasticsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // 구매한 아이템 로드
    _loadPurchasedItems();
    
    // 아이템 변경 구독
    _itemSubscription = _itemService.itemsStream.listen((_) {
      // 아이템이 업데이트되면 화면 갱신
      _loadPurchasedItems();
    });
    
    // 포인트 변경 이벤트 구독
    _currentPoints = _pointService.points;
    _pointSubscription = _pointService.pointsStream.listen((points) {
      setState(() {
        _currentPoints = points;
      });
    });

    // 미세 플라스틱 생성 (초기 20개)
    _updateMicroplastics();

    // 주기적으로 물고기 움직임 업데이트
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateFishAnimations();
    });

    _initBackgroundMusic();
  }
  
  // 구매한 아이템 로드
  void _loadPurchasedItems() {
    // 기존 물고기 애니메이션 컨트롤러 해제
    for (var controller in _fishControllers) {
      controller.dispose();
    }
    _fishControllers = [];
    _fishAnimations = [];
    _fishes.clear();
    
    // 구매한 아이템 필터링
    final purchasedItems = _itemService.purchasedItems;
    
    // 물고기와 해초 구분
    _purchasedFishes = purchasedItems.where((item) => 
      item['id'].toString().startsWith('fish')).toList();
      
    _purchasedSeaweeds = purchasedItems.where((item) => 
      item['id'].toString().startsWith('seaweed')).toList();
    
    // 물고기 생성
    _createFishes();
    
    // 미세플라스틱 업데이트
    _updateMicroplastics();
    
    setState(() {});
  }
  
  // 미세플라스틱 업데이트 - 구매한 아이템 수에 따라 감소
  void _updateMicroplastics() {
    // 기존 미세플라스틱 지우기
    _microplastics.clear();
    
    // 구매한 총 아이템 수
    int purchasedItemsCount = _purchasedFishes.length + _purchasedSeaweeds.length;
    
    // 최대 미세플라스틱 수 (20개) - 아이템 당 2개씩 감소
    int maxMicroplastics = 20;
    int microplasticsCount = maxMicroplastics - (purchasedItemsCount * 2);
    
    // 최소 미세플라스틱 수는 0개로 제한
    microplasticsCount = microplasticsCount < 0 ? 0 : microplasticsCount;
    
    // 미세플라스틱 생성
    if (microplasticsCount > 0) {
      _createMicroplastics(microplasticsCount);
    }
  }

  // 배경 음악 초기화 및 재생 함
  Future<void> _initBackgroundMusic() async {
    try {
      // 오디오 소스 설정 (앱 내 assets에서 로드)
      await _audioPlayer.setSource(AssetSource('audio/Deep Underwater.mp3'));

      // 반복 재생 설정
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // 볼륨 설정 (0.0 ~ 1.0)
      await _audioPlayer.setVolume(0.5);

      // 음악 재생
      await _audioPlayer.resume();
    } catch (e) {
      print('배경 음악 재생 에러: $e');
    }
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 해제
    for (var controller in _fishControllers) {
      controller.dispose();
    }
    _microplasticsController.dispose();
    _audioPlayer.dispose();
    _itemSubscription.cancel();

    super.dispose();
  }

  // 물고기 생성 함수 수정 부분
  void _createFishes() {
    // 구매한 물고기가 없으면 리턴
    if (_purchasedFishes.isEmpty) return;
    
    for (int i = 0; i < _purchasedFishes.length; i++) {
      final fishData = _purchasedFishes[i];
      
      // 물고기 크기 (사이즈는 종류별로 다르게 설정)
      double size = 80 + (_random.nextDouble() * 20); // 기본 크기 조정
      
      // 물고기 위치
      double x = _random.nextDouble() * 0.8 + 0.1; // 화면의 10%~90% 사이
      double y = _random.nextDouble() * 0.6 + 0.2; // 화면의 20%~80% 사이

      // 물고기 방향 (오른쪽/왼쪽)
      bool isRightDirection = _random.nextBool();

      // 물고기 객체 생성
      _fishes.add(Fish(
        size: size,
        position: Offset(x, y),
        imagePath: fishData['image'],
        isRightDirection: isRightDirection,
      ));

      // 물고기 애니메이션 컨트롤러 생성 - 지속 시간 더 길게 설정
      AnimationController controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: _random.nextInt(7) + 8), // 8-15초로 더 길게
      );

      // 새로운 목적지
      double targetX = _random.nextDouble() * 0.8 + 0.1;
      double targetY = _random.nextDouble() * 0.6 + 0.2;

      // 애니메이션 생성 - 더 부드러운 곡선 사용
      Animation<Offset> animation = Tween<Offset>(
        begin: Offset(x, y),
        end: Offset(targetX, targetY),
      ).animate(CurvedAnimation(
        parent: controller,
        // 더 자연스러운 움직임을 위한 곡선 사용
        curve: Curves.easeInOutSine,
      ));

      _fishControllers.add(controller);
      _fishAnimations.add(animation);

      // 애니메이션 시작
      controller.forward();

      // 애니메이션 상태 변화 감지
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 현재 위치와 방향 저장
          Offset currentPosition = _fishAnimations[i].value;
          bool currentDirection = _fishes[i].isRightDirection;

          // 새로운 목적지 (현재 위치에서 더 자연스럽게 이어지도록)
          double newTargetX;
          double newTargetY;

          // 화면 경계 내에서 현재 방향을 유지하는 경향이 있도록 설정
          if (currentDirection) {
            // 오른쪽으로 가고 있었다면, 계속 오른쪽으로 가는 경향
            newTargetX = currentPosition.dx + (_random.nextDouble() * 0.3);
            // 화면 밖으로 나가지 않도록
            if (newTargetX > 0.9) {
              // 방향 전환
              newTargetX = currentPosition.dx - (_random.nextDouble() * 0.3);
              _fishes[i].isRightDirection = false;
            }
          } else {
            // 왼쪽으로 가고 있었다면, 계속 왼쪽으로 가는 경향
            newTargetX = currentPosition.dx - (_random.nextDouble() * 0.3);
            // 화면 밖으로 나가지 않도록
            if (newTargetX < 0.1) {
              // 방향 전환
              newTargetX = currentPosition.dx + (_random.nextDouble() * 0.3);
              _fishes[i].isRightDirection = true;
            }
          }

          // Y 좌표는 작은 변화로 제한 (급격한 상하 이동 방지)
          double yChange = (_random.nextDouble() * 0.2) - 0.1; // -0.1 ~ 0.1
          newTargetY = currentPosition.dy + yChange;
          newTargetY = newTargetY.clamp(0.2, 0.8); // Y 범위 제한

          // 애니메이션 재설정
          _fishAnimations[i] = Tween<Offset>(
            begin: currentPosition,
            end: Offset(newTargetX, newTargetY),
          ).animate(CurvedAnimation(
            parent: controller,
            // 이동 시작과 끝을 부드럽게
            curve: Curves.easeInOutSine,
          ));

          // 애니메이션 지속 시간 다양화 (8-15초)
          controller.duration = Duration(seconds: _random.nextInt(7) + 8);
          controller.reset();
          controller.forward();
        }
      });
    }
  }

  // 물방울 생성 함수 제거

  // 물고기 애니메이션 업데이트 함수 수정
  void _updateFishAnimations() {
    if (_fishes.isEmpty) return;
    
    for (int i = 0; i < _fishes.length; i++) {
      // 물고기의 현재 위치
      Offset currentPosition = _fishAnimations[i].value;
      bool currentDirection = _fishes[i].isRightDirection;

      // 새로운 목적지 (현재 방향을 고려하여 설정)
      double targetX;

      if (currentDirection) {
        // 오른쪽으로 이동 중이면 계속 오른쪽 방향으로
        targetX = currentPosition.dx + (_random.nextDouble() * 0.3);
        // 경계 체크
        if (targetX > 0.9) {
          // 방향 전환
          targetX = currentPosition.dx - (_random.nextDouble() * 0.3);
          _fishes[i].isRightDirection = false;
        }
      } else {
        // 왼쪽으로 이동 중이면 계속 왼쪽 방향으로
        targetX = currentPosition.dx - (_random.nextDouble() * 0.3);
        // 경계 체크
        if (targetX < 0.1) {
          // 방향 전환
          targetX = currentPosition.dx + (_random.nextDouble() * 0.3);
          _fishes[i].isRightDirection = true;
        }
      }

      // Y 좌표는 덜 변화하도록 (물고기는 주로 수평으로 움직임)
      double yChange = (_random.nextDouble() * 0.2) - 0.1; // -0.1 ~ 0.1
      double targetY = currentPosition.dy + yChange;
      targetY = targetY.clamp(0.2, 0.8); // 화면 범위 내로 제한

      // 애니메이션 업데이트
      _fishAnimations[i] = Tween<Offset>(
        begin: currentPosition,
        end: Offset(targetX, targetY),
      ).animate(CurvedAnimation(
        parent: _fishControllers[i],
        curve: Curves.easeInOutSine,
      ));

      // 애니메이션 지속 시간 다양화 (물고기마다 속도 차이)
      _fishControllers[i].duration = Duration(seconds: _random.nextInt(7) + 8);
      _fishControllers[i].reset();
      _fishControllers[i].forward();
    }
  }

  // 미세 플라스틱 생성 함수
  void _createMicroplastics(int count) {
    // 미세 플라스틱의 다양한 색상 정의 - 더 눈에 띄고 다양한 색상 사용
    final List<Color> plasticColors = [
      Colors.white,
      Colors.grey.shade300,
      Colors.blue.shade100,
      Colors.yellow,
      Colors.pink.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.red.shade100,
    ];

    // 미세 플라스틱이 떠다닐 y축 위치들 (화면 상단에 3개의 고정된 라인)
    final List<double> fixedYPositions = [
      0.10, // 상단 10% 위치
      0.12, // 상단 12% 위치
    ];

    for (int i = 0; i < count; i++) {
      // 다양한 크기의 미세 플라스틱 (3~15 사이)
      double size = _random.nextDouble() * 12 + 3;
      double aspectRatio = 0.8 + (_random.nextDouble() * 0.4);

      // x 위치는 랜덤, y 위치는 고정된 3개 라인 중 하나에 배치
      double x = _random.nextDouble();
      double y = fixedYPositions[i % fixedYPositions.length];

      // 랜덤 색상
      Color color = plasticColors[_random.nextInt(plasticColors.length)];

      // 랜덤 속도 (좌우로만 움직임) - 각 플라스틱마다 다른 속도로 설정
      double speed = (_random.nextDouble() * 0.005 + 0.001) *
          (_random.nextBool() ? 1 : -1); // 양수 또는 음수 속도

      // 랜덤 회전
      double rotation = _random.nextDouble() * 2 * pi;

      double width = size;
      double height = size * aspectRatio;


      double topLeft = size / 2 * _random.nextDouble();
      double topRight = size / 2 * _random.nextDouble();
      double bottomLeft = size / 2 * _random.nextDouble();
      double bottomRight = size / 2 * _random.nextDouble();
      if (_random.nextDouble() > 0.3) {
        double tmp = size / _random.nextDouble() * 2 + 1;
        topLeft = tmp;
        topRight = tmp;
        bottomLeft = tmp;
        bottomRight = tmp;
      }

      // 미세 플라스틱 객체 생성
      _microplastics.add(Microplastic(
        size: size,
        height: height,
        width: width,
        position: Offset(x, y),
        speed: speed,
        color: color,
        topLeftBorderRadius: topLeft,
        topRightBorderRadius: topRight,
        bottomLeftBorderRadius: bottomLeft,
        bottomRightBorderRadius: bottomRight,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // 설정 메뉴
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 바다 배경 이미지
          Image.asset(
            'assets/images/ocean_background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // 해초 이미지들
          _buildSeaweeds(),

          // 미세 플라스틱 애니메이션
          AnimatedBuilder(
            animation: _microplasticsController,
            builder: (context, child) {
              return Stack(
                children: _microplastics.map((plastic) {
                  // 미세 플라스틱 위치 업데이트 (좌우로만 움직임)
                  // 매우 미세하게 상하 떨림만 추가 (고정된 y 위치에서 약간의 흔들림)
                  double tinyVerticalWave = sin(
                          _microplasticsController.value * pi +
                              plastic.position.dx * 10) *
                      0.00003;

                  // 수평 이동은 각 플라스틱의 속도에 따라 진행
                  plastic.position = Offset(
                    (plastic.position.dx +
                            plastic.speed * _microplasticsController.value) %
                        1.0,
                    plastic.position.dy +
                        tinyVerticalWave, // 원래 y값에 아주 작은 흔들림만 추가
                  );

                  // 플라스틱이 화면 밖으로 벗어나면 반대편에서 다시 등장
                  if (plastic.position.dx > 1.0) plastic.position = Offset(0.0, plastic.position.dy);
                  if (plastic.position.dx < 0.0) plastic.position = Offset(1.0, plastic.position.dy);

                  return Positioned(
                    left: plastic.position.dx * MediaQuery.of(context).size.width,
                    top: plastic.position.dy * MediaQuery.of(context).size.height,
                    child: Container(
                      width: plastic.width,
                      height: plastic.height,
                      decoration: BoxDecoration(
                        color: plastic.color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(plastic.topLeftBorderRadius),
                          topRight: Radius.circular(plastic.topRightBorderRadius),
                          bottomLeft: Radius.circular(plastic.bottomLeftBorderRadius),
                          bottomRight: Radius.circular(plastic.bottomRightBorderRadius),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // 물고기 애니메이션
          ..._buildFishes(),

          // 하단 버튼들
          Positioned(
            bottom: 30,
            left: 20,
            child: Row(
              children: [
                _buildButton('Items', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ItemsScreen()),
                  );
                }),
                const SizedBox(width: 10),
                _buildButton('Points', () {
                }),
                const SizedBox(width: 10),
                _buildButton('Mission', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MissionScreen()
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 해초 위젯들
  Widget _buildSeaweeds() {
    // 구매한 해초가 없으면 빈 컨테이너 반환
    if (_purchasedSeaweeds.isEmpty) {
      return Container();
    }
    
    // 해초 위치 (균등하게 분포)
    List<Offset> positions = [
      const Offset(0.1, 0.95), // 왼쪽 끝
      const Offset(0.35, 0.93), // 왼쪽에서 1/3 지점
      const Offset(0.65, 0.94), // 오른쪽에서 1/3 지점
      const Offset(0.9, 0.92), // 오른쪽 끝
    ];

    // 구매한 해초의 수만큼만 위치 설정 (최대 4개)
    int count = _purchasedSeaweeds.length > 4 ? 4 : _purchasedSeaweeds.length;

    return Stack(
      children: List.generate(count, (index) {
        // 구매한 해초 데이터 가져오기
        final seaweedData = _purchasedSeaweeds[index % _purchasedSeaweeds.length];
        
        return Positioned(
          bottom:
              MediaQuery.of(context).size.height * (1 - positions[index].dy),
          left: MediaQuery.of(context).size.width * positions[index].dx - 30,
          child: Image.asset(
            seaweedData['image'],
            height: 80,
          ),
        );
      }),
    );
  }

  // 물고기 렌더링
  List<Widget> _buildFishes() {
    List<Widget> fishWidgets = [];

    for (int i = 0; i < _fishes.length; i++) {
      final fish = _fishes[i];

      fishWidgets.add(
        AnimatedBuilder(
          animation: _fishControllers[i],
          builder: (context, child) {
            return Positioned(
              left: _fishAnimations[i].value.dx *
                  MediaQuery.of(context).size.width,
              top: _fishAnimations[i].value.dy *
                  MediaQuery.of(context).size.height,
              child: Transform.scale(
                scale: fish.size / 40, // 크기 조정
                child: Transform.flip(
                  flipX: !fish.isRightDirection,
                  child: Image.asset(
                    fish.imagePath,
                    width: 40,
                    height: 24,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return fishWidgets;
  }

  // 버튼 위젯
  Widget _buildButton(String text, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// 물고기 클래스
class Fish {
  double size;
  Offset position;
  String imagePath;
  bool isRightDirection;

  Fish({
    required this.size,
    required this.position,
    required this.imagePath,
    required this.isRightDirection,
  });
}

// 물방울 클래스 제거

class Microplastic {
  double size;
  double width;
  double height;
  double topLeftBorderRadius;
  double topRightBorderRadius;
  double bottomLeftBorderRadius;
  double bottomRightBorderRadius;

  Offset position;
  double speed;
  Color color;

  Microplastic({
    required this.size,
    required this.position,
    required this.speed,
    required this.color,
    required this.width,
    required this.height,
    required this.topLeftBorderRadius,
    required this.topRightBorderRadius,
    required this.bottomLeftBorderRadius,
    required this.bottomRightBorderRadius,
  });
}