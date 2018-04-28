//
//  testModel.h
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATDieaseDetailEntityModel : NSObject
@property(nonatomic,strong)NSArray *DieaseInfo;
@property(nonatomic,strong)NSArray *treatmentArr;
@property(nonatomic,strong)NSMutableArray *relateDieaseArr;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *detailLb;
@property(nonatomic,assign)BOOL isOpen;

/*
 @property(nonatomic,strong)UIButton *upLeftBtn;
 @property(nonatomic,strong)UIButton *upRightBtn;
 @property(nonatomic,strong)UIButton *downLeftBtn;
 @property(nonatomic,strong)UIButton *downRightBtn;
 
 
 */

@property(nonatomic,assign)BOOL isExaimBtnShow;
@property(nonatomic,assign)BOOL isTreatmentBtnShow;
@property(nonatomic,assign)BOOL isNurseBtnShow;

@property(nonatomic,assign)BOOL upLeftIsOpen;
@property(nonatomic,assign)BOOL upRightIsOpen;
@property(nonatomic,assign)BOOL downLeftIsOpen;
@property(nonatomic,assign)BOOL downRightIsOpen;

@property(nonatomic,assign)BOOL treatmentIsOpen;
@property(nonatomic,assign)NSInteger treatmentsCount;

@property(nonatomic,assign)NSInteger detailCount;
@property(nonatomic,assign)NSInteger downDetailCount;

@property(nonatomic,assign)BOOL RelateExaminIsOpen;
@property(nonatomic,assign)BOOL RelateTreatmentIsOpen;
@property(nonatomic,assign)BOOL RelateNurseIsOpen;
@end
