import 'package:flutter/material.dart';
import 'package:tetris/borad.dart';
import 'package:tetris/values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColors[type] ?? Colors.white;
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-15, -7, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -6, -5];
        break;
      case Tetromino.I:
        position = [-35, -25, -15, -5];
        break;
      case Tetromino.O:
        position = [-4, -5, -14, -15];
        break;
      case Tetromino.S:
        position = [
          -6,
          -5,
          -15,
          -14,
        ];
        break;
      case Tetromino.Z:
        position = [-17, -16, -5, -6];
        break;
      case Tetromino.T:
        position = [-17, -16, -15, -26];
        break;
    }
  }

  void movePiect(Direction direction) {
    // print("movePiect");
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  int rotationState = 0;

//  旋转piece
  void rotatePiece() {
    // 新的索引位置
    List<int> newPosition = [];

    // 根据类型而旋转
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLength,
              position[2] + rowLength,
              position[2],
              position[2] + rowLength + 1,
            ];
            // 在将这个新位置分配给实际位置之前，检查这个新位置是否有效
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }
            break;
          case 1:
            newPosition = [
              position[2] - 1,
              position[2] - 1 + rowLength,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[2] - 1 - rowLength,
              position[2] - rowLength,
              position[2],
              position[2] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[2] - rowLength + 1,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 1 - rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 1:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 1 + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
        }
        break;
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + (rowLength * 2),
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + (rowLength * 2),
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
        }
        break;
      case Tetromino.O:
        // TODO: Handle this case.
        break;
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            print("$position");
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              print("$newPosition");
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 1:
            print("$position");
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              print("$newPosition");
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] - 1,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] - 1,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              // 更新旋转状态
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;

              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }

            break;
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
              print("rotate $rotationState");
            }
            break;
        }
        break;
    }
  }

// 检查位置是否有效
  bool positionIsValid(int position) {
    // 从位置中获取行和列
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // 如果位置已被占用返回 false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

// 检查piece的位置是否有效
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // 如果已有位置，则返回false
      if (!positionIsValid(pos)) {
        return false;
      }
      // 获取传入的piece的position的col
      int col = pos % rowLength;

      // 检查第一列或最后一列是否被占用
      // 根据旋转后的piece的position获取col值,如果该piece的两个及以上的col位于第一列和最后一列,那么就是穿过了墙
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // 如果piece位于col的第一列和最后一列,那么就会穿过墙
    print("${!(firstColOccupied && lastColOccupied)}");
    return !(firstColOccupied && lastColOccupied);
  }
}
