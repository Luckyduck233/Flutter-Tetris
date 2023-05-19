import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

//这是一个2x2的网格，null代表空白区域，非空白区域的颜色代表落地的棋子
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // grid dimensions
  int rowLength = 10;
  int colLength = 15;

  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.T);



//  游戏是否进行中
  bool isGaming = false;

//  游戏分数
  int currentScore = 0;

//  游戏是否结束
  bool gameOver = false;

//  游戏是否中途暂停
//   bool isGamePauseMiddle = false;
  int isGamePauseMiddle = 0;

//  计时器
  late Timer timer;

  // 帧刷新率
  Duration frameRate = Duration(milliseconds: 600);

  @override
  void initState() {
    //这是一个2x2的网格，null代表空白区域，非空白区域的颜色代表落地的棋子
    // startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    isGaming = true;
    gameLoop(frameRate);
  }

  void gameStart() {
    gameLoop(frameRate);
    // setState(() {
    //   isGamePauseMiddle = false;
    // });
  }

  //  游戏暂停
  void gamePause() {
    setState(() {
      timer.cancel();
      // isGamePauseMiddle = true;
    });
  }

  // 游戏结束判断
  ///
  /// 对游戏板的第一行循环遍历是否有不为空的格子，如果有则游戏结束 返回true，无则返回false
  bool isGameOver() {
    // 检查顶部row的任col是否已填充
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  void pauseOrStartGame() {
    setState(() {
      if (isGamePauseMiddle == 0) {
        resetGame();
      } else if (isGamePauseMiddle.isOdd) {
        gamePause(); //isGamePauseMiddle = true
      } else {
        gameStart(); //isGamePauseMiddle = false
      }
      isGamePauseMiddle += 1;
    });
  }

  // void pauseOrStartGame() {
  //   setState(() {
  //     if (isGaming && !isGamePauseMiddle) {
  //       print("pause");
  //       gamePause(); //isGamePauseMiddle = true;
  //     } else {
  //       print("start");
  //       if (isGamePauseMiddle) {
  //         gameStart();
  //         isGamePauseMiddle = true;
  //       } else {
  //         startGame();
  //       }
  //     }
  //   });
  // }

//  游戏开始循环
  void gameLoop(Duration frameRate) {
    timer = Timer.periodic(
      frameRate,
      (t) {
        setState(
          () {
            // piece下降前检查是否能清空某行row
            // 尝试for循环
            clearLines();

            // 检查着陆 bool
            // true则调用createNewPiece()
            // createNewPiece()会判断是否gameover

            checkLanding();

            // 检查游戏是否结束
            if (gameOver) {
              timer.cancel();
              isGamePauseMiddle = 0;
              // showGameOverDialog()内有个点击事件，这个点击事件会调用resetGame()方法
              showGameOverDialog();
            }
            currentPiece.movePiect(Direction.down);
          },
        );
      },
    );
  }

//  游戏结束提示框
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("游戏结束"),
          content: Text("分数：$currentScore"),
          actions: [
            TextButton(
                onPressed: () {
                  clearGameBoard();
                  Navigator.pop(context);
                },
                child: Text("重玩"))
          ],
        );
      },
    );
  }

  /// 清除游戏格子
  void clearGameBoard() {
    // 清除游戏格子
    gameBoard = List.generate(
      colLength,
      (index) => List.generate(
        rowLength,
        (index) => null,
      ),
    );
  }

//  碰撞检测 bool
  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      // 计算出行和列的值
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // 根据方向对行和列进行计算
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= colLength) {
        return true;
      }

      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  /// 检测是否着陆
  /// 先使用 checkCollision() 方法检测是否有发生碰撞，发生碰撞后获取该piece的position值，
  /// 对piece的position值进行for循环遍历获取每个position位于的行和列，再对游戏板上对于的行和列进行赋值，这个值就是该piece的类型。
  /// 因为每个piece的颜色是根据类型而决定的
  ///
  /// 在着陆后调用 createNewPiece() 方法
  void checkLanding() {
    if (checkCollision(Direction.down)) {
      // 标记该格子为已占用
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = (currentPiece.position[i]) % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      // 一旦落地，就创建下一个piece
      createNewPiece();
    }
  }

  /// 创建一个新方块的步骤为：
  ///
  /// 1.随机获取枚举Tetromino中的一种类型
  ///
  /// 2.将随机获取的类型创建一个新的Piece并赋给 变量currentPiece
  ///
  /// 3.步骤2之后判断游戏是否结束/失败
  void createNewPiece() {
    print("createNewPiece");
    Random random = Random();
    // 随机生成一种piece类型
    Tetromino randomType =
        Tetromino.values[random.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  void resetGame() {
    clearGameBoard();

    setState(() {
      gameOver = false;

      isGamePauseMiddle = 0;

      currentScore = 0;
    });

    createNewPiece();

    startGame();
  }

//  清除完成的线条
  void clearLines() {
    // 步骤1:从上到下遍历游戏板的每一行
    for (int row = colLength - 1; row >= 0; row--) {
      // 步骤2: 初始化变量,循环 row 是否已满
      bool rowIsFull = true;

      //步骤3：检查row是否都满了(即row中的每个col是否都不为空)
      for (int col = 0; col < rowLength; col++) {
        // 如果有一个空的,将 rowIsFull设为false并直接打断循环
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      // 步骤4：如果row满了，清除这一行并使所有行向下移动一行
      if (rowIsFull) {
        // 步骤5：将被清除row上方所有的row向下移动一个位置
        for (int r = row; r > 0; r--) {
          // 将上面的行复制到当前行
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        // 步骤6：将第一行设为空
        gameBoard[0] = List.generate(rowLength, (index) => null);

        currentScore += 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var gridKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: currentScore == 0 ? Text("俄罗斯方块") : Text("分数：$currentScore"),
        centerTitle: true,
        actions: [
          isGamePauseMiddle.isOdd
              ? IconButton(
                  onPressed: () {
                    pauseOrStartGame();
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text("游戏已暂停"),
                            content: Text("当前分数为：$currentScore"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    gameStart();
                                    Navigator.pop(context);
                                    setState(() {
                                      isGamePauseMiddle += 1;
                                    });
                                  },
                                  child: Text("继续")),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.pause),
                )
              : IconButton(
                  onPressed: () {
                    pauseOrStartGame();
                  },
                  icon: Icon(Icons.play_arrow),
                ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                key: gridKey,
                physics: BouncingScrollPhysics(),
                itemCount: rowLength * colLength,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (BuildContext context, int index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;
                  if (gameBoard[row][col] != null) {}
                  if (currentPiece.position.contains(index)) {
                    return Pixel(color: currentPiece.color, int: "");
                  } else if (gameBoard[row][col] != null) {
                    Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                        color: tetrominoColors[tetrominoType], int: "");
                  } else {
                    return Pixel(color: Colors.grey[800], int: "");
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Container(
                  color: Colors.red,
                  child: IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: (){
                      quicklyFall();
                    },
                  ),
                ),),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: MaterialButton(
                          color: Colors.blue,
                          onPressed: moveLeft,
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 64,
                      child: MaterialButton(
                          color: Colors.yellow,
                          onPressed: rotatePiece,
                          child: Icon(Icons.rotate_right, color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: MaterialButton(
                          color: Colors.blue,
                          onPressed: moveRight,
                          child:
                              Icon(Icons.arrow_forward, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiect(Direction.left);
        // print("moveLeft");
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiect(Direction.right);
        // print("moveRight");
      });
    }
  }

  void quicklyFall(){
    checkLanding();

    // 检查游戏是否结束
    if (gameOver) {
      timer.cancel();
      isGamePauseMiddle = 0;
      // showGameOverDialog()内有个点击事件，这个点击事件会调用resetGame()方法
      showGameOverDialog();
    }else {
      currentPiece.movePiect(Direction.down);
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }
}

// Column(
// children: [
// Expanded(
// child: GridView.builder(
// key: gridKey,
// physics: BouncingScrollPhysics(),
// itemCount: rowLength * colLength,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: rowLength),
// itemBuilder: (BuildContext context, int index) {
// // print("$index");
// // print(currentPiece.position);
//
// int row = (index / rowLength).floor();
// int col = index % rowLength;
// if (gameBoard[row][col] != null) {}
// if (currentPiece.position.contains(index)) {
// return Pixel(color: currentPiece.color, int: "");
// } else if (gameBoard[row][col] != null) {
// Tetromino? tetrominoType = gameBoard[row][col];
// return Pixel(
// color: tetrominoColors[tetrominoType], int: "");
// } else {
// return Pixel(color: Colors.grey[800], int: "");
// }
// },
// ),
// ),
// Padding(
// padding: EdgeInsets.only(bottom: 24),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// Expanded(
// child: MaterialButton(
// color: Colors.blue,
// onPressed: moveLeft,
// child: Icon(Icons.arrow_back, color: Colors.white)),
// ),
// Expanded(
// child: MaterialButton(
// color: Colors.yellow,
// onPressed: rotatePiece,
// child: Icon(Icons.rotate_right, color: Colors.white)),
// ),
// Expanded(
// child: MaterialButton(
// color: Colors.blue,
// onPressed: moveRight,
// child: Icon(Icons.arrow_forward, color: Colors.white)),
// ),
// ],
// ),
// ),
// ],
// )
