//
//  XMLParser.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/22.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "XMLParser.h"
@interface HMVideo : NSObject
@property (nonatomic, assign) NSString *areaid;
@property (nonatomic, assign) NSString *parentid;
@property (nonatomic, copy) NSString *name;
@end
@implementation HMVideo
@end

@interface XMLParser()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *par;
@property (nonatomic, strong) HMVideo *person;
@property (nonatomic, copy) NSString *currentElement;//标记当前标签，以索引找到XML文件内容
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation XMLParser
- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *url = @"http://isolar88.com/upload/xuechao/areas.xml";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        //1.创建XML解析器 -- SAX -- 逐个元素往下解析
        self.par = [[NSXMLParser alloc]initWithData:data];
        self.par.delegate = self;
        //初始化数组，存放解析后的数据
        self.list = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}
//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    self.currentElement = elementName;
    if ([self.currentElement isEqualToString:@"RECORD"]){
        self.person = [[HMVideo alloc]init];
    }
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentElement isEqualToString:@"parentid"]) {
        [self.person setParentid:string];
    }else if ([self.currentElement isEqualToString:@"name"]){
        [self.person setName:string];
    }else if ([self.currentElement isEqualToString:@"areaid"]){
        //NSString *str = [string substringFromIndex:2];
        [self.person setAreaid:string];
    }
}
//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if ([elementName isEqualToString:@"RECORD"]) {
        [self.list addObject:self.person];
    }self.currentElement = nil;
}
//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析结束...");
    DLog(@"%@",self.list);
}
//外部调用接口
-(NSArray *)parseXML{
    [self.par parse];
    return self.list;
}
@end
