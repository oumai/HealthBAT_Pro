//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMessageContentButton : UIButton



//audio


@property (nonatomic, retain) UIImageView *voice;

- (void)didLoadVoice;

-(void)stopPlay;

@end
