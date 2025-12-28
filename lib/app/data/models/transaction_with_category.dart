import 'package:info_saldo_apps/app/data/local/database.dart';

class TransactionWithCategory {
  final Transaction transaction;
  final Category category;

  TransactionWithCategory({required this.transaction, required this.category});
}
