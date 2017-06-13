//
//  XMLParseViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "XMLParseViewController.h"
#import "GDataXMLNode.h"
#import "TBXML.h"
@interface MyVideo : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@end
@implementation MyVideo
@end
@interface XMLParseViewController ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *videos;
@end
@implementation XMLParseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self parseXML2];
}

#pragma mark 第一种xml解析方法
-(void)parseXML1{
    NSData *xmlData = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement *root = doc.rootElement;
    NSArray *elements = [root elementsForName:@"video"];
    self.videos = [NSMutableArray arrayWithCapacity:10];
    // 遍历所有的video元素
    for (GDataXMLElement *videoElement in elements) {
        MyVideo *video = [[MyVideo alloc] init];
        video.name = [videoElement attributeForName:@"name"].stringValue;
        video.image = [videoElement attributeForName:@"image"].stringValue;
        video.url = [videoElement attributeForName:@"url"].stringValue;
        [self.videos addObject:video];
    }
}

#pragma mark 第二种xml解析方法
-(void)parseXML2{
    NSMutableArray *menus = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"menus" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    TBXML *tbxml = [[TBXML alloc]initWithXMLData:data error:nil];
    //得到根元素
    TBXMLElement *rootEle = tbxml.rootXMLElement;
    TBXMLElement *resultEle = [TBXML childElementNamed:@"result" parentElement:rootEle];
    TBXMLElement *dataEle = [TBXML childElementNamed:@"data" parentElement:resultEle];
    TBXMLElement *itemEle = [TBXML childElementNamed:@"item" parentElement:dataEle];
    while (itemEle) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        TBXMLElement *titleEle = [TBXML childElementNamed:@"title" parentElement:itemEle];
        TBXMLElement *idEle = [TBXML childElementNamed:@"id" parentElement:itemEle];
        TBXMLElement *introEle = [TBXML childElementNamed:@"imtro" parentElement:itemEle];
        [dict setValue:[TBXML textForElement:titleEle] forKey:@"name"];
        [dict setValue:[TBXML textForElement:idEle] forKey:@"menuID"];
        [dict setValue:[TBXML textForElement:introEle] forKey:@"description"];
        [menus addObject:dict];
        DLog(@"%@\n%@",dict[@"name"],dict[@"description"]);
        itemEle = [TBXML nextSiblingNamed:@"item" searchFromElement:itemEle];
    }
    DLog(@"%@",menus);
}
#pragma mark 第三种xml解析方法，系统自带的
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 解析XML数据
    NSData *xmlData = nil;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    [parser parse];
}
#pragma mark - NSXMLParser的代理方法
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"parserDidStartDocument----");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([@"videos" isEqualToString:elementName]) return;
    [self.videos addObject:attributeDict];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //    NSLog(@"didEndElement----%@", elementName);
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //    NSLog(@"parserDidEndDocument----");
}

@end

