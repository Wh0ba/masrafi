import 'package:flutter/material.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/widgets/item_list_widget.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

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
        SingleChildScrollView(
            child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: ItemList(
            placeholder: "أضف ايراد جديد",
            items: const [],
            onRemove: (index) {},
          ),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(Icons.add)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
