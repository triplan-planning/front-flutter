import 'dart:developer';
import 'dart:developer';

class SpendingPaidFor {
  const SpendingPaidFor({required this.userId, this.forcePrice, this.weight});

  final String userId;
  final num? forcePrice;
  final num? weight;

  factory SpendingPaidFor.fromJson(Map<String, dynamic> json) {
    return SpendingPaidFor(
      userId: json['user'],
      forcePrice: json['forcePrice'],
      weight: json['weight'],
    );
  }
}

class Spending {
  const Spending(
      {required this.id,
      required this.tripId,
      required this.paidBy,
      required this.paidFor,
      required this.amount,
      required this.date,
      required this.category,
      this.title});

  final String id;
  final String tripId;
  final String paidBy;
  final List<SpendingPaidFor> paidFor;
  final num amount;
  final DateTime date;
  final String category;
  final String? title;

  factory Spending.fromJson(Map<String, dynamic> json) {
    return Spending(
      id: json['id'],
      tripId: json['trip'],
      paidBy: json['paidBy'],
      paidFor: (json['paidFor'] as List<dynamic>).cast<SpendingPaidFor>(),
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      title: json['title'],
    );
  }
}
