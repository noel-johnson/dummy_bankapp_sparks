final String tableTransfer = "alltransfers";

class TransferFields {
  static final List<String> values = [
    id,
    senderName,
    receiverName,
    amount,
    transferDate
  ];
  static final String id = "id";
  static final String senderName = "sender_name";
  static final String receiverName = "receiver_name";
  static final String amount = "amount";
  static final String transferDate = "transfer_date";
}

class Transfers {
  final int? id;
  final String senderName;
  final String receiverName;
  final double amount;
  final DateTime transferDate;

  Transfers(
      {this.id,
      required this.senderName,
      required this.receiverName,
      required this.amount,
      required this.transferDate});

  Transfers copy(
          {int? id,
          String? senderName,
          String? receiverName,
          double? amount,
          DateTime? transferDate}) =>
      Transfers(
        id: id ?? this.id,
        senderName: senderName ?? this.senderName,
        receiverName: receiverName ?? this.receiverName,
        amount: amount ?? this.amount,
        transferDate: transferDate ?? this.transferDate,
      );

  static Transfers fromJson(Map<String, Object?> json) => Transfers(
      id: json[TransferFields.id] as int?,
      senderName: json[TransferFields.senderName] as String,
      receiverName: json[TransferFields.receiverName] as String,
      amount: json[TransferFields.amount] as double,
      transferDate:
          DateTime.parse(json[TransferFields.transferDate] as String));

  Map<String, dynamic> toMap() => {
        'id': id,
        'sender_name': senderName,
        'receiver_name': receiverName,
        'amount': amount,
        'transfer_date': transferDate.toIso8601String()
      };

  @override
  String toString() {
    return 'Transfer(id:$id,senderName:$senderName,receiverName:$receiverName,amount:$amount, tranferDate:$transferDate)';
  }
}
