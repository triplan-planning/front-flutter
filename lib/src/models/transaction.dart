import 'package:triplan/src/utils/serializable.dart';

class TransactionTarget implements Serializable {
  const TransactionTarget(
      {required this.userId, this.forcePrice, this.weight, this.computedPrice});

  final String userId;
  final num? forcePrice;
  final num? weight;
  final num? computedPrice;

  factory TransactionTarget.fromJson(Map<String, dynamic> json) {
    return TransactionTarget(
      userId: json['user'],
      forcePrice: json['forcePrice'],
      weight: json['weight'],
      computedPrice: json['computedPrice'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['user'] = userId;
    data['forcePrice'] = forcePrice;
    data['weight'] = weight;
    data['computedPrice'] = computedPrice;

    return data;
  }
}

class Transaction implements Serializable {
  const Transaction(
      {required this.id,
      required this.groupId,
      required this.paidBy,
      required this.paidFor,
      required this.amount,
      required this.date,
      required this.category,
      this.title});

  final String id;
  final String groupId;
  final String paidBy;
  final List<TransactionTarget> paidFor;
  final num amount;
  final DateTime date;
  final String category;
  final String? title;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final targets = (json['paidFor'] as List<dynamic>)
        .map((e) => TransactionTarget.fromJson(e))
        .toList();
    return Transaction(
      id: json['id'],
      groupId: json['group'],
      paidBy: json['paidBy'],
      paidFor: targets,
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      title: json['title'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['paidFor'] = paidFor.map((e) => e.toJson()).toList();
    data['group'] = groupId;
    data['paidBy'] = paidBy;
    data['amount'] = amount;
    data['date'] = date.toUtc().toIso8601String();
    data['category'] = category;
    data['title'] = title;

    return data;
  }
}
