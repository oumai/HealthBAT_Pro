//
//  BATVideoAndAudioChatViewController.h
//  HealthBAT_Pro
//
//  Created by four on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATTIMManager.h"
#import "BATLoginModel.h"

static NSString * const AGDKeyChannel = @"Channel";
static NSString * const AGDKeyVendorKey = @"VendorKey";

@interface BATVideoAndAudioChatViewController : UIViewController

/**
 *  咨询类型：视频、音频
 */
@property (nonatomic,assign) BATChatType chatType;

/**
 *  声网key
 */
@property (nonatomic,copy) NSString *AGDKeyVendorKey;

/**
 *  房间号
 */
@property (nonatomic,copy) NSString *AGDKeyChannel;

/**
 *  医生ID
 */
@property (nonatomic,copy) NSString *doctorID;

@end
