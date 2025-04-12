import 'dart:async';

class PointService {
  // 싱글톤 패턴 구현
  static final PointService _instance = PointService._internal();
  factory PointService() => _instance;
  PointService._internal();

  // 현재 포인트
  int _currentPoints = 0;

  // 포인트 변경 스트림 컨트롤러
  final _pointsController = StreamController<int>.broadcast();
  Stream<int> get pointsStream => _pointsController.stream;

  // 현재 포인트 조회
  int get points => _currentPoints;

  // 포인트 추가
  void addPoints(int amount) {
    _currentPoints += amount;
    _pointsController.add(_currentPoints);
  }

  // 포인트 차감
  bool usePoints(int amount) {
    // 차감 가능 여부 확인
    if (_currentPoints >= amount) {
      _currentPoints -= amount;
      _pointsController.add(_currentPoints);
      return true;
    }
    return false;
  }

  // 스트림 종료 처리
  void dispose() {
    _pointsController.close();
  }
}
