//
//  BATSegmentControl.m
//  Demo999
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 wangxun. All rights reserved.
//

#import "BATSegmentControl.h"

#define kStartTag 100
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface BATSegmentButton ()
{
    NSArray *_gradientColors; //存储渐变色数组
}

@end

@implementation BATSegmentButton

- (void)setGradientColors:(NSArray<UIColor *> *)colors {
    _gradientColors = [NSArray arrayWithArray:colors];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_gradientColors) {
        [self setTitleGradientColors:_gradientColors Rect:rect];
    }
}

- (void)setTitleGradientColors:(NSArray<UIColor *> *)colors Rect:(CGRect)rect {
    if (colors.count == 1) { //只有一种颜色，直接上色
        [self setTitleColor:colors[0] forState:UIControlStateNormal];
    } else {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于titleLabel属性的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        
        /*这段是设置文字的渐变*/
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        gradientLayer.locations=@[@0.0,@1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        
        //是否需要自定义字体颜色
        if (!self.titleColor) {
            [self setTitleColor:[UIColor colorWithPatternImage:gradientImage] forState:UIControlStateNormal];
        }else {
            [self setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
        
        
        /*------------------------------------------------------------------------*/
        //self.enbleGraditor 由外部传入，设置是否需要渐变层，默认是bool值是NO，这里取反为一般情况，有需要再由外部传入YES取消渐变层
        if (!self.enbleGraditor) {
            //这个是设置第一层背景色
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.locations=@[@0.0,@1.0];
            gradient.startPoint = CGPointMake(0, 0);
            gradient.endPoint = CGPointMake(1, 0);
            
            gradient.colors = [NSArray arrayWithObjects:gradientColors[0], gradientColors[1], nil];
            
            
            
            //第二层添加到第一层上面去，形成镂空效果
            if (!self.enablehollowOut) {
                
                //这个是设置第二层背景色
                CAGradientLayer *gradient11 = [CAGradientLayer layer];
                gradient11.frame = CGRectMake(1, 1, rect.size.width-2, rect.size.height - 2);
                gradient11.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor]CGColor], (id)[[UIColor whiteColor] CGColor], nil];
                gradient11.cornerRadius = 5;
                gradient11.masksToBounds = YES;
                
                [gradient addSublayer:gradient11];
            }
            
            
            [self.layer insertSublayer:gradient atIndex:0];
        }
        
        
        
    }
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}



@end

@interface BATSegmentControl ()

@property (nonatomic, strong) NSMutableArray *buttons; //所有按钮的数组
@property (nonatomic, strong) BATSegmentButton *footScrollLine;//底部滑块
@property (nonatomic, strong) UIView *centerLineView;//底部滑块
@property (nonatomic, strong) BATSegmentButton *currentSelectedBtn;//当前选中按钮

@end
@implementation BATSegmentControl

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super init]) {
        _items = items;
        _segementBgColor = [UIColor whiteColor];
        _segementSelTitleColor = [UIColor blueColor];
        _segementNorTitleColor = [UIColor blackColor];
        _segHeight = 45;
        _textFont = 14.0f;
        _buttons = [NSMutableArray array];
        
        [self commonInit];
    }
    
    return self;
}

+ (instancetype)segmentedControlWithItems:(NSArray *)items
{
    return [[BATSegmentControl alloc] initWithItems:items];
}


- (void)commonInit
{
    
    self.backgroundColor = self.segementBgColor;
    self.clipsToBounds = YES;
    for (NSString *title in _items) {
        NSInteger i = [_items indexOfObject:title];
        BATSegmentButton *btn = [BATSegmentButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kStartTag + i;
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        [btn setTitle:_items[i] forState:UIControlStateSelected];
        [btn setTitleColor:self.segementNorTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segementSelTitleColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.textFont];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        [self addSubview:btn];
        if (i == 0) {
            [self btnClick:btn];
        }
        
    }
    [self addSubview:self.footScrollLine];
    [self addSubview:self.centerLineView];
    _centerLineView.hidden = _items.count > 2 ? YES : NO;
    
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if (items.count == _buttons.count) {
        for (BATSegmentButton *button in _buttons) {
            NSInteger index = [_buttons indexOfObject:button];
            [button setTitle:items[index] forState:UIControlStateNormal];
            [button setTitle:items[index] forState:UIControlStateSelected];
        }
        
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    //    _selectedIndex = selectedIndex;
    if (selectedIndex < 0 || selectedIndex > _buttons.count - 1) {
        return;
    }
    BATSegmentButton *indexBtn = [_buttons objectAtIndex:selectedIndex];
    [self btnClick:indexBtn];
}


- (void)btnClick:(BATSegmentButton *)btn
{
    if ([btn isEqual:_currentSelectedBtn]) {
        return;
    }
    for (BATSegmentButton *button in self.buttons) {
        if (button == btn) {
            [button setGradientColors:@[START_COLOR,END_COLOR]];
            button.enbleGraditor = YES;
        }else{
            [button setGradientColors:@[UIColorFromHEX(0x333333, 1),UIColorFromHEX(0x333333, 1)]];
            button.enbleGraditor = YES;
        }
        
    }
//        btn.selected = YES;
//        _currentSelectedBtn.selected = NO;
        _preSelctedIndex = _currentSelectedBtn.tag - kStartTag;
        _currentSelectedBtn = btn;
       _selectedIndex = btn.tag - kStartTag;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(batSegmentedControl:selectedIndex:)] ) {
        [self.delegate batSegmentedControl:self selectedIndex:_selectedIndex];
    }
}

- (void)setSegHeight:(CGFloat)segHeight
{
    _segHeight = segHeight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat btnW = SCREENW/_items.count;
    CGFloat allHeight = self.segHeight;
//    NSString *title = [_currentSelectedBtn titleForState:UIControlStateNormal];
//    CGFloat titleH = [self sizeForTitle:title withFont:[UIFont systemFontOfSize:14]].height;
//    CGFloat btnY = (allHeight - titleH)/2;
    for (UIButton *button in _buttons) {
        NSInteger i = [_buttons indexOfObject:button];
        CGFloat btnX = i * btnW;
        button.frame = CGRectMake(btnX, 5, btnW, allHeight - 10);
    }
    
    
    CGPoint centerPoint =  self.footScrollLine.center;
    centerPoint.x = _currentSelectedBtn.center.x;
    
    CGRect bounds = self.footScrollLine.bounds;
//    bounds.size.width = [self sizeForTitle:title withFont:[UIFont systemFontOfSize:15]].width;
    CGFloat W = self.items.count > 2 ? btnW : 252/2;
    bounds.size.width = W;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.footScrollLine.center = centerPoint;
        self.footScrollLine.bounds = bounds;
    }];
    
    CGRect frame = self.footScrollLine.frame;
    frame.origin.y = self.frame.size.height - 2;;
    self.footScrollLine.frame = frame;
    
    self.centerLineView.frame = CGRectMake(SCREENW/2, (self.bounds.size.height -15)/2, 1, 15);
    
    
}
- (UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc]init];
        _centerLineView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
        
    }
    return _centerLineView;
}
- (BATSegmentButton *)footScrollLine
{
    if (!_footScrollLine) {
        _footScrollLine = [BATSegmentButton buttonWithType:UIButtonTypeCustom];
        _footScrollLine.enablehollowOut = YES;
        [_footScrollLine setGradientColors:@[START_COLOR,END_COLOR]];
        _footScrollLine.frame = CGRectMake(0, 45 - 1 , SCREENW / _items.count, 1.5);
    }
    return _footScrollLine;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat w = SCREENW;
    frame = CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);
    [super setFrame:frame];
}


- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}
- (void)setTextFont:(CGFloat)textFont{
    _textFont = textFont;
}
- (void)setSegementNorTitleColor:(UIColor *)segementNorTitleColor{
    _segementNorTitleColor = segementNorTitleColor;
}
- (void)setSegementSelTitleColor:(UIColor *)segementSelTitleColor{
    _segementSelTitleColor = segementSelTitleColor;
    
}
- (void)setSegementBgColor:(UIColor *)segementBgColor{
    _segementBgColor = segementBgColor;
    self.backgroundColor = segementBgColor;
}

@end
