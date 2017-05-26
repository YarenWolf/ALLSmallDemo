//
//  TQMultistageTableView.h
//  TQMultistageTableView
#import <UIKit/UIKit.h>
#ifndef TQ_STRONG
#if __has_feature(objc_arc)
#define TQ_STRONG strong
#else
#define TQ_STRONG retain
#endif
#endif
#ifndef TQ_WEAK
#if __has_feature(objc_arc_weak)
#define TQ_WEAK weak
#elif __has_feature(objc_arc)
#define TQ_WEAK unsafe_unretained
#else
#define TQ_WEAK assign
#endif
#endif
#if __has_feature(objc_arc)
#define TQ_AUTORELEASE(exp) exp
#define TQ_RELEASE(exp) exp
#define TQ_RETAIN(exp) exp
#else
#define TQ_AUTORELEASE(exp) [exp autorelease]
#define TQ_RELEASE(exp) [exp release]
#define TQ_RETAIN(exp) [exp retain]
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MBLabelAlignmentCenter NSTextAlignmentCenter
#else
#define MBLabelAlignmentCenter UITextAlignmentCenter
#endif
@class ThirdListTableView;
#define DEFULT_HEIGHT_FOR_ROW 50.0f
@protocol ThirdListTableViewDelegate <NSObject>
@required
- (NSInteger)mTableView:(ThirdListTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)mTableView:(ThirdListTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfSectionsInTableView:(ThirdListTableView *)tableView;
- (UIView *)mTableView:(ThirdListTableView *)tableView openCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)mTableView:(ThirdListTableView *)tableView viewForHeaderInSection:(NSInteger)section;
//header点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectHeaderAtSection:(NSInteger)section;
//celll点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//header展开
- (void)mTableView:(ThirdListTableView *)tableView willOpenHeaderAtSection:(NSInteger)section;
//header关闭
- (void)mTableView:(ThirdListTableView *)tableView willCloseHeaderAtSection:(NSInteger)section;
//cell展开
- (void)mTableView:(ThirdListTableView *)tableView willOpenCellAtIndexPath:(NSIndexPath *)indexPath;
//cell关闭
- (void)mTableView:(ThirdListTableView *)tableView willCloseCellAtIndexPath:(NSIndexPath *)indexPath;
//celll详情点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectOpenCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ThirdListTableView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,TQ_WEAK) id <ThirdListTableViewDelegate>   delegate;
@property (nonatomic,TQ_STRONG) UITableView *tableView;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)openCellViewWithIndexPath:(NSIndexPath *)indexPath;
- (void)openOrCloseHeaderWithSection:(int)section;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadDataWithTableViewCell:(UITableViewCell *)cell;
- (void)reloadData;
- (void)updateTableView;
- (bool)isOpenCellWithIndexPath:(NSIndexPath *)indexPath;
@end
