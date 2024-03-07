import 'package:flutter/material.dart';
import 'package:masrafi/handlers/helpers.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:intl/intl.dart' as intl;

Future<dynamic> addNewItemDialog(BuildContext context,
    Function(String name, double price,DateTime date, MCategory category) callback) {
  MCategory selectedCategory = MCategory.food;
  DateTime date = DateTime.now();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController priceController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          scrollable: true,
          title: const Center(child: Text('إضافة عنصر')),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال نص';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          icon: Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [DecimalNumberFormatter()],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال السعر';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'السعر',
                          icon: Icon(Icons.price_change),
                        ),
                      ),
                      ListTile(
                        title: DropdownButton(
                          items: [
                            ...MCategory.values
                                .where((element) => element.id < 10)
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ))
                                .toList()
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value ?? MCategory.food;
                            });
                          },
                          value: selectedCategory,
                        ),
                      ),
                      ListTile(
                        title: Text(
                            intl.DateFormat('y-M-d').format(date).toString()),
                        trailing: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              DateTime newDate = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ) ??
                                  DateTime.now();
                              setState(() {
                                date = newDate;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary)),
                child: Text('اضافة',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.background)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    callback(nameController.text,
                        double.parse(priceController.text),date, selectedCategory);
                    Navigator.pop(context);
                  }
                })
          ],
        );
      });
}
