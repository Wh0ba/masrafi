import 'package:flutter/material.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/widgets/add_item_dialog.dart';
import 'package:masrafi/widgets/item_list_widget.dart';

import '../handlers/db.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, required this.userid});
  final int userid;

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> with TickerProviderStateMixin {
  int tabBarIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(milliseconds: 200));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text('ايراداتي'),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Spacer(),
        FutureBuilder(
          future: DB.instance.getTransactions(widget.userid),
          initialData: const [],
          builder: (context, snapshot) {
            List<MTransaction> data = [];
            if (snapshot.hasData) {
              data = List<MTransaction>.from(snapshot.data!);
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: ItemList(
                  placeholder: "أضف مصروف جديد",
                  items: data
                      .where((element) =>
                          element.categoryID == MCategory.income.id)
                      .toList(),
                  onRemove: (index) {},
                ),
              ),
            );
          },
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => addNewItemDialog(
              context: context,
              isExpense: false,
              callback: (name, amount, date, category) {
                DB.instance.addTransaction(
                    MTransaction(
                        name: name,
                        amount: amount,
                        date: date,
                        categoryID: category.id),
                    widget.userid);
                setState(() {});
              }),
          child: const Icon(Icons.add)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
