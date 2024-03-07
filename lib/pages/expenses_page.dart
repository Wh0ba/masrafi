import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masrafi/handlers/db.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/widgets/add_item_dialog.dart';
import 'package:masrafi/widgets/item_list_widget.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key, required this.userid}) : super(key: key);
  final int userid;

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage>
    with TickerProviderStateMixin {
  MCategory _selectedCategory = MCategory.food;
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
      appBar: AppBar(
        title: const Text('مصروفاتي'),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Stack(
            children: [
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
                                element.categoryID == _selectedCategory.id)
                            .toList(),
                        onRemove: (index) {},
                      ),
                    ),
                  );
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
                          bottomRight: Radius.circular(20)),
                    ),
                    child: DropdownButton(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      dropdownColor: Theme.of(context).colorScheme.onBackground,
                      underline: Container(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 19),
                      value: _selectedCategory,
                      items: MCategory.values
                          .where((element) => element.id < 10)
                          .map((e) => DropdownMenuItem(
                              alignment: Alignment.center,
                              value: e,
                              child: Text(e.name)))
                          .toList(),
                      onChanged: (value) => setState(
                          () => _selectedCategory = value ?? MCategory.food),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewItemDialog(
            context: context,
            isExpense: true,
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
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


}
