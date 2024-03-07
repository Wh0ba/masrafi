import 'package:flutter/material.dart';
import 'package:masrafi/handlers/db.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:grouped_list/grouped_list.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key, required this.userID});
  final int userID;
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
      ),
      body: FutureBuilder(
        future: DB.instance.getTransactions(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ: ${snapshot.error}'),
            );
          } else {
            List<MTransaction> data = List<MTransaction>.from(snapshot.data!);

            return GroupedListView<MTransaction, String>(
              useStickyGroupSeparators: true,
              elements: data,
              groupBy: (transaction) =>
                  '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}',
              groupSeparatorBuilder: (String groupByValue) => Text(
                groupByValue,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              itemBuilder: (context, transaction) => ListTile(
                title: Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  'د.ع ${transaction.amount} ${transaction.categoryID != MCategory.income.id ? '-' : '+'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: transaction.categoryID != MCategory.income.id
                    ? Colors.red.shade400
                    : Colors.green.shade200,
              ),
            );
          }
        },
      ),
    );
  }
}
