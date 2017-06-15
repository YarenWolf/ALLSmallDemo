//
//  S2LWorldRadiantMenu.h
//  snap2life4.0
//
//  Created by iOS on 26.05.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>
@class ASRadialSelectionView;
@protocol ASRadialSelectionViewDelegate <NSObject>
-(void)close:(ASRadialSelectionView*)view;
@end
#define UIRandomColor [UIColor colorWithRed:(float)(arc4random()%122 /255.0)+0.5 green:(float)(arc4random()%122 /255.0)+0.5 blue:(float)(arc4random()%122 /255.0)+0.5 alpha:1.0]
@interface ASRadialSelectionView : UIView{
    UIImageView *check;
}
@property (nonatomic,strong) UIColor *randomColor;
@property (nonatomic,weak) id<ASRadialSelectionViewDelegate> delegate;
@property (nonatomic) BOOL isSelected;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *downloadBtn;
- (id)initWithFrame:(CGRect)frame andText:(NSString*)_label;
@end
@class ASRadialSelectionView;
#define kASDimension 60
#define kASScalefactor 1
#define kASMAXRadius 200
#define kASMINRadius 0
@protocol ASRadialMenuDelegate <NSObject>
@optional
-(void)closeRadialMenu:(ASRadialSelectionView*)view;
@end
@interface ASRadialMenu : UIView <ASRadialSelectionViewDelegate>{
    CGFloat swipeRotationValue;
    CGFloat frictionAngle;
    CGFloat radius;
    ASRadialSelectionView *selectedView;
    CGPoint startLocation;
    CGPoint endLocation;
}
@property (nonatomic,weak) id<ASRadialMenuDelegate> delegate;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (nonatomic,strong) NSArray *items;
-(void)open;
-(void)close;
@end
