
#import <UIKit/UIKit.h>
@protocol GSBookShelfCell <NSObject>
@property (nonatomic, strong) NSString *reuseIdentifier;
@end
@protocol GSBookView <NSObject>
@property (nonatomic, strong) NSString *reuseIdentifier;
@end
@interface NSMutableArray (Rearrange)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
@implementation NSMutableArray (Rearrange)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex != toIndex) {
        id __strong obj = [self objectAtIndex:fromIndex];
        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count]) {
            [self addObject:obj];
        }else {
            [self insertObject:obj atIndex:toIndex];
        }
    }
}
@end
@class GSBookViewContainerView;
@class GSCellContainerView;
@protocol GSBookShelfViewDelegate;
@protocol GSBookShelfViewDataSource;
@interface GSBookShelfView : UIScrollView {
@private
    id<GSBookShelfViewDataSource> __unsafe_unretained _dataSource;
    GSBookViewContainerView *_bookViewContainerView;
    GSCellContainerView *_cellContainerView;
    UIView *_headerView;
    UIView *_aboveTopView;
    UIView *_belowBottomView;
    BOOL _dragAndDropEnabled;
    BOOL _scrollWhileDragingEnabled;
    CGFloat _cellHeight;
    CGFloat _cellMargin;
    CGFloat _bookViewBottomOffset;
    CGFloat _shelfShadowHeight;
    NSInteger _numberOfBooksInCell;
}
@property (nonatomic, unsafe_unretained) id<GSBookShelfViewDataSource> dataSource;
@property (nonatomic, readonly) UIView *headerView;
@property (nonatomic, readonly) UIView *aboveTopView;
@property (nonatomic, readonly) UIView *belowBottomView;
@property (nonatomic, readonly) BOOL dragAndDropEnabled;
@property (nonatomic, assign) BOOL scrollWhileDragingEnabled;
@property (nonatomic, readonly) CGFloat cellHeight; // height of each cell
@property (nonatomic, readonly) CGFloat cellMargin; // margin of cell where to display the first book
@property (nonatomic, readonly) CGFloat bookViewBottomOffset;
@property (nonatomic, readonly) CGFloat shelfShadowHeight;
@property (nonatomic, readonly) NSInteger numberOfBooksInCell;
- (UIView *)dequeueReuseableBookViewWithIdentifier:(NSString *)identifier;
- (UIView *)dequeueReuseableCellViewWithIdentifier:(NSString *)identifier;
- (NSArray *)visibleBookViews;
- (NSArray *)visibleCells;
- (UIView *)bookViewAtIndex:(NSInteger)index;
- (UIView *)cellAtRow:(NSInteger)row;
//- (UIView *)bookViewAtIndex:(NSInteger)index;
//- (UIView *)cellAtIndex:(NSInteger)index;
- (void)reloadData;
- (void)removeBookViewsAtIndexs:(NSIndexSet *)indexs animate:(BOOL)animate;
- (void)insertBookViewsAtIndexs:(NSIndexSet *)indexs animate:(BOOL)animate;
@end

@protocol GSBookShelfViewDataSource <NSObject>

- (NSInteger)numberOfBooksInBookShelfView:(GSBookShelfView *)bookShelfView; // Total number of Books
- (NSInteger)numberOFBooksInCellOfBookShelfView:(GSBookShelfView *)bookShelfView; // Number of books in each cell

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView bookViewAtIndex:(NSInteger)index;
- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView cellForRow:(NSInteger)row;

- (UIView *)aboveTopViewOfBookShelfView:(GSBookShelfView *)bookShelfView; //
- (UIView *)belowBottomViewOfBookShelfView:(GSBookShelfView *)bookShelfView; // View tha will be shown when you drag up |
- (UIView *)headerViewOfBookShelfView:(GSBookShelfView *)bookShelfView; // This view will be shown above the first cell.
- (CGFloat)cellHeightOfBookShelfView:(GSBookShelfView *)bookShelfView;
- (CGFloat)cellMarginOfBookShelfView:(GSBookShelfView *)bookShelfView;
- (CGFloat)bookViewHeightOfBookShelfView:(GSBookShelfView *)bookShelfView;
- (CGFloat)bookViewWidthOfBookShelfView:(GSBookShelfView *)bookShelfView;
- (CGFloat)bookViewBottomOffsetOfBookShelfView:(GSBookShelfView *)bookShelfView;
- (CGFloat)cellShadowHeightOfBookShelfView:(GSBookShelfView *)bookShelfView;
@optional
- (void)bookShelfView:(GSBookShelfView *)bookShelfView moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@end
@protocol GSBookShelfViewDelegate <NSObject>
@end
