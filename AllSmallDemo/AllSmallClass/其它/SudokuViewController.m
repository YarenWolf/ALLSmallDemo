//
//  SudokuViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "SudokuViewController.h"
#import <Foundation/Foundation.h>
typedef int (*BoardType)[9];
typedef int (*BoardCellType);
@interface SdkpBoard : NSObject <NSCopying>
@property (nonatomic, readonly) BoardType board;
- (void)setX:(int)x andY:(int)y withValue:(int)value;
- (BOOL)checkX:(int)x andY:(int)y;
- (void)show;
@end
@interface SdkpBoard ()
@end
@implementation SdkpBoard
- (void)setX:(int)x andY:(int)y withValue:(int)value {
    if (value >= 0 && value <= 9) {
        self.board[x][y] = value;
    }
}
- (id)copyWithZone:(NSZone *)zone {
    SdkpBoard *cBoard = [[SdkpBoard alloc] init];
    cBoard && memcpy(cBoard.board, self.board, sizeof(int) * 81);
    return cBoard;
}

@synthesize board = _board;
- (BoardType)board {
    if (!_board) {
        _board = calloc(81, sizeof(int));
    }return _board;
}
- (BOOL)checkX:(int)x andY:(int)y {
    //row
    int draftX[10] = {0};
    //column
    int draftY[10] = {0};
    //block
    int draftB[10] = {0};
    int tmpX;
    int tmpY;
    int tmpB;
    for (int i = 0; i < 9; ++i) {
        tmpX = self.board[x][i];
        if (tmpX > 0) {
            if (++draftX[tmpX] > 1) return NO;
        }
        tmpY = self.board[i][y];
        if (tmpY > 0) {
            if (++draftY[tmpY] > 1) return NO;
        }
    }
    int bx = x / 3;
    int by = y / 3;
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            tmpB = self.board[3 * bx + i][3 * by + j];
            if (tmpB > 0) {
                if (++draftB[tmpB] > 1) return NO;
            }
        }
    }
    return YES;
}

- (void)show {
    BoardType ppb = self.board;
    for (int i = 0; i < 9; ++i) {
        int *pb = ppb[i];
        for (int j = 0; j < 9; ++j) {
            printf("%d ", pb[j]);
        }
        printf("\n");
    }
}
- (void)dealloc {
    if (_board) {
        free(_board);
    }
}
@end
@interface SdkpGame : NSObject
@property (nonatomic, getter=isSolved, readonly) BOOL solved;
- (void)solve;
- (void)show;
- (void)showPuzzle;
- (void)showAnswer;
- (void)showPlayer;
@end
@interface SdkpGame ()
@property (nonatomic, strong) SdkpBoard *boardPuzzle;
@property (nonatomic, strong) SdkpBoard *boardAnswer;
@property (nonatomic, strong) SdkpBoard *boardPlayer;
@end
@implementation SdkpGame
- (instancetype)init {
    if (self = [super init]) {
        [self gen];
    }return self;
}
/**
 * @method
 * 随机赋值
 */
- (void)gen {
    int value = 1;
    for (int i = 0; i < 9; ++i) {
        int x = arc4random() % 9 + 1;
        int y = arc4random() % 9 + 1;
        [self.boardPuzzle setX:x andY:y withValue:value++];
    }
}

- (int)numToSolve {
    BoardCellType boardPuzzle = (BoardCellType)self.boardPuzzle.board;
    int count = 0;
    for (int i = 0; i < 81; i++) {
        if (boardPuzzle[i] == 0) {
            ++count;
        }
    }return count;
}
- (void)solve {
    int numToSolve = [self numToSolve];
    int numLeftToSolve = numToSolve;
    if (numLeftToSolve <= 0) return;
    int draft[81] = {0};
    //    NSLog(@"numToSolve:%d", numToSolve);
    SdkpBoard *boardPuzzle = self.boardPuzzle;
    SdkpBoard *boardAnswer = self.boardAnswer;
    const BoardCellType kppPuzzle = (BoardCellType)boardPuzzle.board;
    const BoardCellType kppAnswer = (BoardCellType)boardAnswer.board;
    //    BoardCellType ppPuzzle = kppPuzzle;
    BoardCellType ppAnswer = kppAnswer;
    BOOL right = YES;
    while (YES) {
        if (0 < numLeftToSolve && numLeftToSolve <= numToSolve) {
            //            NSLog(@"numLeftToSolve:%d", numLeftToSolve);
            if (right) {
                // right >>>
                while (*(ppAnswer - kppAnswer + kppPuzzle) != 0) {
                    ppAnswer++;
                }
            } else {
                // left <<<
                while (*(ppAnswer - kppAnswer + kppPuzzle) != 0) {
                    ppAnswer--;
                }
            }
            // position found
        checkAgain:
            //            [self showAnswer];
            if (draft[ppAnswer - kppAnswer] >= 9) {
                right = NO;
                draft[ppAnswer - kppAnswer] = 0;
                *ppAnswer = 0;
                ++numLeftToSolve;
                --ppAnswer;
                //                continue;
            } else {
                right = YES;
                *ppAnswer = ++draft[ppAnswer - kppAnswer];
                int pos = (int)(ppAnswer - kppAnswer);
                int x = pos / 9;
                int y = pos % 9;
                if ([self.boardAnswer checkX:x andY:y]) {
                    // next loop
                    --numLeftToSolve;
                    ++ppAnswer;
                    if (numLeftToSolve == 0) {
                        _solved = YES;
                    }
//                    continue;
                } else {
                    goto checkAgain;
                }
            }
        } else {
            break;
            //            // more answer
            //            if (NO) {
            //                right = NO;
            //                draft[ppAnswer - kppAnswer] = 0;
            //                ++numLeftToSolve;
            //                continue;
            //            }
        }
    }
}

- (SdkpBoard *)boardPuzzle {
    if (!_boardPuzzle) {
        _boardPuzzle = [[SdkpBoard alloc] init];
    }
    return _boardPuzzle;
}
- (SdkpBoard *)boardPlayer {
    if (!_boardPlayer) {
        _boardPlayer = [self.boardPuzzle copy];
    }
    return _boardPlayer;
}
- (SdkpBoard *)boardAnswer {
    if (!_boardAnswer) {
        _boardAnswer = [self.boardPuzzle copy];
    }return _boardAnswer;
}

- (void)showPuzzle {
    NSLog(@"boardPuzzle:");
    [self.boardPuzzle show];
}
- (void)showPlayer {
    NSLog(@"boardPlayer:");
    [self.boardPlayer show];
}
- (void)showAnswer {
    //    if (self.isSolved) {
    NSLog(@"boardAnswer:");
    [self.boardAnswer show];
    //    }
}
- (void)show {
    [self showPuzzle];
    [self showPlayer];
    [self showAnswer];
}
@end
@interface SudokuViewController ()
@end
@implementation SudokuViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SdkpGame *game = [[SdkpGame alloc] init];
    [game solve];
    [game show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}

@end
