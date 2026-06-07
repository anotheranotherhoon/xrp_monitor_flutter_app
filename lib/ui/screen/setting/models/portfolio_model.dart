// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_model.g.dart';
part 'portfolio_model.freezed.dart';

@freezed
abstract class Portfolio with _$Portfolio {
  const factory Portfolio({
    @JsonKey(name: 'hoIdx') @Default(0) int key,
    @JsonKey(name: 'hoQuantity') @Default('0') String quantity,
    @JsonKey(name: 'hoAveragePrice') @Default('0') String averagePrice,
    @JsonKey(name: 'hoTotalInvested') @Default('0') String totalInvested,
    @JsonKey(name: 'hoMemo') @Default('') String memo,
    @JsonKey(name: 'createdAt') @Default('') String createdAt,
    @JsonKey(name: 'updatedAt') @Default('') String updatedAt,
  }) = _Portfolio;

  const Portfolio._();

  factory Portfolio.fromJson(Map<String, dynamic> json) =>
      _$PortfolioFromJson(json);
}

@freezed
abstract class PortfolioRequest with _$PortfolioRequest {
  const factory PortfolioRequest({
    @JsonKey(name: 'hoQuantity') required double quantity,
    @JsonKey(name: 'hoAveragePrice') required double averagePrice,
    @JsonKey(name: 'hoMemo') @Default('') String memo,
  }) = _PortfolioRequest;

  const PortfolioRequest._();

  factory PortfolioRequest.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRequestFromJson(json);
}

@freezed
abstract class PortfolioState with _$PortfolioState {
  const factory PortfolioState({
    @Default(null) Portfolio? portfolio,
    @Default(false) bool isLoading,
    @Default(false) bool isEditing,
    @Default(false) bool isOffline,
    @Default(false) bool hasPendingSync,
    DateTime? lastUpdatedAt,
    @Default('') String error,
  }) = _PortfolioState;

  const PortfolioState._();

  factory PortfolioState.fromJson(Map<String, dynamic> json) =>
      _$PortfolioStateFromJson(json);
}
