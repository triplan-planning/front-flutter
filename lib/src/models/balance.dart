import 'package:triplan/src/utils/serializable.dart';

class Balance implements Serializable {
  const Balance({
    required this.positiveAmount,
    required this.negativeAmount,
    required this.totalAmount,
  });

  final int positiveAmount;
  final int negativeAmount;
  final int totalAmount;

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      positiveAmount: json['positiveAmount']!,
      negativeAmount: json['negativeAmount']!,
      totalAmount: json['totalAmount']!,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['positiveAmount'] = positiveAmount;
    data['negativeAmount'] = negativeAmount;
    data['totalAmount'] = totalAmount;

    return data;
  }
}

class BalanceMap implements Serializable {
  const BalanceMap({required this.map});
  final Map<String, Balance> map;

  factory BalanceMap.fromJson(Map<String, dynamic> json) {
    final temp =
        json.map((key, value) => MapEntry(key, Balance.fromJson(value)));
    return BalanceMap(map: temp);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        map.map((key, value) => MapEntry(key, value.toJson()));

    return data;
  }
}
