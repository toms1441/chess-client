import "package:chess_client/src/board/board.dart";
import 'package:chess_client/src/board/piece.dart';
import 'package:chess_client/src/model/model.dart';

// [U] refers to an Update, [C] refers to a Command.
// While [O] refers to an Update and a Command.
enum OrderID {
  Empty,
  Credentials, // [U]
  Invite, // [O]
  Game, // [U]
  Move, // [O]
  Turn, // [U]
  Promote, // [C]
  Promotion, // [U]
  Castling, // [O]
  Checkmate, // [U]
  // Message, // Deprecated
  Done, // [O]
  Disconnect, // Not actually an order, but more so to inform other components that the connection has been closed
}

class Order {
  final OrderID id;
  final dynamic obj;

  Order(this.id, this.obj);

  Order.fromJson(Map<String, dynamic> json)
      : id = OrderID.values[json["id"] as int],
        obj = json["data"];

  Map<String, dynamic> toJson() {
    return {
      "id": id.index,
      "data": obj.toJson != null ? obj.toJson() : obj,
    };
  }
}

class Credentials {
  final String token;
  final Profile profile;

  const Credentials(this.token, this.profile);

  Credentials.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        profile = Profile.fromJson(json["profile"]);
}

class Invite {
  // it's a variable cause it's easier to test
  static const expiry = Duration(seconds: 30);
  final Profile profile;

  const Invite(this.profile);

  Invite.fromJson(Map<String, dynamic> json)
      : profile = Profile.fromJson(json["profile"]);

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
      };
}

class Game {
  final Board brd;
  final Profile profile;
  final bool p1;

  const Game(this.brd, this.profile, this.p1);

  Game.fromJson(Map<String, dynamic> json)
      : brd = Board.fromJson(json["brd"]),
        p1 = json["p1"],
        profile =
            json["profile"] != null ? Profile.fromJson(json["profile"]) : null;
}

class Move {
  final int id;
  final Point dst;

  const Move(this.id, this.dst);

  Move.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dst = Point.fromJson(json["dst"] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "id": id,
        "dst": dst.toJson(),
      };
}

class Turn {
  final bool p1;
  const Turn(this.p1);

  Turn.fromJson(Map<String, dynamic> json) : p1 = json["p1"];
}

class Promotion {
  final int id;
  final int kind;

  const Promotion(this.id, this.kind);

  Promotion.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        kind = json["kind"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "kind": kind,
      };
}

class Promote {
  final int kind;
  final int id;

  Promote(this.id, this.kind);

  Promote.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        kind = json["kind"] as int;

  Map<String, dynamic> toJson() => {
        "id": id,
        "kind": kind,
      };
}

class Castling {
  final int src;
  final int dst;

  const Castling(this.src, this.dst);

  Castling.fromJson(Map<String, dynamic> json)
      : src = json["src"],
        dst = json["dst"];

  Map<String, dynamic> toJson() => {
        "src": src,
        "dst": dst,
      };
}

class DoneReason {
  static const whiteWon = 1;
  static const blackWon = 2;
  // lamo im not gonna use this
  static const stalemate = 3;
  static const whiteForfeit = 4;
  static const blackForfeit = 5;
  static const spectatorLeft = 6;

  static String getString(int result, bool p1) {
    if (result == 1 || result == 2) {
      final won = result == 1 ? true : false;

      if (won == p1)
        return "You won";
      else
        return "You lost";
    } else {
      final str = name[result];
      return str != null ? str : "undefined behaivour";
    }
  }

  static const name = <int, String>{
    whiteWon: "White won",
    blackWon: "Black won",
    stalemate: "Stalemate",
    whiteForfeit: "White Forfeits",
    blackForfeit: "Black Forfeits",
  };
}

class Done {
  final int reason;

  Done(this.reason);

  Done.fromJson(Map<String, dynamic> json) : reason = json["reason"];

  String toString() => DoneReason.name[reason];

  Map<String, dynamic> toJson() => {
        "reason": reason,
      };
}
