//
//  BATVerifycodeCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/4.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BATVerifycodeCellDelegate <NSObject>
-(void)BATVerifycodeCellGetVerifyCodeWithBtn:(UIButton *)codeBtn;
@end

@interface BATVerifycodeCell : UITableViewCell

@property (nonatomic,strong) UILabel     *eventLabel;

@property (nonatomic,strong) UITextField   *infotextfiled;

@property (nonatomic,strong) id <BATVerifycodeCellDelegate> delegate;
@end
