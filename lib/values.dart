// grid dimensions
import 'dart:ui';

import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;


enum Direction {
  down,
  left,
  right,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}
//
// o
// o
// o o
//

//   o
//   o
// o o
//

//   o
//   o
//   o
//   o
//

//     o o
//     o o
//

//     o o
//   o o
//

//   o o
//     o o
//

//   o o o
//     o
//     o

const Map<Tetromino,Color> tetrominoColors={
 Tetromino.L: Colors.orange,
 Tetromino.J: Colors.blue,
 Tetromino.I: Colors.pink,
 Tetromino.O: Colors.yellow ,
 Tetromino.S: Colors.green ,
 Tetromino.Z: Colors.red ,
 Tetromino.T: Colors.purple,
};