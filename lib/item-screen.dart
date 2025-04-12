import 'package:flutter/material.dart';
import 'dart:async';

import 'account-screen.dart';
import 'point-service.dart';
import 'item-service.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final PointService _pointService = PointService();
  final ItemService _itemService = ItemService();
  late StreamSubscription _pointSubscription;
  late StreamSubscription _itemSubscription;
  int _currentPoints = 0;
  late List<Map<String, dynamic>> _items;
  
  @override
  void initState() {
    super.initState();
    _currentPoints = _pointService.points;
    _items = _itemService.items;
    
    // 선택 필드 추가
    _items = _items.map((item) => {...item, 'selected': false}).toList();
    
    // 포인트 변경 이벤트 구독
    _pointSubscription = _pointService.pointsStream.listen((points) {
      setState(() {
        _currentPoints = points;
      });
    });
    
    // 아이템 변경 이벤트 구독
    _itemSubscription = _itemService.itemsStream.listen((items) {
      setState(() {
        // 기존의 selected 상태 유지하면서 아이템 업데이트
        _items = items.map((item) {
          final existingItem = _items.firstWhere(
            (oldItem) => oldItem['id'] == item['id'],
            orElse: () => {...item, 'selected': false},
          );
          return {...item, 'selected': existingItem['selected'] ?? false};
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _pointSubscription.cancel();
    _itemSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Items',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // 포인트 표시 위젯
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
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
                  childAspectRatio: 0.85,
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
              onPressed: _purchaseSelectedItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFDD57),
                foregroundColor: Colors.black87,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Buy',
                style: TextStyle(
                  fontSize: 16,
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
    final item = _items[index];
    final bool canPurchase = !item['purchased'] && _currentPoints >= item['points'];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item['selected'] 
              ? Colors.blue.shade600 
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          // 이미 구매한 아이템은 선택할 수 없음
          if (!item['purchased']) {
            setState(() {
              item['selected'] = !item['selected'];
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              
              // 아이템 이미지
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 이미지
                    Image.asset(
                      item['image'],
                      fit: BoxFit.contain,
                    ),
                    
                    // 구매 상태 표시
                    if (item['purchased'])
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 포인트 및 구매 상태 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item['purchased']
                      ? Colors.green.shade100
                      : canPurchase 
                          ? const Color(0xFFF7DD30).withOpacity(0.7)
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['purchased'] 
                          ? Icons.check_circle 
                          : Icons.star,
                      size: 16,
                      color: item['purchased']
                          ? Colors.green
                          : canPurchase 
                              ? const Color(0xFF1D1B20)
                              : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['purchased']
                          ? 'Owned'
                          : '${item['points']} pts',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item['purchased']
                            ? Colors.green
                            : canPurchase 
                                ? const Color(0xFF1D1B20)
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 선택된 아이템 구매 처리
  void _purchaseSelectedItems() {
    int totalCost = 0;
    List<Map<String, dynamic>> selectedItems = [];
    
    // 선택된 아이템 계산
    for (var item in _items) {
      if (item['selected'] == true && item['purchased'] == false) {
        totalCost += item['points'] as int;
        selectedItems.add(item);
      }
    }
    
    // 구매 가능 여부 확인
    if (selectedItems.isEmpty) {
      _showMessage('Please select items to purchase');
      return;
    }
    
    if (_currentPoints < totalCost) {
      _showMessage('Not enough points. You need $totalCost points.');
      return;
    }
    
    // 구매 처리
    if (_pointService.usePoints(totalCost)) {
      setState(() {
        for (var item in selectedItems) {
          item['purchased'] = true;
          item['selected'] = false;
          _itemService.purchaseItem(item['id']);
        }
      });
      
      _showMessage('Items purchased successfully!');
    } else {
      _showMessage('Failed to purchase items');
    }
  }
  
  // 메시지 표시
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('success') 
            ? Colors.green.shade800 
            : Colors.blue.shade900,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}