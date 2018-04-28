//
//  BATHealthThreeSecondsEmojiView.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondsEmojiView : UIView
@property (nonatomic, assign)NSInteger selIndex;
@property (nonatomic, copy)void(^emojiButtonBlock)(NSInteger emojiBtnTag);
@end
