part of 'home_screen.dart';


class HomeScreenController extends ConsumerWidgetController<HomeScreen> {
  HomeScreenController({required super.ref});

  io.Socket? socket;
  
  // StreamController로 변경
  final _chartDataController = StreamController<ChartData>.broadcast();
  Stream<ChartData> get chartDataStream => _chartDataController.stream;
  
  // 현재 차트 데이터 상태
  ChartData _currentChartData = ChartData.empty();


  @override
  void build(BuildContext context) {
    useEffect(() {
      initSocket();
      return () {
        _dispose();
      };
    }, []);
    super.build(context);
  }
  
  void _dispose() {
    socket?.disconnect();
    _chartDataController.close();
  }

  void initSocket() {
    socket = io.io(ApiPath.apiUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket?.onConnect((_) {
      print('Connected to server');
      socket?.emit('subscribe-candles', {
        'market': 'KRW-XRP',
        'count': 50
      });
    });

    socket!.on('initial-candles', (data) {
      print('Initial candles received: $data');
      if (data != null && data['candles'] is List) {
        try {
          final candles = (data['candles'] as List)
              .map((item) => Candle.fromJson(item as Map<String, dynamic>))
              .toList();
          
          // ChartData로 초기 데이터 설정
          _currentChartData = ChartData(
            candles: candles,
            prices: candles.map((candle) => candle.tradePrice).toList(),
            times: candles.map((candle) => DateTime.parse(candle.candleDateTimeKst)).toList(),
            currentPrice: candles.isNotEmpty ? candles.last.tradePrice : 0.0,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          );
          
          // Stream으로 데이터 전송
          _chartDataController.add(_currentChartData);
        } catch (e) {
          print('Error parsing initial candles: $e');
        }
      }
    });

    socket!.on('realtime-ticker', (data) {
      print('Realtime ticker received: $data');
      if (data != null && data['trade_price'] != null) {
        double price = double.tryParse(data['trade_price'].toString()) ?? 0.0;
        if (price > 0) {
          // 현재 데이터에 새 가격 추가 후 크기 제한
          _currentChartData = _currentChartData
              .updateCurrentPrice(price)
              .limitSize(100);
          
          // Stream으로 업데이트된 데이터 전송
          _chartDataController.add(_currentChartData);
        }
      }
    });
    
    socket!.on('new-candle', (data) {
      print('New candle received: $data');
      if (data != null && data['candle'] != null) {
        try {
          final newCandle = Candle.fromJson(data['candle']);
          final updatedCandles = [..._currentChartData.candles, newCandle];
          
          // 캔들 데이터 크기 제한 (최대 200개)
          final limitedCandles = updatedCandles.length > 200 
              ? updatedCandles.sublist(updatedCandles.length - 200)
              : updatedCandles;
          
          _currentChartData = _currentChartData.copyWith(
            candles: limitedCandles,
            currentPrice: newCandle.tradePrice,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ).updateCurrentPrice(newCandle.tradePrice).limitSize(200);
          
          // Stream으로 업데이트된 데이터 전송
          _chartDataController.add(_currentChartData);
        } catch (e) {
          print('Error parsing new candle: $e');
        }
      }
    });
  }


}