//
//  BooksViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "BooksViewController.h"
#import "GSBookShelfView.h"

@class MyBelowBottomView;

typedef enum {
    BOOK_UNSELECTED,
    BOOK_SELECTED
}BookStatus;
@interface MyBookView : UIButton <GSBookView> {
    UIImageView *_checkedImageView;
}
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger index;
@end
@implementation MyBookView
@synthesize reuseIdentifier;
@synthesize selected= _selected;
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookViewChecked.png"]];
        [_checkedImageView setHidden:YES];
        [self addSubview:_checkedImageView];
        
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }return self;
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (_selected) {
        [_checkedImageView setHidden:NO];
    }else {
        [_checkedImageView setHidden:YES];
    }
}
- (void)buttonClicked:(id)sender {
    [self setSelected:_selected ? NO : YES];
}
@end
@interface MyCellView : UIView <GSBookShelfCell>
@property (nonatomic, strong) NSString *reuseIdentifier;
@end
@implementation MyCellView
@synthesize reuseIdentifier;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPW, 125)];
        [imageView setImage:[UIImage imageNamed:@"BookShelfCell"]];
        [self addSubview:imageView];
    }return self;
}
@end
@interface MyBelowBottomView : UIView
@end
@implementation MyBelowBottomView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        MyCellView *cell1 = [[MyCellView alloc] initWithFrame:CGRectMake(0, 0, APPW, 125)];
        MyCellView *cell2 = [[MyCellView alloc] initWithFrame:CGRectMake(0, 125, APPW, 125)];
        [self addSubview:cell1];
        [self addSubview:cell2];
    }
    return self;
}
@end
#define CELL_HEIGHT 125
@interface BooksViewController() <GSBookShelfViewDelegate, GSBookShelfViewDataSource>{
    GSBookShelfView *_bookShelfView;
    
    NSMutableArray *_bookArray;
    NSMutableArray *_bookStatus;
    
    NSMutableIndexSet *_booksIndexsToBeRemoved;
    
    BOOL _editMode;
    
    UIBarButtonItem *_editBarButton;
    UIBarButtonItem *_cancleBarButton;
    UIBarButtonItem *_trashBarButton;
    UIBarButtonItem *_addBarButton;
    
    MyBelowBottomView *_belowBottomView;
    UISearchBar *_searchBar;
}
@end
@implementation BooksViewController
- (void)initBooks {
    NSInteger numberOfBooks = 100;
    _bookArray = [[NSMutableArray alloc] initWithCapacity:numberOfBooks];
    _bookStatus = [[NSMutableArray alloc] initWithCapacity:numberOfBooks];
    for (int i = 0; i < numberOfBooks; i++) {
        NSNumber *number = [NSNumber numberWithInt:i];
        [_bookArray addObject:number];
        [_bookStatus addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    
    _booksIndexsToBeRemoved = [NSMutableIndexSet indexSet];
}

- (void)initBarButtons {
    _editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    _cancleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleButtonClicked:)];
    
    _trashBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonClicked:)];
    _addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
}

- (void)switchToNormalMode {
    _editMode = NO;
    self.navigationItem.rightBarButtonItems = @[_editBarButton,_addBarButton];
}

- (void)switchToEditMode {
    _editMode = YES;
    [_booksIndexsToBeRemoved removeAllIndexes];
        self.navigationItem.rightBarButtonItems = @[_cancleBarButton,_trashBarButton];
    
    for (int i = 0; i < [_bookArray count]; i++) {
        [_bookStatus addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    
    for (MyBookView *bookView in [_bookShelfView visibleBookViews]) {
        [bookView setSelected:NO];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initBarButtons];
    [self switchToNormalMode];
    [self initBooks];
    //AboveTopView *aboveTop = [[AboveTopView alloc] initWithFrame:CGRectMake(0, 0, 320, 164)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, APPW, 44)];
    _belowBottomView = [[MyBelowBottomView alloc] initWithFrame:CGRectMake(0, 0, APPW, CELL_HEIGHT * 2)];
    //MyBelowBottomView *belowBottom = [[MyBelowBottomView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT * 2)];
    _bookShelfView = [[GSBookShelfView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    [_bookShelfView setDataSource:self];
    //[_bookShelfView setShelfViewDelegate:self];
    [self.view addSubview:_bookShelfView];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [_bookShelfView setFrame:CGRectMake(0, 0, APPH, APPW)];
    }else {
        [_bookShelfView setFrame:CGRectMake(0, 0, APPW, APPH)];
    }
    [_bookShelfView reloadData];
}
#pragma mark GSBookShelfViewDataSource
- (NSInteger)numberOfBooksInBookShelfView:(GSBookShelfView *)bookShelfView {
    return [_bookArray count];
}

- (NSInteger)numberOFBooksInCellOfBookShelfView:(GSBookShelfView *)bookShelfView {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        return 4;
    }else {
        return 3;
    }
}
- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView bookViewAtIndex:(NSInteger)index {
    static NSString *identifier = @"bookView";
    MyBookView *bookView = (MyBookView *)[bookShelfView dequeueReuseableBookViewWithIdentifier:identifier];
    if (bookView == nil) {
        bookView = [[MyBookView alloc] initWithFrame:CGRectZero];
        bookView.reuseIdentifier = identifier;
        [bookView addTarget:self action:@selector(bookViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [bookView setIndex:index];
    [bookView setSelected:[(NSNumber *)[_bookStatus objectAtIndex:index] intValue]];
    int imageNO = [(NSNumber *)[_bookArray objectAtIndex:index] intValue] % 4 + 1;
    [bookView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", imageNO]] forState:UIControlStateNormal];
    return bookView;
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView cellForRow:(NSInteger)row {
    static NSString *identifier = @"cell";
    MyCellView *cellView = (MyCellView *)[bookShelfView dequeueReuseableCellViewWithIdentifier:identifier];
    if (cellView == nil) {
        cellView = [[MyCellView alloc] initWithFrame:CGRectZero];
        cellView.reuseIdentifier = identifier;
    }return cellView;
}
- (UIView *)aboveTopViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return nil;
}
- (UIView *)belowBottomViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return _belowBottomView;
}
- (UIView *)headerViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return _searchBar;
}
- (CGFloat)cellHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 125.0f;
}
- (CGFloat)cellMarginOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 20.0f;
}
- (CGFloat)bookViewHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 88.0f;
}
- (CGFloat)bookViewWidthOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 74.0f;
}
- (CGFloat)bookViewBottomOffsetOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 110.0f;
}
- (CGFloat)cellShadowHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 0.0f;
}
- (void)bookShelfView:(GSBookShelfView *)bookShelfView moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if ([(NSNumber *)[_bookStatus objectAtIndex:fromIndex] intValue] == BOOK_SELECTED) {
        [_booksIndexsToBeRemoved removeIndex:fromIndex];
        [_booksIndexsToBeRemoved addIndex:toIndex];
    }
    [_bookArray moveObjectFromIndex:fromIndex toIndex:toIndex];
    [_bookStatus moveObjectFromIndex:fromIndex toIndex:toIndex];
    MyBookView *bookView;
    bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:toIndex];
    [bookView setIndex:toIndex];
    if (fromIndex <= toIndex) {
        for (int i = fromIndex; i < toIndex; i++) {
            bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:i];
            [bookView setIndex:bookView.index - 1];
        }
    }else {
        for (int i = toIndex + 1; i <= fromIndex; i++) {
            bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:i];
            [bookView setIndex:bookView.index + 1];
        }
    }
}
#pragma mark - BarButtonListener
- (void)editButtonClicked:(id)sender {
    [self switchToEditMode];
}
- (void)cancleButtonClicked:(id)sender {
    [self switchToNormalMode];
}
- (void)trashButtonClicked:(id)sender {
    [_bookArray removeObjectsAtIndexes:_booksIndexsToBeRemoved];
    [_bookStatus removeObjectsAtIndexes:_booksIndexsToBeRemoved];
    [_bookShelfView removeBookViewsAtIndexs:_booksIndexsToBeRemoved animate:YES];
    [self switchToNormalMode];
}
- (void)addButtonClicked:(id)sender {
    int a[6] = {1, 2, 5, 7, 9, 22};
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *stat = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        [indexSet addIndex:a[i]];
        [arr addObject:[NSNumber numberWithInt:1]];
        [stat addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    [_bookArray insertObjects:arr atIndexes:indexSet];
    [_bookStatus insertObjects:stat atIndexes:indexSet];
    [_bookShelfView insertBookViewsAtIndexs:indexSet animate:YES];
}
#pragma mark - BookView Listener
- (void)bookViewClicked:(UIButton *)button {
    MyBookView *bookView = (MyBookView *)button;
    if (_editMode) {
        NSNumber *status = [NSNumber numberWithInt:bookView.selected];
        [_bookStatus replaceObjectAtIndex:bookView.index withObject:status];
        if (bookView.selected) {
            [_booksIndexsToBeRemoved addIndex:bookView.index];
        }else {
            [_booksIndexsToBeRemoved removeIndex:bookView.index];
        }
    }else {
        [bookView setSelected:NO];
        NSLog(@"点击了书本%ld",((MyBookView *)button).index);
    }
}
@end
