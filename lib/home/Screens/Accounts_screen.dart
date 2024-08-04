import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'account_info.dart';
import 'package:logger/logger.dart';

// CSRF 안받는중

class AccountsCheckScreen extends StatefulWidget {
  @override
  _AccountsCheckScreenState createState() => _AccountsCheckScreenState();
}

class _AccountsCheckScreenState extends State<AccountsCheckScreen> {
  AccountInfo? _accountInfo;
  List<StockInfo>? _stockInfoList;
  bool _isLoading = false;
  final logger = Logger();

  /// 서버에 계좌 상태를 요청하는 비동기 메서드
  Future<void> _fetchAccountStatus(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    Dio dio = Dio(); // Dio 인스턴스 생성
    try {
      logger.i('Sending request to server...');
      // 서버에 GET 요청 보내기
      final response = await dio.get(
        'https://fintech19190301.kro.kr/api/account/status/',
        queryParameters: {
          'account_id': 'admin',
        },
      );

      // 서버 응답 데이터 로그 출력
      logger.i('Server response: ${response.data}');

      // 요청 성공 시 응답 데이터를 AccountInfo 및 StockInfo 객체로 변환하고 상태 변수에 저장
      setState(() {
        _accountInfo = AccountInfo.fromJson(response.data['account_info']);
        if (response.data['stock_info_list'] != null) {
          _stockInfoList = (response.data['stock_info_list'] as List)
              .map((i) => StockInfo.fromJson(i))
              .toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      // 요청 실패 시 오류 메시지를 상태 변수에 저장하고 화면 업데이트
      logger.e('Failed to load account status: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load account status: $e')),
      );
    } finally {
      // 팝업 닫기
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  /// 팝업을 띄우고 서버 요청을 시작하는 메서드
  void _showLoadingDialogAndFetch(BuildContext context) {
    logger.i('Fetching account status...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로딩 중'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('서버에서 요청을 받아오고 있습니다.'),
            ],
          ),
        );
      },
    );

    // 서버 요청 시작
    _fetchAccountStatus(context);
  }

  /// 위젯 트리를 빌드하여 UI를 구성하는 메서드
  @override
  Widget build(BuildContext context) {
    logger.i('Building AccountsCheckScreen UI');
    return Scaffold(
      appBar: AppBar(
        title: Text('계좌 상태'), // 앱 바의 제목 설정
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _accountInfo == null
          ? Center(child: Text('정보가 없습니다'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('현금', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildAccountInfoCard('총 예수금', _accountInfo!.dncaTotAmt),
            _buildAccountInfoCard('다음날 예수금', _accountInfo!.nxdyExccAmt),
            _buildAccountInfoCard('이전 예수금', _accountInfo!.prvsRcdlExccAmt),
            _buildAccountInfoCard('현금', _accountInfo!.nassAmt),

            SizedBox(height: 20),

            Text('주식', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildAccountInfoCard('주식 평가금액', _accountInfo!.sctsEvluAmt),
            _buildAccountInfoCard('총 평가금액', _accountInfo!.totEvluAmt),
            _buildAccountInfoCard('구매 금액', _accountInfo!.pchsAmtSmtlAmt),
            _buildAccountInfoCard('평가 금액(주식+현금)', _accountInfo!.evluAmtSmtlAmt),
            _buildAccountInfoCard('평가 손익', _accountInfo!.evluPflsSmtlAmt),
            _buildAccountInfoCard('전날 총 자산 평가금액', _accountInfo!.bfdyTotAsstEvluAmt),
            _buildAccountInfoCard('자산 증감 금액', _accountInfo!.asstIcdcAmt),
            _buildAccountInfoCard('자산 증감 수익률', _accountInfo!.asstIcdcErngRt),

            SizedBox(height: 20),
            Text('보유 주식', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_stockInfoList != null && _stockInfoList!.isNotEmpty) ...[
              for (var stock in _stockInfoList!)
                _buildStockInfoCard(stock),
            ] else ...[
              Center(child: Text('보유 주식이 없습니다')),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLoadingDialogAndFetch(context),
        child: Icon(Icons.refresh),
      ),
    );
  }

  /// 계좌 정보를 표시하는 카드 위젯 생성
  Widget _buildAccountInfoCard(String title, dynamic value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 주식 정보를 표시하는 카드 위젯 생성
  Widget _buildStockInfoCard(StockInfo stock) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(stock.prdtName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('보유 수량: ${stock.hldgQty}'),
            Text('주문 가능 수량: ${stock.ordPsblQty}'),
            Text('매입 평균가: ${stock.pchsAvgPric}'),
            Text('매입 금액: ${stock.pchsAmt}'),
            Text('현재가: ${stock.prpr}'),
            Text('평가 금액: ${stock.evluAmt}'),
            Text('평가 손익 금액: ${stock.evluPflsAmt}'),
            Text('평가 손익률: ${stock.evluPflsRt}'),
            Text('등락률: ${stock.flttRt}'),
          ],
        ),
      ),
    );
  }
}
