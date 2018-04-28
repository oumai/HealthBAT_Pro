//
//  ChooseTreatmentModel.h
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseTreatmentModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *relateship;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *personID;
@property (nonatomic,strong) NSString *memberID;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *CommPersonID;

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger age;   //年龄
@property (nonatomic,assign) NSInteger Gender;//性别

@property (nonatomic,strong) NSString *ages;
@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *photoPath;
@property (nonatomic,strong) NSString *Sex;
@property (nonatomic,assign) BOOL IsPerfect;

@property (nonatomic, copy) NSString *Exercise; //锻炼
@property (nonatomic, copy) NSString *Sleep;  //睡眠质量
@property (nonatomic, copy) NSString *Dietary; //食欲不振
@property (nonatomic, copy) NSString *Mentality; //低落
@property (nonatomic, copy) NSString *Working; //按部就班

@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) BOOL isDefault;
@end
