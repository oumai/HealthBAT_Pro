//
//  BATTextView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/4.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//


#import "BATTextView.h"
@interface BATTextView ()
@property (nonatomic, readwrite) UILabel *numberOfWordsLabel;
@property (nonatomic, readwrite) UILabel *placeholderLabel;
@property (nonatomic, assign) BOOL needsUpdateFont;
@end
@implementation BATTextView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor grayColor];
    self.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.placeholderLabel];
    //    [self addSubview:self.numberOfWordsLabel];
    self.placeholderLabel.textColor = [[self class] defaultPlaceholderColor];
    self.placeholderLabel.font = self.font;
    //    self.numberOfWordsLabel.textColor = self.textColor;
    self.numberOfWordsLabel.font = self.font;
    self.numberOfWordsLabel.textColor = [[self class] defaultPlaceholderColor];
    self.maxNumberOfWords = 100;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaceholderLabel)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}


+ (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return color;
}


#pragma mark -  getter
- (void)setNumberOfWordsLabelHidden:(BOOL)numberOfWordsLabelHidden
{
    _numberOfWordsLabelHidden = numberOfWordsLabelHidden;
    self.numberOfWordsLabel.hidden = numberOfWordsLabelHidden;
    
}

- (void)setMaxNumberOfWords:(NSInteger)maxNumberOfWords
{
    _maxNumberOfWords = maxNumberOfWords;
    [self updatePlaceholderLabel];
}

- (void)setBat_placeholder:(NSString *)bat_placeholder
{
    self.placeholderLabel.text = bat_placeholder;
    [self updatePlaceholderLabel];
}

- (NSString *)bat_placeholder
{
    return self.placeholderLabel.text;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self updatePlaceholderLabel];
}


- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.userInteractionEnabled = NO;
        self.needsUpdateFont = YES;
        [self updatePlaceholderLabel];
        self.needsUpdateFont = NO;
    }
    return _placeholderLabel;
}

- (UILabel *)numberOfWordsLabel
{
    if (!_numberOfWordsLabel) {
        _numberOfWordsLabel = [[UILabel alloc] init];
        _numberOfWordsLabel.text = @"";
        _numberOfWordsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberOfWordsLabel;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (![self.superview.subviews containsObject:self.numberOfWordsLabel]) {
        [self.superview addSubview:self.numberOfWordsLabel];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updatePlaceholderLabel];
    
}

- (void)updateNumberOfWordsLabel
{
    self.numberOfWordsLabel.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - 26, CGRectGetWidth(self.bounds) - self.textContainer.lineFragmentPadding, 26);
    if (self.text.length > _maxNumberOfWords) {
        self.text = [self.text substringToIndex:_maxNumberOfWords];
    }
    self.numberOfWordsLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.text.length),@(_maxNumberOfWords)];
}

- (void)updatePlaceholderLabel
{
    if (self.textChangeBlock) {
        self.textChangeBlock(self.text);
    }
    
    [self updateNumberOfWordsLabel];
    
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    [self insertSubview:self.placeholderLabel atIndex:0];
    
    if (self.needsUpdateFont) {
        self.placeholderLabel.font = self.font;
        self.needsUpdateFont = NO;
    }
    self.placeholderLabel.textAlignment = self.textAlignment;
    
    // `NSTextContainer` is available since iOS 7
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;
    
#pragma deploymate push "ignored-api-availability"
    // iOS 7+
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        lineFragmentPadding = self.textContainer.lineFragmentPadding;
        textContainerInset = self.textContainerInset;
    }
#pragma deploymate pop
    
    // iOS 6
    else {
        lineFragmentPadding = 5;
        textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end

