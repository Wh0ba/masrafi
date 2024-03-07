import 'package:flutter/material.dart';
import 'package:masrafi/handlers/db.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/widgets/add_item_dialog.dart';
import 'package:masrafi/widgets/item_list_widget.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key, required this.userid});
  final int userid;
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage>
    with TickerProviderStateMixin {
  MCategory _selectedCategory = MCategory.food;
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
        title: const Text('مصروفاتي'),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const ListTile(
          tileColor: Color(0xffeadeda),
          title: Text("نقودي"),
          trailing: Text(
            "IQD 100.00",
            textScaler: TextScaler.linear(1.4),
          ),
        ),
        const Divider(),
        const Spacer(),
        Stack(
          children: [
            FutureBuilder(
              future: DB.instance.getTransactions(widget.userid),
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MTransaction> data =
                      List<MTransaction>.from(snapshot.data!);
                  return SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: ItemList(
                          placeholder: "أضف مصروف جديد",
                          items: data
                              .where((element) =>
                                  element.categoryID == _selectedCategory.id)
                              .toList(),
                          onRemove: (index) {},
                        ),
                      ));
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: ItemList(
                      placeholder: "الرجاء الإنتظار...",
                      items: const [],
                      onRemove: (index) {},
                    ),
                  );
                }
              },
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: DropdownButton(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      dropdownColor: Theme.of(context).colorScheme.onBackground,
                      underline: Container(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 19),
                      value: _selectedCategory,
                      items: [
                        ...MCategory.values
                            .where((element) => element.id < 10)
                            .map((e) => DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: e,
                                  child: Text(e.name),
                                ))
                            .toList()
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? MCategory.food;
                        });
                      }),
                ),
              ),
            ),
          ],
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            addNewItemDialog(context, (name, amount, date, category) {
              DB.instance.addTransaction(
                  MTransaction(
                      name: name,
                      amount: amount,
                      date: date,
                      categoryID: category.id),
                  widget.userid);
              setState(() {});
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
