//
//  BATChatCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATOrderChatModel.h"
@protocol BATChatCellDelegate <NSObject>
-(void)BATChatCellPayBtnAction:(NSIndexPath *)rowPath;
-(void)BATChatCellCancleBtnAction:(NSIndexPath *)rowPath;
-(void)BATChatCellStartBtnAction:(NSIndexPath *)rowPath;
-(void)BATChatCellFinishBtnAction:(NSIndexPath *)rowPath;
@end
@interface BATChatCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *rowPath;
@property (nonatomic,strong) id <BATChatCellDelegate> delegate;
-(void)cellConfigWithChatModel:(OrderResData *)chatModel;
@end
