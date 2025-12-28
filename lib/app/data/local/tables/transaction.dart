import 'package:drift/drift.dart';
import 'package:info_saldo_apps/app/data/local/tables/category.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 128)();
  IntColumn get category_id => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull, // 🔥 INI PENTING
  )();

  DateTimeColumn get transaction_date => dateTime()();
  IntColumn get amount => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updateAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
