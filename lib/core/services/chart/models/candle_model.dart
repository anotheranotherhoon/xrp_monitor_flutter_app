// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candle_model.freezed.dart';

part 'candle_model.g.dart';

@freezed
abstract class Candle with _$Candle {
  const factory Candle({
    required String market,
    @JsonKey(name: 'candle_date_time_utc') required String candleDateTimeUtc,
    @JsonKey(name: 'candle_date_time_kst') required String candleDateTimeKst,
    @JsonKey(name: 'opening_price') required double openingPrice,
    @JsonKey(name: 'high_price') required double highPrice,
    @JsonKey(name: 'low_price') required double lowPrice,
    @JsonKey(name: 'trade_price') required double tradePrice,
    required int timestamp,
    @JsonKey(name: 'candle_acc_trade_price') required double candleAccTradePrice,
    @JsonKey(name: 'candle_acc_trade_volume') required double candleAccTradeVolume,
    required int unit,
  }) = _Candle;

  const Candle._();

  factory Candle.fromJson(Map<String, dynamic> json) => _$CandleFromJson(json);
}