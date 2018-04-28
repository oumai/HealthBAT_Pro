//
//  BATWriteTextViewTableViewCell.h
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATWriteTextViewTableViewCell : UITableViewCell

/**
 *  textView
 */
@property (nonatomic,strong) YYTextView *textView;

/**
 *  字数
 */
@property (nonatomic,strong) UILabel *wordCountLabel;

@end
