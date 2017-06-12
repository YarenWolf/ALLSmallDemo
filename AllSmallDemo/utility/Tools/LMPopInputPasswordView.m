//
//  YLPopInputPasswordView.m
//  YouLanAgents
//
//  Created by lqcjdx on 15/5/27.
//  Copyright (c) 2015年 YL. All rights reserved.
//

#define kLineTag 1000
#define kDotTag 3000

#import "LMPopInputPasswordView.h"
#import <QuartzCore/QuartzCore.h>

#define kPasswordLength  6

@interface LMPopInputPasswordView()<UITextFieldDelegate>
{
    
}
@property(nonatomic,strong)UIControl *overlayView;//背景
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *lineLabel;//线条
@property(nonatomic,strong)YLPasswordTextFiled *textFiled;//输入文本框
@property(nonatomic,strong)UIButton *cancelButton;//取消按钮
@property(nonatomic,strong)UIButton *ensureButton;//确定按钮
@end

@implementation LMPopInputPasswordView

-(instancetype)init{
    if(self = [super init]){
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"请输入密码";
    [self addSubview:_titleLabel];
    
    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineLabel];
    
    _textFiled = [[YLPasswordTextFiled alloc]init];
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.layer.masksToBounds = YES;
    _textFiled.layer.borderColor = [UIColor grayColor].CGColor;
    _textFiled.layer.borderWidth = 1;
    _textFiled.layer.cornerRadius = 5;
    _textFiled.secureTextEntry = YES;
    _textFiled.delegate = self;
    _textFiled.tintColor = [UIColor clearColor];//看不到光标
    _textFiled.textColor = [UIColor clearColor];//看不到输入内容
    _textFiled.font = [UIFont systemFontOfSize:30];
    _textFiled.keyboardType = UIKeyboardTypeNumberPad;
    _textFiled.pattern = [NSString stringWithFormat:@"^\\d{%li}$",(long)kPasswordLength];
    [_textFiled addTarget:self action:@selector(textFiledEdingChanged) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textFiled];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = [UIColor grayColor].CGColor;
    _cancelButton.layer.cornerRadius = 5;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
    _cancelButton.tag = 0;
    [_cancelButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ensureButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:109/255.0 blue:238/255.0 alpha:1];
    _ensureButton.layer.masksToBounds = YES;
    _ensureButton.layer.cornerRadius = 5;
    _ensureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_ensureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ensureButton setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ensureButton setTitle:@"确定" forState:UIControlStateHighlighted];
    _ensureButton.tag = 1;
    [_ensureButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ensureButton];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _overlayView.frame = [[UIScreen mainScreen] bounds];
    
    //设置子视图位置
    CGFloat offsetX = 10;
    CGFloat offsetY = 10;
    _titleLabel.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 21);
    
    offsetY += _titleLabel.frame.size.height + 10;
    _lineLabel.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 1);
    
    offsetY += _lineLabel.frame.size.height + 10;
    _textFiled.frame = CGRectMake(offsetX, offsetY, frame.size.width - 2 * offsetX, 35);
    
    offsetY += _textFiled.frame.size.height + 10;
    CGFloat btnWidth = (frame.size.width - offsetX * 3)/2.0;
    _cancelButton.frame = CGRectMake(offsetX, offsetY, btnWidth, 35);
    _ensureButton.frame = CGRectMake(offsetX * 2 + btnWidth, offsetY, btnWidth, 35);
}

#pragma mark ---animation methods
-(void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        [_textFiled becomeFirstResponder];
    }];
}

- (void)fadeOut
{
    [self endEditing:YES];
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)pop
{
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f-100);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

-(void)buttonClickedAction:(UIButton *)sender
{
    //传值给委托对象
    if([_delegate respondsToSelector:@selector(buttonClickedAtIndex:withText:)]){
        [_delegate buttonClickedAtIndex:sender.tag withText:_textFiled.text];
    }
    
    [self dismiss];
}

-(void)textFiledEdingChanged
{
    NSInteger length = _textFiled.text.length;
    NSLog(@"lenght=%li",(long)length);
    if(length==kPasswordLength){
        [self buttonClickedAction:_ensureButton];
    }
    for(NSInteger i=0;i<kPasswordLength;i++){
        UILabel *dotLabel = (UILabel *)[_textFiled viewWithTag:kDotTag + i];
        if(dotLabel){
            dotLabel.hidden = length <= i;
        }
    }
    [_textFiled sendActionsForControlEvents:UIControlEventValueChanged];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    [_textFiled removeTarget:self action:@selector(textFiledEdingChanged) forControlEvents:UIControlEventEditingChanged];
}
@end
@class WTReGroup;

@interface WTReParser : NSObject
{
    NSString *_pattern;
    BOOL _ignoreCase;
    WTReGroup *_node;
    BOOL _finished;
    NSRegularExpression *_exactQuantifierRegex;
    NSRegularExpression *_rangeQuantifierRegex;
}

- (id)initWithPattern:(NSString*)pattern;
- (id)initWithPattern:(NSString*)pattern ignoreCase:(BOOL)ignoreCase;
- (NSString*)reformatString:(NSString*)input;

@property (readonly, nonatomic) NSString *pattern;

@end

// common interface for all node types

@interface WTReNode : NSObject

@property (assign, nonatomic) NSRange sourceRange;
@property (weak, nonatomic) WTReNode *parent;
@property (weak, nonatomic) WTReNode *nextSibling;

- (NSString*)displayString:(NSString*)pattern;

@end

@implementation WTReNode

- (NSString*)displayString:(NSString*)pattern
{
    return [pattern substringWithRange:_sourceRange];
}

@end

// interface for group node

@interface WTReGroup : WTReNode

@property (assign, nonatomic) BOOL capturing;
@property (strong, nonatomic) NSArray *children;

@end

@implementation WTReGroup

- (void)dealloc
{
    _children = nil;
}

- (NSString*)displayString:(NSString*)pattern
{
    return [NSString stringWithFormat:@"(%@)", [pattern substringWithRange:self.sourceRange]];
}

- (NSString*)debugDescription
{
    if (_capturing)
        return @"Capturing Parentheses";
    else
        return @"Non-capturing Parentheses";
}

@end

// interface for alternation node

@interface WTReAlternation : WTReNode

@property (strong, nonatomic) NSArray *children;

@end

@implementation WTReAlternation

- (void)dealloc
{
    _children = nil;
}

- (NSString*)displayString:(NSString*)pattern
{
    return [pattern substringWithRange:self.sourceRange];
}

- (NSString*)debugDescription
{
    return @"Alternation";
}

@end

// interface for quantifier

@interface WTReQuantifier : WTReNode

- (id)initWithFrom:(NSUInteger)from to:(NSUInteger)to;

@property (strong, nonatomic) WTReNode *child;
@property (assign, nonatomic) BOOL greedy;
@property (assign, nonatomic) NSUInteger countFrom;
@property (assign, nonatomic) NSUInteger countTo;

@end

@implementation WTReQuantifier

- (id)init
{
    self = [super init];
    if (self)
    {
        _greedy = YES;
        _countFrom = 1;
        _countTo = 1;
    }
    return self;
}

- (id)initWithFrom:(NSUInteger)from to:(NSUInteger)to
{
    self = [super init];
    if (self)
    {
        _greedy = YES;
        _countFrom = from;
        _countTo = to;
    }
    return self;
}

- (void)dealloc
{
    _child = nil;
}

- (NSString*)debugDescription
{
    if (_greedy)
        return @"Greedy Quantifier";
    else
        return @"Lazy Quantifier";
}

- (NSString*)displayQuantifier
{
    NSString *pat = nil;
    if (_countFrom == 0) {
        if (_countTo == NSUIntegerMax) {
            pat = @"*";
        } else if (_countTo == 1) {
            pat = @"?";
        } else {
            pat = [NSString stringWithFormat:@"{,%lu}", (unsigned long)_countTo];
        }
    } else if (_countFrom == 1 && _countTo == NSUIntegerMax) {
        pat = @"+";
    } else if (_countFrom == _countTo) {
        pat = [NSString stringWithFormat:@"{%lu}", (unsigned long)_countFrom];
    } else if (_countTo == NSUIntegerMax) {
        pat = [NSString stringWithFormat:@"{%lu,}", (unsigned long)_countFrom];
    } else {
        pat = [NSString stringWithFormat:@"{%lu,%lu}", (unsigned long)_countFrom, (unsigned long)_countTo];
    }
    
    if (_greedy) return pat;
    
    return [pat stringByAppendingString:@"?"];
}

- (NSString*)displayString:(NSString *)pattern
{
    return [[_child displayString:pattern] stringByAppendingString:[self displayQuantifier]];
}

@end

// base interface for all character subsets

@interface WTReCharacterBase : WTReNode

@property (assign, nonatomic) BOOL ignoreCase;

- (BOOL)matchesCharacter:(unichar)c;

@end

@implementation WTReCharacterBase

- (BOOL)matchesCharacter:(unichar)c
{
    @throw [NSException exceptionWithName:@"Invalid operation" reason:@"Override this method in subclasses" userInfo:nil];
}

@end

// interface for character set node

@interface WTReCharacterSet : WTReCharacterBase

@property (assign, nonatomic) BOOL negation;
@property (strong, nonatomic) NSCharacterSet *chars;

@end

@implementation WTReCharacterSet

- (BOOL)matchesCharacter:(unichar)c
{
    BOOL contains = [_chars characterIsMember:c];
    
    if (!contains && self.ignoreCase)
    {
        if ([[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c])
        {
            // test upper
            unichar uc = [[[NSString stringWithCharacters:&c length:1] uppercaseString] characterAtIndex: 0];
            contains = [_chars characterIsMember:uc];
        }
        else if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c])
        {
            // test lower
            unichar lc = [[[NSString stringWithCharacters:&c length:1] lowercaseString] characterAtIndex: 0];
            contains = [_chars characterIsMember:lc];
        }
    }
    
    return contains ^ _negation;
}

- (NSString*)displayString:(NSString*)pattern
{
    return [NSString stringWithFormat:@"[%@]", [pattern substringWithRange:self.sourceRange]];
}

- (NSString*)debugDescription
{
    return @"Character Class";
}

@end

// interface for literal node

@interface WTReLiteral : WTReCharacterBase

@property (assign, nonatomic) unichar character;

@end

@implementation WTReLiteral

- (BOOL)matchesCharacter:(unichar)c
{
    BOOL contains = _character == c;
    
    if (!contains && self.ignoreCase)
    {
        if ([[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c])
        {
            // test upper
            unichar uc = [[[NSString stringWithCharacters:&c length:1] uppercaseString] characterAtIndex: 0];
            contains = _character == uc;
        }
        else if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c])
        {
            // test lower
            unichar lc = [[[NSString stringWithCharacters:&c length:1] lowercaseString] characterAtIndex: 0];
            contains = _character == lc;
        }
    }
    
    return contains;
}

- (NSString*)displayString:(NSString *)pattern
{
    return [NSString stringWithFormat:@"'%c'", _character];
}

- (NSString*)debugDescription
{
    return @"Character";
}

@end

// interface for any character (.) node

@interface WTReAnyCharacter : WTReCharacterBase

@end

@implementation WTReAnyCharacter

- (BOOL)matchesCharacter:(unichar)c
{
    return YES;
}

- (NSString*)displayString:(NSString*)pattern
{
    return @".";
}

- (NSString*)debugDescription
{
    return @"Any Character";
}

@end

// interface for end of string ($) node

@interface WTReEndOfString : WTReCharacterBase

@end

@implementation WTReEndOfString

- (NSString*)displayString:(NSString *)pattern
{
    return @"$";
}

- (NSString*)debugDescription
{
    return @"End of String";
}

- (BOOL)matchesCharacter:(unichar)c
{
    return c == 0;
}

@end

// helper internal classes

@interface WTState : NSObject
{
    NSMutableArray *_transitions;
}

@property (assign, nonatomic) BOOL isFinal;
@property (readonly, nonatomic) NSMutableArray *transitions;

@end

@implementation WTState

- (NSMutableArray*)transitions
{
    if (_transitions == nil)
        _transitions = [[NSMutableArray alloc] initWithCapacity:1];
    return _transitions;
}

@end

@interface WTTransition : NSObject

@property (weak, nonatomic) WTReCharacterBase *node;
@property (weak, nonatomic) WTReLiteral *bypassNode;
@property (strong, nonatomic) WTState *nextState;

@end

@implementation WTTransition

@end

// parser implementation

@implementation WTReParser

- (id)initWithPattern:(NSString *)pattern
{
    return [self initWithPattern:pattern ignoreCase:NO];
}

- (id)initWithPattern:(NSString *)pattern ignoreCase:(BOOL)ignoreCase
{
    NSParameterAssert(pattern != nil && ![pattern isEqualToString:@""]);
    
    self = [super init];
    if (self)
    {
        _pattern = pattern;
        _ignoreCase = ignoreCase;
        _node = nil;
        [self parsePattern];
    }
    return self;
}

- (void)dealloc
{
    _pattern = nil;
    _node = nil;
    _exactQuantifierRegex = nil;
    _rangeQuantifierRegex = nil;
}

#ifdef DEBUG

- (NSString*)debugDescription
{
    return [self nodeDescription:_node withLevel:0];
}

- (NSString*)nodeDescription:(WTReNode*)node withLevel:(NSUInteger)level
{
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:100];
    
    for (NSUInteger i = 0; i < level; i++)
        [buffer appendString:@"  "];
    
    [buffer appendString:[node displayString:_pattern]];
    [buffer appendString:@" - "];
    [buffer appendString:[node debugDescription]];
    [buffer appendString:@"\n"];
    
    if ([node isKindOfClass:[WTReAlternation class]])
    {
        for (WTReNode* c in [(WTReAlternation*)node children])
            [buffer appendString:[self nodeDescription:c withLevel:level+1]];
    }
    else if ([node isKindOfClass:[WTReGroup class]])
    {
        for (WTReNode* c in [(WTReGroup*)node children])
            [buffer appendString:[self nodeDescription:c withLevel:level+1]];
    }
    else if ([node isKindOfClass:[WTReQuantifier class]])
    {
        [buffer appendString:[self nodeDescription:[(WTReQuantifier*)node child] withLevel:level+1]];
    }
    
    return buffer;
}

#endif

- (void)parsePattern
{
    if (_node != nil) return;
    
    if (![_pattern hasPrefix:@"^"])
        @throw [NSException exceptionWithName:@"Error" reason:@"Invalid pattern start" userInfo:nil];
    
    _finished = NO;
    _exactQuantifierRegex = [[NSRegularExpression alloc] initWithPattern:@"^\\{\\s*(\\d+)\\s*\\}$" options:0 error:nil];
    _rangeQuantifierRegex = [[NSRegularExpression alloc] initWithPattern:@"^\\{\\s*(\\d*)\\s*,\\s*(\\d*)\\s*\\}$" options:0 error:nil];
    
    _node = [self parseSubpattern:_pattern inRange:NSMakeRange(1, _pattern.length - 1) enclosed:NO];
    
    _exactQuantifierRegex = nil;
    _rangeQuantifierRegex = nil;
    
    if (!_finished)
        @throw [NSException exceptionWithName:@"Error" reason:@"Invalid pattern end" userInfo:nil];
}

- (BOOL)isValidEscapedChar:(unichar)c inCharset:(BOOL)inCharset
{
    switch (c)
    {
        case '(':
        case ')':
        case '[':
        case ']':
        case '{':
        case '}':
        case '\\':
        case '|':
        case 'd':
        case 'D':
        case 'w':
        case 'W':
        case 's':
        case 'S':
        case 'u':
        case '\'':
        case '.':
        case '+':
        case '*':
        case '?':
        case '$':
        case '^':
            return YES;
            
        case '-':
            return inCharset;
            
        default:
            return NO;
    }
}

- (void)raiseParserError:(NSString*)error atPos:(NSUInteger)pos
{
    NSString *pat = [NSString stringWithFormat:@"%@ \u25B6%@", [_pattern substringToIndex:pos], [_pattern substringFromIndex:pos]];
    @throw [NSException exceptionWithName:@"Parse error" reason:[NSString stringWithFormat:@"%@ @ pos %lu: %@", error, (unsigned long)pos, pat] userInfo:nil];
}

- (WTReCharacterBase*)parseCharset:(NSString*)pattern inRange:(NSRange)range enclosed:(BOOL)enclosed
{
    BOOL negation = NO;
    NSUInteger count = 0;
    unichar lastChar = 0;
    NSMutableCharacterSet *chars = [[NSMutableCharacterSet alloc] init];
    BOOL escape = NO;
    
    for (NSUInteger i = 0; i < range.length; i++) {
        unichar c = [pattern characterAtIndex:(range.location + i)];
        
        if (enclosed && i == 0 && c == '^') {
            negation = YES;
            continue;
        }
        
        if (c == '\\' && !escape) {
            escape = YES;
            continue;
        }
        
        if (escape) {
            // process character classes and escaped special chars
            
            if (![self isValidEscapedChar:c inCharset:enclosed])
                [self raiseParserError:@"Invalid escape sequence" atPos:(range.location + i)];
            
            if (c == 'd') {
                [chars formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
                count += 2;
            }
            else if (c == 'D') {
                [chars formUnionWithCharacterSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
                count += 2;
            }
            else if (c == 'w') {
                [chars formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
                count += 2;
            }
            else if (c == 'W') {
                [chars formUnionWithCharacterSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
                count += 2;
            }
            else if (c == 's') {
                [chars formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
                count += 2;
            }
            else if (c == 'S') {
                [chars formUnionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
                count += 2;
            }
            else if (c == 'u') {
                // unicode character in format \uFFFF
                
                if (i + 4 >= range.length)
                    [self raiseParserError:@"Expected a four-digit hexadecimal character code" atPos:(range.location + i + 1)];
                
                NSScanner *scanner = [NSScanner scannerWithString:[pattern substringWithRange:NSMakeRange(range.location + i + 1, 4)]];
                
                unsigned int code;
                if (![scanner scanHexInt:&code])
                    [self raiseParserError:@"Expected a four-digit hexadecimal character code" atPos:(range.location + i + 1)];
                
                lastChar = (unichar)code;
                [chars addCharactersInRange:NSMakeRange(lastChar, 1)];
                i += 4;
                count++;
            }
            else {
                // todo: check for other escape sequences
                
                [chars addCharactersInRange:NSMakeRange(c, 1)];
                lastChar = c;
                count++;
            }
            
            escape = NO;
        }
        else if (enclosed && c == '-' && i > 0 && i < range.length - 1) {
            // process character range
            
            unichar rangeStart = [pattern characterAtIndex:(range.location + i - 1)];
            unichar rangeEnd = [pattern characterAtIndex:(range.location + i + 1)];
            
            if (rangeEnd < rangeStart)
                [self raiseParserError:@"Invalid character range" atPos:(range.location + i - 1)];
            
            NSCharacterSet *alphanum = [NSCharacterSet alphanumericCharacterSet];
            if (![alphanum characterIsMember:rangeStart] || ![alphanum characterIsMember:rangeEnd])
                [self raiseParserError:@"Invalid character range" atPos:(range.location + i - 1)];
            
            // iOS5 has a bug: things go ugly if range intersects with existing one, so exclude it first
            [chars removeCharactersInRange:NSMakeRange(rangeStart, rangeEnd - rangeStart + 1)];
            [chars addCharactersInRange:NSMakeRange(rangeStart, rangeEnd - rangeStart + 1)];
            i++;
            count += 2;
        }
        else {
            // process simple char
            
            [chars addCharactersInRange:NSMakeRange(c, 1)];
            lastChar = c;
            count++;
        }
    }
    
    if (!negation && count == 1) {
        WTReLiteral *l = [[WTReLiteral alloc] init];
        l.character = lastChar;
        l.sourceRange = range;
        l.ignoreCase = _ignoreCase;
        return l;
    } else {
        WTReCharacterSet *s = [[WTReCharacterSet alloc] init];
        s.negation = negation;
        s.chars = chars;
        s.sourceRange = range;
        s.ignoreCase = _ignoreCase;
        return s;
    }
}

- (WTReGroup*)groupFromNodes:(NSArray*)nodes enclosed:(BOOL)enclosed
{
    if (nodes.count == 1) {
        WTReGroup *t = [nodes objectAtIndex:0];
        if ([t isKindOfClass:[WTReGroup class]]) {
            t.capturing |= enclosed;
            return t;
        }
    }
    
    WTReGroup *g = [[WTReGroup alloc] init];
    g.children = [nodes copy];
    g.capturing = enclosed;
    
    // setup links
    WTReNode *prev = [g.children objectAtIndex:0];
    prev.parent = g;
    
    for (NSUInteger i = 1; i < g.children.count; i++) {
        WTReNode *curr = [g.children objectAtIndex:i];
        curr.parent = g;
        prev.nextSibling = curr;
        prev = curr;
    }
    
    return g;
}

- (WTReGroup*)parseSubpattern:(NSString*)pattern inRange:(NSRange)range enclosed:(BOOL)enclosed
{
    NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:range.length];
    
    NSMutableArray *alternations = nil;
    NSUInteger startPos = 0, endPos = range.length;
    
    BOOL escape = NO;
    WTReNode *lastnode = nil;
    
    for (NSUInteger i = 0; i < range.length; i++) {
        if (_finished)
            [self raiseParserError:@"Found pattern end in the middle of string" atPos:(range.location + i)];
        
        unichar c = [pattern characterAtIndex:(range.location + i)];
        
        if (enclosed && i == 0 && c == '?') {
            // group modifiers are present
            
            if (range.length < 3)
                [self raiseParserError:@"Invalid group found in pattern" atPos:(range.location + i)];
            
            NSCharacterSet *alphanum = [NSCharacterSet alphanumericCharacterSet];
            
            unichar d = [pattern characterAtIndex:(range.location + i + 1)];
            if (d == '<') {
                // tagged group (?<style1>…)
                for (NSUInteger j = i + 2; j < range.length; j++) {
                    unichar d = [pattern characterAtIndex:(range.location + j)];
                    
                    if (d == '<') {
                        [self raiseParserError:@"Invalid group tag found in pattern" atPos:(range.location + j)];
                    } else if (d == '>') {
                        if (j == i + 2)
                            [self raiseParserError:@"Empty group tag found in pattern" atPos:(range.location + j)];
                        i = j;
                        break;
                    } else if (![alphanum characterIsMember:d]) {
                        [self raiseParserError:@"Group tag contains invalid chars" atPos:(range.location + j)];
                    }
                }
            }
            else if (d == '\'') {
                // tagged group (?'style2'…)
                for (NSUInteger j = i + 2; j < range.length; j++) {
                    unichar d = [pattern characterAtIndex:(range.location + j)];
                    
                    if (d == '\'') {
                        if (j == i + 2)
                            [self raiseParserError:@"Empty group tag found in pattern" atPos:(range.location + j)];
                        i = j;
                        break;
                    } else if (![alphanum characterIsMember:d]) {
                        [self raiseParserError:@"Group tag contains invalid chars" atPos:(range.location + j)];
                    }
                }
            }
            else if (d == ':') {
                // non-capturing group
                enclosed = FALSE;
                i++;
            }
            else {
                [self raiseParserError:@"Unknown group modifier" atPos:(range.location + i + 1)];
            }
            
            continue;
        }
        
        if (c == '\\' && !escape) {
            escape = YES;
            continue;
        }
        
        if (escape) {
            if (![self isValidEscapedChar:c inCharset:NO] || i == 0)
                [self raiseParserError:@"Invalid escape sequence" atPos:(range.location + i)];
            
            lastnode = [self parseCharset:pattern inRange:NSMakeRange(range.location + i - 1, 2) enclosed:NO];
            [nodes addObject:lastnode];
            
            escape = NO;
        }
        else if (c == '(') {
            NSInteger brackets = 1;
            BOOL escape2 = NO;
            
            for (NSUInteger j = i + 1; j < range.length; j++) {
                unichar d = [pattern characterAtIndex:(range.location + j)];
                
                if (escape2) {
                    escape2 = NO;
                } else if (d == '\\') {
                    escape2 = YES;
                } else if (d == '(') {
                    brackets++;
                } else if (d == ')') {
                    brackets--;
                    
                    if (brackets == 0) {
                        lastnode = [self parseSubpattern:pattern inRange:NSMakeRange(range.location + i + 1, j - i - 1) enclosed:YES];
                        [nodes addObject:lastnode];
                        
                        i = j;
                        break;
                    }
                }
            }
            
            if (brackets != 0)
                [self raiseParserError:@"Unclosed group bracket" atPos:(range.location + i)];
        }
        else if (c == ')') {
            [self raiseParserError:@"Unopened group bracket" atPos:(range.location + i)];
        }
        else if (c == '[') {
            BOOL escape2 = NO;
            BOOL valid = NO;
            
            for (NSUInteger j = i + 1; j < range.length; j++) {
                unichar d = [pattern characterAtIndex:(range.location + j)];
                
                if (escape2) {
                    escape2 = NO;
                } else if (d == '\\') {
                    escape2 = YES;
                } else if (d == '[' || d == '(' || d == ')') {
                    // invalid character
                    break;
                } else if (d == ']') {
                    lastnode = [self parseCharset:pattern inRange:NSMakeRange(range.location + i + 1, j - i - 1) enclosed:YES];
                    [nodes addObject:lastnode];
                    
                    i = j;
                    valid = YES;
                    break;
                }
            }
            
            if (!valid)
                [self raiseParserError:@"Unclosed character set bracket" atPos:(range.location + i)];
        }
        else if (c == ']') {
            [self raiseParserError:@"Unopened character set bracket" atPos:(range.location + i)];
        }
        else if (c == '{') {
            if (lastnode == nil || [lastnode isKindOfClass:[WTReQuantifier class]])
                [self raiseParserError:@"Invalid quantifier usage" atPos:(range.location + i)];
            
            BOOL valid = NO;
            
            for (NSUInteger j = i + 1; j < range.length; j++) {
                unichar d = [pattern characterAtIndex:(range.location + j)];
                
                if (d == '}') {
                    NSString *from, *to;
                    
                    NSTextCheckingResult *m = [_exactQuantifierRegex firstMatchInString:pattern options:0 range:NSMakeRange(range.location + i, j - i + 1)];
                    if (m != nil) {
                        from = [pattern substringWithRange:[m rangeAtIndex:1]];
                        to = from;
                    } else {
                        m = [_rangeQuantifierRegex firstMatchInString:pattern options:0 range:NSMakeRange(range.location + i, j - i + 1)];
                        if (m == nil)
                            [self raiseParserError:@"Invalid quantifier format" atPos:(range.location + i)];
                        
                        from = [pattern substringWithRange:[m rangeAtIndex:1]];
                        to = [pattern substringWithRange:[m rangeAtIndex:2]];
                    }
                    
                    WTReQuantifier *qtf = [[WTReQuantifier alloc] init];
                    
                    if (from == nil || [from isEqualToString:@""])
                        qtf.countFrom = 0;
                    else
                        qtf.countFrom = [from integerValue];
                    
                    if (to == nil || [to isEqualToString:@""])
                        qtf.countTo = NSUIntegerMax;
                    else
                        qtf.countTo = [to integerValue];
                    
                    if (qtf.countFrom > qtf.countTo)
                        [self raiseParserError:@"Invalid quantifier range" atPos:(range.location + i)];
                    
                    [nodes removeLastObject];
                    qtf.child = lastnode;
                    lastnode.parent = qtf;
                    lastnode = qtf;
                    [nodes addObject:lastnode];
                    
                    i = j;
                    valid = YES;
                    break;
                }
            }
            
            if (!valid)
                [self raiseParserError:@"Unclosed quantifier bracket" atPos:(range.location + i)];
        }
        else if (c == '}') {
            [self raiseParserError:@"Unopened qualifier bracket" atPos:(range.location + i)];
        }
        else if (c == '*') {
            if (lastnode == nil || [lastnode isKindOfClass:[WTReQuantifier class]])
                [self raiseParserError:@"Invalid quantifier usage" atPos:(range.location + i)];
            
            [nodes removeLastObject];
            WTReQuantifier *qtf = [[WTReQuantifier alloc] initWithFrom:0 to:NSUIntegerMax];
            qtf.child = lastnode;
            lastnode.parent = qtf;
            lastnode = qtf;
            [nodes addObject:lastnode];
        }
        else if (c == '+') {
            if (lastnode == nil || [lastnode isKindOfClass:[WTReQuantifier class]])
                [self raiseParserError:@"Invalid quantifier usage" atPos:(range.location + i)];
            
            [nodes removeLastObject];
            WTReQuantifier *qtf = [[WTReQuantifier alloc] initWithFrom:1 to:NSUIntegerMax];
            qtf.child = lastnode;
            lastnode.parent = qtf;
            lastnode = qtf;
            [nodes addObject:lastnode];
        }
        else if (c == '?') {
            if (lastnode == nil)
                [self raiseParserError:@"Invalid quantifier usage" atPos:(range.location + i)];
            
            if ([lastnode isKindOfClass:[WTReQuantifier class]]) {
                // greediness modifier
                [(WTReQuantifier*)lastnode setGreedy:NO];
            } else {
                [nodes removeLastObject];
                WTReQuantifier *qtf = [[WTReQuantifier alloc] initWithFrom:0 to:1];
                qtf.child = lastnode;
                lastnode.parent = qtf;
                lastnode = qtf;
                [nodes addObject:lastnode];
            }
            
            lastnode = nil;
        }
        else if (c == '.') {
            // any character
            lastnode = [[WTReAnyCharacter alloc] init];
            [nodes addObject:lastnode];
        }
        else if (c == '|') {
            // alternation
            if (alternations == nil)
                alternations = [[NSMutableArray alloc] initWithCapacity:2];
            
            WTReGroup *g = [self groupFromNodes:nodes enclosed:enclosed];
            g.sourceRange = NSMakeRange(range.location + startPos, i - startPos);
            startPos = i + 1;
            
            [alternations addObject:g];
            [nodes removeAllObjects];
            lastnode = nil;
        }
        else if (c == '$') {
            if (alternations != nil && enclosed)
                [self raiseParserError:@"End of string shouldn't be inside alternation" atPos:(range.location + i)];
            
            if (range.location + i + 1 < pattern.length)
                [self raiseParserError:@"Unexpected end of string" atPos:(range.location + i + 1)];
            
            lastnode = [[WTReEndOfString alloc] init];
            [nodes addObject:lastnode];
            
            endPos = i + 1;
            _finished = YES;
            break;
        }
        else {
            lastnode = [self parseCharset:pattern inRange:NSMakeRange(range.location + i, 1) enclosed:NO];
            [nodes addObject:lastnode];
        }
    }
    
    if (escape)
        [self raiseParserError:@"Invalid group ending" atPos:(range.location + range.length)];
    
    NSUInteger endPosForGroup = endPos;
    if (alternations != nil && _finished && !enclosed)
    {
        // root-level alternation not included in parenthesis:
        // ^aaa|bbb$
        // need to strip end-of-string node from last group
        [nodes removeLastObject];
        // and decrement last alternation length by 1
        endPosForGroup--;
    }
    
    WTReGroup *g = [self groupFromNodes:nodes enclosed:enclosed];
    g.sourceRange = NSMakeRange(range.location + startPos, endPosForGroup - startPos);
    g.capturing = enclosed;
    
    if (alternations != nil) {
        // build alternation and enclose it into group
        [alternations addObject:g];
        
        WTReAlternation *a = [[WTReAlternation alloc] init];
        a.children = alternations;
        a.sourceRange = NSMakeRange(range.location, endPos);
        
        // setup links
        WTReNode *prev = [alternations objectAtIndex:0];
        prev.parent = a;
        
        for (NSUInteger i = 1; i < alternations.count; i++) {
            WTReNode *curr = [alternations objectAtIndex:i];
            curr.parent = a;
            prev.nextSibling = curr;
            prev = curr;
        }
        
        g = [[WTReGroup alloc] init];
        g.children = [NSArray arrayWithObject:a];
        g.capturing = enclosed;
        g.sourceRange = a.sourceRange;
        
        a.parent = g;
        
        if (_finished && !enclosed)
        {
            a.nextSibling = lastnode;
            lastnode.parent = g;
            g.children = [NSArray arrayWithObjects:a, lastnode, nil];
        }
    }
    
    return g;
}

- (NSString*)reformatString:(NSString *)input
{
    // empty strings are ok
    if (input == nil || [input isEqualToString:@""]) return input;
    
    NSMutableString *tInput = [input mutableCopy];
    
    @autoreleasepool {
        WTState *initialState = [[WTState alloc] init];
        WTState *finalState = [self processNode:_node fromState:initialState length:input.length];
        
        WTState *x = [self nextState:initialState finalState:finalState input:tInput position:0];
        
        return x.isFinal ? tInput : nil;
    }
}

- (WTState*)processNode:(WTReNode*)node fromState:(WTState*)state length:(NSUInteger)length
{
    if ([node isKindOfClass:[WTReEndOfString class]])
    {
        WTState *finalState = [[WTState alloc] init];
        finalState.isFinal = YES;
        
        WTTransition *tran = [[WTTransition alloc] init];
        tran.node = (WTReCharacterBase*)node;
        tran.nextState = finalState;
        [state.transitions addObject:tran];
        
        return finalState;
    }
    else if ([node isKindOfClass:[WTReCharacterBase class]])
    {
        WTState *finalState = [[WTState alloc] init];
        
        WTTransition *tran = [[WTTransition alloc] init];
        tran.node = (WTReCharacterBase*)node;
        tran.nextState = finalState;
        [state.transitions addObject:tran];
        
        return finalState;
    }
    else if ([node isKindOfClass:[WTReQuantifier class]])
    {
        WTReQuantifier *qtf = (WTReQuantifier*)node;
        
        WTState *curState = state;
        for (NSUInteger i = 0; i < qtf.countFrom; i++) {
            curState = [self processNode:qtf.child fromState:curState length:length];
        }
        
        if (qtf.countTo == qtf.countFrom)
        {
            // strict quantifier
            return curState;
        }
        
        WTState *finalState = [[WTState alloc] init];
        
        for (NSUInteger i = qtf.countFrom; i < MIN(qtf.countTo, length); i++) {
            WTState *nextState = [self processNode:qtf.child fromState:curState length:length];
            
            WTTransition *tran = [[WTTransition alloc] init];
            tran.node = nil;
            tran.nextState = finalState;
            
            if (qtf.greedy)
                [curState.transitions addObject:tran];
            else
                [curState.transitions insertObject:tran atIndex:0];
            
            curState = nextState;
        }
        
        WTTransition *tran = [[WTTransition alloc] init];
        tran.node = nil;
        tran.nextState = finalState;
        [curState.transitions addObject:tran];
        
        return finalState;
    }
    else if ([node isKindOfClass:[WTReGroup class]])
    {
        WTReGroup *grp = (WTReGroup*)node;
        
        WTState *curState = state;
        for (NSUInteger i = 0; i < grp.children.count; i++) {
            curState = [self processNode:[grp.children objectAtIndex:i] fromState:curState length:length];
        }
        
        if (!grp.capturing && grp.children.count == 1 && [[grp.children objectAtIndex:0] isKindOfClass:[WTReLiteral class]])
        {
            WTTransition *tran = [[WTTransition alloc] init];
            tran.node = nil;
            tran.bypassNode = (WTReLiteral*)[grp.children objectAtIndex:0];
            tran.nextState = curState;
            [state.transitions addObject:tran];
        }
        
        return curState;
    }
    else if ([node isKindOfClass:[WTReAlternation class]])
    {
        WTReAlternation *alt = (WTReAlternation*)node;
        
        WTState *finalState = [[WTState alloc] init];
        
        for (NSUInteger i = 0; i < alt.children.count; i++) {
            WTState *curState = [self processNode:[alt.children objectAtIndex:i] fromState:state length:length];
            
            WTTransition *tran = [[WTTransition alloc] init];
            tran.node = nil;
            tran.nextState = finalState;
            [curState.transitions addObject:tran];
        }
        
        return finalState;
    }
    else
    {
        NSAssert(YES, @"Unsupported node type");
        return nil;
    }
}

- (WTState*)nextState:(WTState*)state finalState:(WTState*)final input:(NSMutableString*)input position:(NSUInteger)pos
{
    if (state.isFinal) return state;
    
    if (pos > input.length) return final;
    
    for (WTTransition *tran in state.transitions) {
        
        NSUInteger nextPos = pos;
        
        if (tran.node != nil) {
            unichar c = (pos < input.length) ? [input characterAtIndex:pos] : 0;
            if (![tran.node matchesCharacter:c])
            {
                if (c == 0) return final;
#ifdef DEBUG
                //NSLog(@"Fail: %@ @ %u", [tran.node displayString:_pattern], pos);
#endif
                continue;
            }
            else
            {
#ifdef DEBUG
                //NSLog(@"Pass: %@ @ %u", [tran.node displayString:_pattern], pos);
#endif
            }
            nextPos += 1;
        }
        
        WTState *s = [self nextState:tran.nextState finalState:final input:input position:nextPos];
        if (s.isFinal)
        {
            if (tran.bypassNode != nil)
                [input insertString:[NSString stringWithFormat:@"%c", tran.bypassNode.character] atIndex:nextPos];
            
            return s;
        }
    }
    
    return nil;
}

@end

@implementation WTReTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lastAcceptedValue = nil;
        _parser = nil;
        [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _lastAcceptedValue = nil;
        _parser = nil;
        [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)dealloc
{
    _lastAcceptedValue = nil;
    _parser = nil;
    [self removeTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setPattern:(NSString *)pattern
{
    if (pattern == nil || [pattern isEqualToString:@""])
        _parser = nil;
    else
        _parser = [[WTReParser alloc] initWithPattern:pattern];
}

- (NSString*)pattern
{
    return _parser.pattern;
}

- (void)formatInput:(UITextField *)textField
{
    if (_parser == nil) return;
    
    __block WTReParser *localParser = _parser;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *formatted = [localParser reformatString:textField.text];
        if (formatted == nil)
            formatted = _lastAcceptedValue;
        else
            _lastAcceptedValue = formatted;
        NSString *newText = formatted;
        if (![textField.text isEqualToString:newText]) {
            textField.text = formatted;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    });
}

//lumin添加
-(void)setText:(NSString *)text
{
    [super setText:text];
    [self formatInput:self];
}

@end

@implementation YLPasswordTextFiled
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat perWidth = (frame.size.width - kPasswordLength + 1)*1.0/kPasswordLength;
    for(NSInteger i=0;i<kPasswordLength;i++){
        if(i < kPasswordLength - 1){
            UILabel *vLine = (UILabel *)[self viewWithTag:kLineTag + i];
            if(!vLine){
                vLine = [[UILabel alloc]init];
                vLine.tag = kLineTag + i;
                [self addSubview:vLine];
            }
            vLine.frame = CGRectMake(perWidth + (perWidth + 1)*i, 0, 1, frame.size.height);
            vLine.backgroundColor = [UIColor grayColor];
        }
        UILabel *dotLabel = (UILabel *)[self viewWithTag:kDotTag + i];
        if(!dotLabel){
            dotLabel = [[UILabel alloc]init];
            dotLabel.tag = kDotTag + i;
            [self addSubview:dotLabel];
        }
        dotLabel.frame = CGRectMake((perWidth + 1)*i + (perWidth - 10)*0.5, (frame.size.height - 10)*0.5, 10, 10);
        dotLabel.layer.masksToBounds = YES;
        dotLabel.layer.cornerRadius = 5;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.hidden = YES;
    }
}

//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}

@end

