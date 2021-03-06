//
//  JourneyView.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "JourneyView.h"
@implementation MsgModel

@end
@implementation JourneyView
-(void)drawRect:(CGRect)rect{
    //绘制中间的竖线
    CGContextRef ctf=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctf, 1);
    CGContextSetRGBStrokeColor(ctf, 0, 0, 0, 1);
    CGPoint aPoints[2];
    aPoints[0]=CGPointMake(APPW/2,SP_W(10));
    aPoints[1]=CGPointMake(APPW/2, self.frame.size.height-SP_W(10));
    CGContextAddLines(ctf, aPoints, 2);
    CGContextDrawPath(ctf, kCGPathStroke);
    
    //绘制最上面的原点
    CGContextAddArc(ctf, aPoints[0].x,SP_W(4),SP_W(4), 0, 2*M_PI, 0);
    CGContextSetRGBFillColor(ctf, 1, 1, 1, 1);
    CGContextDrawPath(ctf, kCGPathFillStroke);
    
    //绘制最下面的原点
    CGContextAddArc(ctf, aPoints[0].x,self.frame.size.height-SP_W(5),SP_W(5), 0, 2*M_PI, 0);
    CGContextSetRGBFillColor(ctf, 1, 1, 1, 1);
    CGContextDrawPath(ctf, kCGPathFillStroke);
    
    //绘制中线上的原点和链接线
    for(int i=0;i<_msgModelArray.count;i++){
        MsgModel * model=[_msgModelArray objectAtIndex:i];
        //绘制中线上的链接线
        CGPoint startPoint;
        CGPoint endPoint;
        if(i%2==0){
            CGContextMoveToPoint(ctf, APPW/2, SP_W(60)+SP_W(60)*i);
            CGContextAddLineToPoint(ctf, APPW/2-(APPW/2-SP_W(50)), SP_W(60)+SP_W(60)*i);
            CGContextSetLineWidth(ctf, 1);
            CGContextSetRGBStrokeColor(ctf, 0, 0, 0, 1);
            CGContextDrawPath(ctf, kCGPathStroke);
            
            startPoint.x=APPW/2;
            startPoint.y=SP_W(60)+SP_W(60)*i;
            
            endPoint.x=APPW/2-(APPW/2-SP_W(50));
            endPoint.y=SP_W(60)+SP_W(60)*i;
            //绘制末尾圆点后的图片
            NSString * imageStr1=[NSString stringWithFormat:@"%02d",i+1];
            UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y-8, SP_W(15), SP_W(15))];
            image.image=[UIImage imageNamed:imageStr1];
            [self addSubview:image];
            //绘制详细说明信息
            //地址
            if(![model.address isEqualToString:@""]){
                UIImageView * imageAdd=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageAdd.image=[UIImage imageNamed:@"address"];
                [self addSubview:imageAdd];
                UILabel * addLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageAdd.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                addLab.text=model.address;
                [addLab sizeToFit];
                [self addSubview:addLab];
            }
            //目的
            if([model.address isEqualToString:@""]&&![model.motive isEqualToString:@""]){
                UIImageView * imageMotive=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageMotive.image=[UIImage imageNamed:@"book"];
                [self addSubview:imageMotive];
                UILabel * motiveLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageMotive.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                motiveLab.text=model.motive;
                [motiveLab sizeToFit];
                [self addSubview:motiveLab];
            }else if(![model.address isEqualToString:@""]){
                UIImageView * imageMotive=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(40), SP_W(15), SP_W(15))];
                imageMotive.image=[UIImage imageNamed:@"book"];
                [self addSubview:imageMotive];
                UILabel * motiveLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageMotive.frame)+SP_W(5), endPoint.y+SP_W(40), APPW/2, SP_W(20))];
                motiveLab.text=model.motive;
                [motiveLab sizeToFit];
                [self addSubview:motiveLab];
            }
            //时间
            if([model.address isEqualToString:@""]&&[model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                [self addSubview:dateLab];
            }else if (![model.address isEqualToString:@""]&&[model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(40), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(40))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                [self addSubview:dateLab];
            }else if (![model.address isEqualToString:@""]&&![model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x-SP_W(20), endPoint.y+SP_W(60), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(60), APPW/2, SP_W(20))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                dateLab.textColor=[UIColor grayColor];
                dateLab.font=[UIFont systemFontOfSize:14];
                [self addSubview:dateLab];
            }
            
            
            
        }else{
            CGContextMoveToPoint(ctf, APPW/2, SP_W(60)+SP_W(60)*i);
            CGContextAddLineToPoint(ctf, APPW/2+(APPW/2-SP_W(50)), SP_W(60)+SP_W(60)*i);
            CGContextSetLineWidth(ctf, 1);
            CGContextSetRGBStrokeColor(ctf, 0, 0, 0, 1);
            CGContextDrawPath(ctf, kCGPathStroke);
            
            startPoint.x=APPW/2;
            startPoint.y=SP_W(60)+SP_W(60)*i;
            
            endPoint.x=APPW/2+(APPW/2-SP_W(50));
            endPoint.y=SP_W(60)+SP_W(60)*i;
            //绘制末尾圆点后的图片
            NSString * imageStr1=[NSString stringWithFormat:@"%02d",i+1];
            UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(endPoint.x+SP_W(5), endPoint.y-8, SP_W(15), SP_W(15))];
            image.image=[UIImage imageNamed:imageStr1];
            [self addSubview:image];
            
            //地址
            if(![model.address isEqualToString:@""]){
                UIImageView * imageAdd=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageAdd.image=[UIImage imageNamed:@"address"];
                [self addSubview:imageAdd];
                UILabel * addLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageAdd.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                addLab.text=model.address;
                [addLab sizeToFit];
                [self addSubview:addLab];
            }
            //目的
            if([model.address isEqualToString:@""]&&![model.motive isEqualToString:@""]){
                UIImageView * imageMotive=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageMotive.image=[UIImage imageNamed:@"book"];
                [self addSubview:imageMotive];
                UILabel * motiveLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageMotive.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                motiveLab.text=model.motive;
                [motiveLab sizeToFit];
                [self addSubview:motiveLab];
            }else if(![model.address isEqualToString:@""]){
                UIImageView * imageMotive=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(40), SP_W(15), SP_W(15))];
                imageMotive.image=[UIImage imageNamed:@"book"];
                [self addSubview:imageMotive];
                UILabel * motiveLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageMotive.frame)+SP_W(5), endPoint.y+SP_W(40), APPW/2, SP_W(20))];
                motiveLab.text=model.motive;
                [motiveLab sizeToFit];
                [self addSubview:motiveLab];
            }
            //时间
            if([model.address isEqualToString:@""]&&[model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(20), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(20))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                [self addSubview:dateLab];
            }else if (![model.address isEqualToString:@""]&&[model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(40), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(20), APPW/2, SP_W(40))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                [self addSubview:dateLab];
            }else if (![model.address isEqualToString:@""]&&![model.motive isEqualToString:@""]&&![model.date isEqualToString:@""]){
                UIImageView * imageDate=[[UIImageView alloc]initWithFrame:CGRectMake(startPoint.x+SP_W(20), endPoint.y+SP_W(60), SP_W(15), SP_W(15))];
                imageDate.image=[UIImage imageNamed:@"date"];
                [self addSubview:imageDate];
                UILabel * dateLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageDate.frame)+SP_W(5), endPoint.y+SP_W(60), APPW/2, SP_W(20))];
                dateLab.text=model.date;
                [dateLab sizeToFit];
                dateLab.textColor=[UIColor grayColor];
                dateLab.font=[UIFont systemFontOfSize:14];
                [self addSubview:dateLab];
            }
        }
        //绘制末尾的圆点
        CGContextAddArc(ctf, endPoint.x, endPoint.y, SP_W(2), 0, 2*M_PI, 0);
        
        CGContextSetFillColorWithColor(ctf,model.color.CGColor);
        CGContextDrawPath(ctf, kCGPathFill);
        //绘制中线上的原点
        CGContextAddArc(ctf, APPW/2, SP_W(60)+SP_W(60)*i, SP_W(4), 0, 2*M_PI, 0);
        CGContextSetRGBFillColor(ctf, 1, 1, 1, 1);
        CGContextDrawPath(ctf, kCGPathFillStroke);
        
        //绘制中线上的原点内的小圆点
        CGContextAddArc(ctf, APPW/2, SP_W(60)+SP_W(60)*i, SP_W(3), 0, 2*M_PI, 0);
        UIColor * color=[_colorArray objectAtIndex:i];        CGContextSetFillColorWithColor(ctf,color.CGColor);
        CGContextDrawPath(ctf, kCGPathFill);
    }
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor clearColor];
        _colorArray=[NSArray arrayWithObjects:[UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线01"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线02"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线03"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线04"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线05"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线01"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线02"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线03"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线04"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线05"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线01"]], [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆线02"]], nil];
    }
    return self;
}


@end

