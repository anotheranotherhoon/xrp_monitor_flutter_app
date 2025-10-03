part of 'home_screen.dart';


class HomeScreenController extends ConsumerWidgetController<HomeScreen> {
  HomeScreenController({required super.ref});


  final _lock = SyncLock();
  IO.Socket? socket;
  
  // 캔들 데이터 리스트
  List<Candle> candleData = [];
  
  // 가격 데이터 리스트 (차트용)
  List<double> priceData = [];
  List<DateTime> timeData = [];
  
  // 차트 업데이트를 위한 콜백
  Function(List<Candle>)? onCandleDataUpdate;
  Function()? onPriceDataUpdate;
  
  // 차트 컴포넌트에서 콜백 등록
  void registerCandleUpdateCallback(Function(List<Candle>) callback) {
    onCandleDataUpdate = callback;
  }
  
  void registerPriceUpdateCallback(Function() callback) {
    onPriceDataUpdate = callback;
  }


  @override
  void build(BuildContext context) {

    useEffect(() {
      initSocket();
      return (){
        socket?.disconnect();
      };
    }, []);
    super.build(context);
  }

  void initSocket() {
    socket = IO.io('${ApiPath.apiUrl}', <String, dynamic>{
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
          candleData = (data['candles'] as List)
              .map((item) => Candle.fromJson(item as Map<String, dynamic>))
              .toList();
          
          // 초기 가격 데이터로 차트 초기화
          priceData = candleData.map((candle) => candle.tradePrice).toList();
          timeData = candleData.map((candle) => DateTime.parse(candle.candleDateTimeKst)).toList();
          
          onCandleDataUpdate?.call(candleData);
          onPriceDataUpdate?.call();
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
          priceData.add(price);
          timeData.add(DateTime.now());
          
          // 최대 100개 데이터만 유지
          if (priceData.length > 100) {
            priceData.removeAt(0);
            timeData.removeAt(0);
          }
          
          onPriceDataUpdate?.call();
        }
      }
    });
    socket!.on('new-candle', (data) {
      print('New candle received: $data');
      if (data != null && data['candle'] != null) {
        try {
          // 새로운 캔들 데이터를 리스트에 추가
          final newCandle = Candle.fromJson(data['candle']);
          candleData.add(newCandle);
          
          // 가격과 시간 데이터도 추가
          priceData.add(newCandle.tradePrice);
          timeData.add(DateTime.parse(newCandle.candleDateTimeKst));
          
          // 리스트 크기 제한 (예: 최대 200개)
          if (candleData.length > 200) {
            candleData.removeAt(0);
            priceData.removeAt(0);
            timeData.removeAt(0);
          }
          
          onCandleDataUpdate?.call(candleData);
          onPriceDataUpdate?.call();
        } catch (e) {
          print('Error parsing new candle: $e');
        }
      }
    });}


}