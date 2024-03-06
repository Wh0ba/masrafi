
import 'package:masrafi/models/m_transaction.dart';

class MUser {
  int id;
  String username;
  List<MTransaction> transactions = [];
  MUser({required this.id, required this.username});
}