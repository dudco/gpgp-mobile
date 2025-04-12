import 'dart:async';

class ItemService {
  // 싱글톤 패턴 구현
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal() {
    // 초기 아이템 설정 (Clownfish, Angelfish, Kelp)
    _items = [
      {
        'id': 'fish1',
        'image': 'assets/images/fish1.png',
        'name': 'Clownfish',
        'points': 100,
        'purchased': true,
      },
      {
        'id': 'fish2',
        'image': 'assets/images/fish2.png',
        'name': 'Angelfish',
        'points': 120,
        'purchased': true,
      },
      {
        'id': 'fish3',
        'image': 'assets/images/fish3.png',
        'name': 'Blue Tang',
        'points': 150,
        'purchased': false,
      },
      {
        'id': 'fish4',
        'image': 'assets/images/fish4.png',
        'name': 'Butterflyfish',
        'points': 130,
        'purchased': false,
      },
      {
        'id': 'fish5',
        'image': 'assets/images/fish5.png',
        'name': 'Bluestripe Snapper',
        'points': 180,
        'purchased': false,
      },
      {
        'id': 'fish6',
        'image': 'assets/images/fish6.png',
        'name': 'Moorish Idol',
        'points': 190,
        'purchased': false,
      },
      {
        'id': 'seaweed1',
        'image': 'assets/images/seaweed1.png',
        'name': 'Kelp',
        'points': 70,
        'purchased': true,
      },
      {
        'id': 'seaweed2',
        'image': 'assets/images/seaweed2.png',
        'name': 'Sea Anemone',
        'points': 90,
        'purchased': false,
      },
      {
        'id': 'seaweed3',
        'image': 'assets/images/seaweed3.png',
        'name': 'Seagrass',
        'points': 60,
        'purchased': false,
      },
      {
        'id': 'seaweed4',
        'image': 'assets/images/seaweed4.png',
        'name': 'Coral',
        'points': 100,
        'purchased': false,
      },
    ];
  }

  // 아이템 리스트
  late List<Map<String, dynamic>> _items;

  // 아이템 변경 스트림 컨트롤러
  final _itemsController = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get itemsStream => _itemsController.stream;

  // 아이템 리스트 조회
  List<Map<String, dynamic>> get items => _items;

  // 구매한 아이템만 가져오기
  List<Map<String, dynamic>> get purchasedItems => 
      _items.where((item) => item['purchased'] == true).toList();

  // 아이템 구매 처리
  void purchaseItem(String id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index]['purchased'] = true;
      _itemsController.add(_items);
    }
  }

  // 아이템 구매 상태 업데이트
  void updatePurchasedItems(List<String> ids) {
    for (var id in ids) {
      purchaseItem(id);
    }
  }

  // 스트림 종료 처리
  void dispose() {
    _itemsController.close();
  }
}
