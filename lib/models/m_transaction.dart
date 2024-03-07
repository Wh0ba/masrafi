class MTransaction {
  String name;
  num amount;
  DateTime date;
  int categoryID;
  MTransaction(
      {required this.name,
      required this.amount,
      required this.date,
      required this.categoryID});
  MTransaction.fromMap(Map<String, dynamic> map)
      : name = map['transaction_name'],
        amount = map['transaction_amount'],
        date = DateTime.fromMillisecondsSinceEpoch(
            (map['transaction_date'])),
        categoryID = map['category_id'];
}
