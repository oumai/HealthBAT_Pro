//
//  BATGroupMemberViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupMemberView.h"
#import "BATGroupModel.h"

@interface BATGroupMemberViewController : UIViewController

@property (nonatomic,strong) BATGroupMemberView *groupMemberView;

/**
 *  群组ID
 */
@property (nonatomic,assign) NSInteger groupID;


/**
 *  是否已经加入改群组
 */
@property (nonatomic,assign) BOOL isJoined;

@end
