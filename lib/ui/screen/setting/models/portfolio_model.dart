// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_model.g.dart';
part 'portfolio_model.freezed.dart';

@freezed
abstract class Portfolio with _$Portfolio {
  const factory Portfolio({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'quantity') @Default('0') String quantity,
    @JsonKey(name: 'averagePrice') @Default('0') String averagePrice,
    @JsonKey(name: 'totalInvested') @Default('0') String totalInvested,
    @JsonKey(name: 'memo') @Default('') String memo,
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
    @JsonKey(name: 'quantity') required double quantity,
    @JsonKey(name: 'averagePrice') required double averagePrice,
    @JsonKey(name: 'memo') @Default('') String memo,
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
    @Default('') String error,
  }) = _PortfolioState;

  const PortfolioState._();

  factory PortfolioState.fromJson(Map<String, dynamic> json) =>
      _$PortfolioStateFromJson(json);
}