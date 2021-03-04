import "dart:convert";

import 'package:event/event.dart';

// [U] refers to an Update, [C] refers to a Command.
// While [O] refers to an Update and a Command.
enum OrderID {
  Empty,
  Credentials, // [U]
  Invite, // [O]
  Game, // [U]
  Move, // [O]
  Turn, // [U]
  Promotion, // [U]
  Promote, // [C]
  Pause, // [O]
  Message, // [O]
  Done, // [U]
}

class Order extends EventArgs {
  final OrderID id;
  final dynamic obj;

  Order(this.id, this.obj);

  Order.fromJson(Map<String, dynamic> json)
      : id = OrderID.values[json["id"] as int],
        obj = json["data"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": jsonEncode(obj),
      };
}
