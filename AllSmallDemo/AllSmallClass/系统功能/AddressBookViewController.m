
//
//  AddressBookViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AddressBookViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@implementation AddressBookViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断是否授权成功
    if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        return;
    }
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"授权成功");
        }else{
            NSLog(@"授权失败");
        }
    });
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    ABPeoplePickerNavigationController *vc = [[ABPeoplePickerNavigationController alloc] init];
    vc.peoplePickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
// 在iOS7时 点击cancle按钮时候就会调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    NSLog(@"%s", __func__);
    // 关闭通讯录
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
//  在iOS7时 , 选中某一个联系人就会调用
// 返回一个BOOL值, 如果返回NO, 代表不会进入下一层(详情), 如果返回YES,代表会进入下一层
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    NSLog(@"%s", __func__);
     //取出当前联系人的的电话信息
     // 获取练习人得姓名
     CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
     CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
     NSLog(@"%@ %@", firstName, lastName);
     ABMultiValueRef phones =   ABRecordCopyValue(person, kABPersonPhoneProperty);
     CFIndex phoneCount = ABMultiValueGetCount(phones);
     for (int i = 0; i < phoneCount; i++) {
     CFStringRef name = ABMultiValueCopyLabelAtIndex(phones, i);
     CFStringRef value =  ABMultiValueCopyValueAtIndex(phones, i);
     NSLog(@"name = %@ value = %@", name, value);
     }
    return YES;
}
//  在iOS7时 , 选中某一个联系人的某一个属性时就会调用
// 返回一个BOOL值, 如果返回NO, 代表不会进行下一步操作(打电话, 打开日历....), 如果返回YES,代表会进行下一步操作
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSLog(@"%s", __func__);
    return YES;
}
//  iOS8选中某一个联系人就会调用
#warning 只要实现了这个方法, 就不会进行下一步操作(进入详情), iOS8的做法是默认返回NO
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    NSLog(@"%s", __func__);
}
// iOS8选中某一个联系人的某一个属性时就会调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSLog(@"%s", __func__);
}


#pragma mark 其他方法
// 读取练习人信息
- (void)readRecord{
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        return; // 授权失败直接返回
    }
    // 1.创建通讯录对象
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(book);
    CFIndex count = CFArrayGetCount(allPeople);
    // 3.打印每一个联系人的信息
    for (int i = 0; i < count; i++) {
        ABRecordRef prople =  CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef lastName = ABRecordCopyValue(prople, kABPersonLastNameProperty);
        CFStringRef firstName = ABRecordCopyValue(prople, kABPersonFirstNameProperty);
        NSLog(@"%@ %@", firstName, lastName);
        ABMultiValueRef phones =   ABRecordCopyValue(prople, kABPersonPhoneProperty);
        // 获取当前联系人总共有多少种电话
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (int i = 0; i < phoneCount; i++) {
            CFStringRef name = ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef value =  ABMultiValueCopyValueAtIndex(phones, i);
            NSLog(@"name = %@ value = %@", name, value);
        }
    }
}

// 更新联系人
- (void)updateRecord{
    // 判断是否授权成功
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){return;}
    // 1.创建通讯录对象
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    // 2.获取通讯录中得所有联系人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(book);
    // 3.取出其中的一个联系人
    ABRecordRef people = CFArrayGetValueAtIndex(allPeople, 0);
    // 4.修改联系人信息
    ABRecordSetValue(people, kABPersonLastNameProperty, @"牛", NULL);
    // 5.保存修改之后的信息
    ABAddressBookSave(book, NULL);
}

- (void)addRecord{
    // 1.创建联系人
    ABRecordRef  people = ABPersonCreate();
    // 2.设置联系人信息
    ABRecordSetValue(people, kABPersonLastNameProperty, @"牛", NULL);
    ABRecordSetValue(people, kABPersonFirstNameProperty, @"查", NULL);
    // 创建电话号码
    ABMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phones, @"123456789", kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(phones, @"8888888", kABPersonPhoneHomeFAXLabel, NULL);
    ABRecordSetValue(people, kABPersonPhoneProperty, phones, NULL);
    // 3.拿到通讯录
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    // 4.将联系人添加到通讯录中
    ABAddressBookAddRecord(book, people, NULL);
    // 5.保存通讯录
    ABAddressBookSave(book, NULL);
}

@end
