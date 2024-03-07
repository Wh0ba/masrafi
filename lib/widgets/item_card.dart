import 'package:flutter/material.dart';
import 'package:masrafi/models/m_transaction.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(
      {super.key, required this.item, required this.removeItemCallback});
  final MTransaction item;
  final Function removeItemCallback;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          widget.item.name,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.item.amount}',
              textScaler: const TextScaler.linear(1.5),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                color: Theme.of(context).colorScheme.surface,
                onPressed: () {
                  widget.removeItemCallback();
                },
                icon: const Icon(Icons.delete_forever))
          ],
        ));
  }
}
