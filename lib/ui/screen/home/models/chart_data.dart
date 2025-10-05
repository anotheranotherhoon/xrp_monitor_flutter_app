// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/services/chart/models/candle_model.dart';

part 'chart_data.freezed.dart';
part 'chart_data.g.dart';

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    @Default([]) List<double> prices,
    @Default([]) List<DateTime> times,
    @Default([]) List<Candle> candles,
    @Default(0) int timestamp,
    @Default(0.0) double currentPrice,
  }) = _ChartData;

  const ChartData._();

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  // 빈 데이터 생성
  factory ChartData.empty() => const ChartData(
    prices: [],
    times: [],
    candles: [],
    timestamp: 0,
    currentPrice: 0.0,
  );

  // 현재가 업데이트
  ChartData updateCurrentPrice(double price) {
    return copyWith(
      prices: [...prices, price],
      times: [...times, DateTime.now()],
      currentPrice: price,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // 데이터 크기 제한
  ChartData limitSize(int maxSize) {
    if (prices.length <= maxSize) return this;
    
    return copyWith(
      prices: prices.sublist(prices.length - maxSize),
      times: times.sublist(times.length - maxSize),
    );
  }
}