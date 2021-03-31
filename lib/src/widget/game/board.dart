import 'package:chess_client/src/board/board.dart';
import 'package:chess_client/src/board/generator.dart';
import 'package:chess_client/src/board/piece.dart';
import 'package:flutter/material.dart';

String numToString(int i) {
  switch (i) {
    case 1:
      return "A";
    case 2:
      return "B";
    case 3:
      return "C";
    case 4:
      return "D";
    case 5:
      return "E";
    case 6:
      return "F";
    case 7:
      return "G";
    case 8:
      return "H";
  }

  return "";
}

class _BoardState extends State<BoardWidget> {
  static final Color pri = Colors.white;
  static final Color sec = Colors.grey[400];

  static final double indexSizeDivider = 7;
  static final double indexPadding = 2.5;

  List<Point> _points = List<Point>.empty(growable: true);

  // which piece we're focused at
  // basically which square has the purple background
  Point focus;

  Color getBackground(Point pnt) {
    final x = pnt.x;
    final y = pnt.y;

    Color pri = _BoardState.pri;
    Color sec = _BoardState.sec;
    if ((x % 2) == 0) {
      pri = _BoardState.sec;
      sec = _BoardState.pri;
    }

    final clr = (y % 2) == 0 ? sec : pri;
    return clr;
  }

  void _setPoints() async {
    if (focus != null && widget.possib != null) {
      widget.possib(focus).then((_value) {
        setState(() {
          _points = _value;
        });
      }).catchError((e) {
        print("possib $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brd = widget.board;

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.height - 120,
        ),
        child: Container(
            color: Colors.white12,
            margin: const EdgeInsets.all(20),
            child: Center(
              child: GridView.builder(
                itemCount: 8 * 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  Point pnt = Point.fromIndex(index);

                  final orix = pnt.x;
                  final oriy = pnt.y;

                  if (widget.reverse) {
                    final x = 7 - pnt.x;
                    final y = 7 - pnt.y;

                    pnt = Point(x.abs(), y);
                  }

                  Piece pce;
                  if (brd != null) {
                    pce = brd.get(pnt);
                  }

                  return GestureDetector(
                    onTap: () {
                      if (widget.board.canResetHistory()) {
                        widget.board.resetHistory();
                        setState(() {
                          focus = null;
                        });
                        return;
                      }

                      if (widget.ourTurn()) {
                        if (focus == null) {
                          if (pce != null) {
                            if (widget.canFocus(pce)) {
                              setState(() {
                                focus = pnt;
                                _setPoints();
                              });
                            }
                          }
                        } else {
                          final doMovement = () {
                            widget.move(focus, pnt);

                            setState(() {
                              _points.clear();
                              focus = null;
                            });
                          };

                          if (pce != null) {
                            final ecp = brd.get(focus);
                            // well if we select an ally
                            // then shift focus to that piece
                            if (ecp.num == pce.num) {
                              if ((pce.t == PieceKind.king &&
                                      ecp.t == PieceKind.rook) ||
                                  (pce.t == PieceKind.rook &&
                                      ecp.t == PieceKind.king)) {
                                doMovement();
                              } else {
                                setState(() {
                                  focus = pnt;
                                  _setPoints();
                                });
                              }
                            } else {
                              // if it's an enemy then sure do the move
                              doMovement();
                            }
                          } else {
                            // movement to an empty square
                            doMovement();
                          }
                        }
                      }
                    },
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) =>
                              Container(
                        color: (focus != null && pnt.equal(focus))
                            ? Theme.of(context).primaryColor
                            : getBackground(pnt),
                        child: Stack(
                          children: <Widget>[
                            if (oriy == 0)
                              // number of square, 1 through 8
                              // drawn horizontally
                              Container(
                                child: Text(
                                  "${(!widget.reverse ? 8 - orix : orix + 1).abs()}",
                                  style: TextStyle(
                                    fontSize:
                                        constraints.maxWidth / indexSizeDivider,
                                  ),
                                ),
                                padding: EdgeInsets.only(left: indexPadding),
                              ),
                            if (orix == 7)
                              // letter of square, a through h
                              // drawn vertically
                              Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Container(
                                  child: Text(
                                    "${numToString((widget.reverse ? 8 - oriy : oriy + 1).abs())}",
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth /
                                          indexSizeDivider,
                                    ),
                                  ),
                                ),
                              ),
                            if (pce != null)
                              Center(
                                child: Image.asset(
                                  pce.filename(),
                                  width: constraints.maxWidth - 10,
                                  height: constraints.maxHeight - 10,
                                ),
                              ),
                            if (_points.exists(pnt))
                              Center(
                                  child: Container(
                                width: constraints.maxWidth / 2,
                                height: constraints.maxHeight / 2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.54),
                                  shape: BoxShape.circle,
                                ),
                              )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )));
  }
}

class BoardWidget extends StatefulWidget {
  final Board board;
  final Future<void> Function(Point src, Point dst) move;
  final bool Function() ourTurn;
  final bool Function(Piece) canFocus; // disallow selecting enemy pieces
  final bool reverse;
  final Future<List<Point>> Function(Point) possib;

  BoardWidget(this.board, this.move, this.ourTurn, this.canFocus,
      {Key key, this.reverse = false, this.possib})
      : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}