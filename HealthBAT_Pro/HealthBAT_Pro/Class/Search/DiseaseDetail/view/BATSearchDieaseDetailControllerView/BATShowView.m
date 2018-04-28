//
//  BATShowView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATShowView.h"

@interface BATShowView()

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,strong) UIImageView *arrowImage;

@property (nonatomic, strong) UIView *whiteView;
@end

@implementation BATShowView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        [self addTarget:self action:@selector(animationAction) forControlEvents:UIControlEventTouchUpInside];
        
       
        self.whiteView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH - 39, SCREEN_HEIGHT - 64 - 50)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.clipsToBounds = YES;
        self.whiteView.layer.cornerRadius = 5;
        [self addSubview:self.whiteView];
        
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.5f];
        
       
        
        self.showViewTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 15)];
        self.showViewTitle.font = [UIFont systemFontOfSize:15];
        self.showViewTitle.textColor = UIColorFromHEX(0X333333, 1);
        [self.whiteView addSubview:self.showViewTitle];
        
        
        self.showViewBtn = [[BATCustomButton alloc]initWithFrame:CGRectZero]; //CGRectMake(whiteView.frame.size.width - 80, 0, 80, 80)
        [self.showViewBtn addTarget:self action:@selector(animationAction) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:self.showViewBtn];
        
        WEAK_SELF(self);

        [self.showViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.showViewTitle.mas_centerY);
            make.right.equalTo(self.whiteView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(250, 40));
        }];
        
        
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectZero];//CGRectMake(36, 22, 8, 8)
        self.arrowImage.image = [UIImage imageNamed:@"jiantou01"];
        [self.showViewBtn addSubview:self.arrowImage];
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.showViewTitle.mas_centerY);
            make.right.equalTo(self.whiteView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];

        
        CGFloat height = self.whiteView.frame.size.height;
        CGFloat contentOraginY = CGRectGetMaxY(self.showViewTitle.frame);
        
        self.backScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showViewTitle.frame) + 20, self.whiteView.frame.size.width, height - contentOraginY - 40)];
        [self.whiteView addSubview:self.backScroView];
        
        self.showViewContent = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.whiteView.frame.size.width - 40, 100)];
        self.showViewContent.numberOfLines = 0;
        self.showViewContent.font = [UIFont systemFontOfSize:14];
      //  self.showViewContent.lineSpacing = 2.0f;
        self.showViewContent.textColor = UIColorFromHEX(0X666666, 1);
     //   self.showViewContent.enabledTextCheckingTypes = NSTextCheckingTypeLink;        //检测url
     //   self.showViewContent.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;//对齐方式
        [self.backScroView addSubview:self.showViewContent];
        
    }
    return self;
    
}

- (void)calculateContentSizeWithContent:(NSString *)content {
    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
//    
//    
//    //    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    //    [paragraphStyle1 setLineSpacing:10];
//    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]
//                          };

    
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 39 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    
    [self.backScroView setContentSize:CGSizeMake(0, size.height + 20)];
    self.showViewContent.frame = CGRectMake(20, 0, SCREEN_WIDTH - 39 - 40, size.height + 20);
   
}
- (void)delayAction
{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.whiteView.frame = CGRectMake(39, 64, SCREEN_WIDTH - 39, SCREEN_HEIGHT - 64 - 50);
        
    } completion:^(BOOL finished) {
        
    }];

}

- (void)animationStart {

    self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        

        self.arrowImage.image = [UIImage imageNamed:@"jiantou01"];
        
    }];
}

- (void)animationAction {

   // self.showViewBtn.transform = CGAffineTransformIdentity;
    
    self.arrowImage.image = [UIImage imageNamed:@"jiantoud"];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.arrowImage.layer.affineTransform = CGAffineTransformMakeRotation(0);
        self.whiteView.frame = CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH - 39, SCREEN_HEIGHT - 64 - 50);

    } completion:^(BOOL finished) {
      
           self.arrowImage.image = [UIImage imageNamed:@"jiantou01"];
        
        [UIView animateWithDuration:0.2f animations:^{
            //[self removeFromSuperview];
            if (self.complicateBlock) {
                self.complicateBlock();
            }
        }];
    }];
    
}

@end
