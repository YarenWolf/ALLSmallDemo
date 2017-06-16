//
//  RuntimeViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation NSObject(Extension)
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}
@end
@implementation NSMutableArray(Extension)
+ (void)load{
    [self swizzleInstanceMethod:NSClassFromString(@"NSMutableArray") originSelector:@selector(addObject:) otherSelector:@selector(hm_addObject:)];
    //    SEL sel1 = @selector(hm_addObject:);
    //    SEL sel2 = NSSelectorFromString(@"hm_addObject:");
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hm_objectAtIndex:)];
}
- (void)hm_addObject:(id)object{
    NSLog(@"这是没有交换的方法hm_addObject");
}
- (id)hm_objectAtIndex:(NSUInteger)index{
//    NSLog(@"这是没有交换的方法hm_objectAtIndex");
    return [self hm_objectAtIndex:index];
}
@end
@interface HMPerson : NSObject <NSCoding>{
    double height;
}
@property (nonatomic, assign) int age;
- (void)run;
@end
@interface HMPerson(){
    NSString *name;
}
@end
@implementation HMPerson
- (void)run{
    NSLog(@"run----");
}
-(void)setTheage:(int)age{
    self.age = age;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([HMPerson class], &count);
    for (int i = 0; i<count; i++) {
        // 取得i位置的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [encoder encodeObject:[self valueForKeyPath:key] forKey:key];
    }
}
@end
@interface RuntimeViewController ()
@end
@implementation RuntimeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:3];
    [names hm_addObject:@"北京"];
    NSLog(@"%@",names);
    NSLog(@"%@",[names hm_objectAtIndex:0]);
    [self testRuntimeIvar];
}

- (void)testRuntimeIvar{
    // Ivar : 成员变量
    unsigned int count = 0;
    // 获得所有的成员变量
    Ivar *ivars = class_copyIvarList([HMPerson class], &count);
    for (int i = 0; i<count; i++) {
        // 取得i位置的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"%d %s %s", i, name, type);
    }
    HMPerson *p = [[HMPerson alloc] init];
    objc_msgSend(p, @selector(setTheage:), 20);
    NSLog(@"%d", p.age);
}

@end
