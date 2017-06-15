//
//  FileScanViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "FileScanViewController.h"
@interface TRFile : NSObject<NSCoding>
@property (nonatomic, copy)NSString *name;
@property (nonatomic)int length;
@end
@implementation TRFile
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //    把所有的属性在此方法里面编码
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt:self.length forKey:@"length"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.length = [aDecoder decodeIntForKey:@"length"];
    }
    return self;
}
@end
@interface FileScanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *files;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation FileScanViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.files = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW,APPH-TopHeight) style:UITableViewStylePlain];
    NSString *directoryPath = @"/Users/tarena/Desktop/植物大战僵尸素材";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileNames = [fm contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString *fileName in fileNames) {
        TRFile *f = [[TRFile alloc]init];
        f.name = fileName;
        //得到文件的完整路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
        //        下面这种方式得到文件长度的话 会把每一个文件的数据都加载到内存中
        //        NSData *data = [NSData dataWithContentsOfFile:filePath];
        //       得到文件长度
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:filePath];
        f.length = (int)[fh seekToEndOfFile];
        
        [self.files addObject:f];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.files];
    [data writeToFile:@"/Users/tarena/Desktop/files" atomically:YES];
    [self readFiles];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
}
-(void)readFiles{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"files" ofType:@""];
    NSData *thedata = [NSData dataWithContentsOfFile:path];
    self.files = [NSKeyedUnarchiver unarchiveObjectWithData:thedata];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.files.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    TRFile *f = self.files[indexPath.row];
    cell.textLabel.text = f.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",f.length];
    return cell;
}


@end

