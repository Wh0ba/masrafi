import 'package:flutter/material.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';

Widget remainingMoney(List<MTransaction> data) {
  num totalExpenses = data
      .where((element) => element.categoryID < 10)
      .fold(0, (previousValue, element) => previousValue + element.amount);
  num totalIncome = data
      .where((element) => element.categoryID == MCategory.income.id)
      .fold(0, (previousValue, element) => previousValue + element.amount);
  num total = totalIncome - totalExpenses;
  return ListTile(
    trailing: Text(
      'د.ع $total',
      style: const TextStyle(fontSize: 20),
    ),
    leading: const Text('المتبقي',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );
}
