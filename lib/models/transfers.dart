final String tableTransfer = "transfers";

class Transfers {
  final int? id;
  final String senderName;
  final String receiverName;
  final double amount;
  final DateTime transferDate = DateTime.now();

  Transfers({
    this.id,
    required this.senderName,
    required this.receiverName,
    required this.amount,
  });
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
