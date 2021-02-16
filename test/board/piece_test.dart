import "package:chess_client/src/board/rules.dart";
import "package:chess_client/src/board/piece.dart";
import "package:test/test.dart";

void main() {
  List<Point> possible(List<Point> ps) {
    var ret = List<Point>.empty(growable: true);
    for (var x = 0; x < 8; x++) {
      for (var y = 0; y < 8; y++) {
        ret.add(Point(x, y));
      }
    }

    //print("${ret.length} ${ps.length}");
    List<int> rm = [];

    ret.asMap().forEach((index, p) {
      ps.asMap().forEach((_, o) {
        if (equal(p, o)) {
          rm.add(index);
        }
      });
    });

    rm.reversed.toList(growable: false).forEach((int i) {
      ret.removeAt(i);
    });

    return ret;
  }

  test('pawn forward', () {
    const Type t = Type.pawnf;
    Point base = Point(6, 1);
    // two step movement at start
    List<Point> ps = [Point(4, 1), Point(5, 1)];
    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });
    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    ps = [Point(4, 1)];
    base = Point(5, 1);

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });
    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });

  test('pawn backward', () {
    const Type t = Type.pawnb;
    Point base = Point(1, 1);
    // two step movement at start
    List<Point> ps = [Point(2, 1), Point(3, 1)];
    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });
    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    ps = [Point(3, 1)];
    base = Point(2, 1);

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });
    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });

  test('bishop', () {
    const Point base = Point(4, 4);
    const Type t = Type.bishop;

    final List<Point> ps = [
      // normal regurssion
      Point(0, 0),
      Point(1, 1),
      Point(2, 2),
      Point(3, 3),
      //Point(4, 4),
      Point(5, 5),
      Point(6, 6),
      Point(7, 7),
      // plus minus
      Point(1, 7),
      Point(2, 6),
      Point(3, 5),
      Point(5, 3),
      Point(6, 2),
      Point(7, 1),
    ];

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });

  // 2, 1
  // 1, 2
  // both directions
  test('knight', () {
    const Point base = Point(4, 4);
    const Type t = Type.knight;

    final List<Point> ps = [
      // normal regurssion
      Point(6, 5),
      Point(6, 3),
      Point(5, 6),
      Point(5, 2),
      Point(3, 6),
      Point(3, 2),
      Point(2, 5),
      Point(2, 3),
    ];

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });

  test('rook', () {
    const Point base = Point(4, 4);
    const Type t = Type.rook;
    final List<Point> ps = [
      // normal regurssion
      Point(7, 4),
      Point(6, 4),
      Point(5, 4),
      Point(3, 4),
      Point(2, 4),
      Point(1, 4),
      Point(0, 4),

      Point(4, 7),
      Point(4, 6),
      Point(4, 5),
      Point(4, 3),
      Point(4, 2),
      Point(4, 1),
      Point(4, 0),
    ];

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });

  test('queen', () {
    const Type t = Type.queen;
    Point base = Point(4, 4);

    final List<Point> ps = [
      // square
      Point(5, 5),
      Point(5, 4),
      Point(5, 3),
      Point(4, 5),
      Point(4, 3),
      Point(5, 5),
      Point(4, 5),
      Point(3, 5),
      // horizontal
      Point(7, 4),
      Point(6, 4),
      Point(5, 4),
      Point(3, 4),
      Point(2, 4),
      Point(1, 4),
      Point(0, 4),
      // vertical
      Point(4, 7),
      Point(4, 6),
      Point(4, 5),
      Point(4, 3),
      Point(4, 2),
      Point(4, 1),
      Point(4, 0),
      // diagonal
      Point(0, 0),
      Point(1, 1),
      Point(2, 2),
      Point(3, 3),
      //Point(4, 4),
      Point(5, 5),
      Point(6, 6),
      Point(7, 7),
      // plus minus
      Point(1, 7),
      Point(2, 6),
      Point(3, 5),
      Point(5, 3),
      Point(6, 2),
      Point(7, 1),
    ];

    ps.forEach((p) {
      if (Piece(base, t, 1).canGo(p) != true) {
        print("${p.x}:${p.y}");
        expect(false, true);
      }
    });

    possible(ps).forEach((p) {
      if (Piece(base, t, 1).canGo(p) != false) {
        print("${p.x}:${p.y}");
        expect(true, false);
      }
    });
  });
}
