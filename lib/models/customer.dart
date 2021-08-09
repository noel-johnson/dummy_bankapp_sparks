import 'package:sqflite/sqflite.dart';

final String tableCustomer = "customer";

class CustomerFields {
  static final List<String> values = [
    id,
    name,
    email,
    currentBalance,
    dateCreated
  ];
  static final String id = "id";
  static final String name = "name";
  static final String email = "email";
  static final String currentBalance = "current_balance";
  static final String dateCreated = "date_created";
}

class Customer {
  final int? id;
  final String name;
  final String email;
  final double currentBalance;
  final DateTime dateCreated;
  Customer(
      {this.id,
      required this.name,
      required this.email,
      required this.currentBalance,
      required this.dateCreated});

  Customer copy(
          {int? id,
          String? name,
          String? email,
          double? currentBalance,
          DateTime? dateCreated}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        currentBalance: currentBalance ?? this.currentBalance,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  static Customer fromJson(Map<String, Object?> json) => Customer(
      id: json[CustomerFields.id] as int?,
      name: json[CustomerFields.name] as String,
      email: json[CustomerFields.email] as String,
      currentBalance: json[CustomerFields.currentBalance] as double,
      dateCreated: DateTime.parse(json[CustomerFields.dateCreated] as String));

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'current_balance': currentBalance,
        'date_created': dateCreated.toIso8601String()
      };

  @override
  String toString() {
    return 'Customer(id:$id,name:$name,email:$email,currentBalance:$currentBalance, dateCreated:$dateCreated)';
  }
}

// Future<void> insertCustomer(
//     Customer? customer, Future<Database> database) async {
//   // Get a reference to the database.
//   final db = await database;

//   // Insert the Dog into the correct table. You might also specify the
//   // `conflictAlgorithm` to use in case the same dog is inserted twice.
//   //
//   // In this case, replace any previous data.
//   await db.insert(
//     'customers',
//     customer!.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }
