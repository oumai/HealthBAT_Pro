//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUMessageContentButton.h"
#import "Masonry.h"
@implementation UUMessageContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        

        self.voice = [[UIImageView alloc]init];
        self.voice.image = [UIImage imageNamed:@"语音"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"语音"],
                                      [UIImage imageNamed:@"语音"],
                                      [UIImage imageNamed:@"语音"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        
        
        
        [self addSubview:self.voice];
        

        [self.voice mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 16));
            
        }];
        
    }
    return self;
}

- (void)didLoadVoice
{
    [self.voice startAnimating];
}
-(void)stopPlay
{
  [self.voice stopAnimating];
}





@end
