import 'package:flutter/material.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'item_card.dart';

class ItemList extends StatefulWidget {
  const ItemList(
      {super.key,
      required this.items,
      required this.placeholder,
      required this.onRemove});
  final String placeholder;
  final List<MTransaction> items;
  final Function(int index) onRemove;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: (widget.items.isNotEmpty)
          ? ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: ((context, index) {
                return ItemCard(
                  item: widget.items[index],
                  removeItemCallback: () => widget.onRemove(index),
                );
              }))
          : Center(
              child: Text(
              widget.placeholder,
              style: const TextStyle(fontSize: 26, color: Colors.white30),
            )),
    );
  }
}
