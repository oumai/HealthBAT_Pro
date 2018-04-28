//
//  BATTrainStudioListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATTrainStudioListModel : NSObject
//ReplyNum = 0,
//TeacherName = 哈哈大叔,
//Auditing = 2,
//AuditPersonID = 58a6b55dbb4c0d2f70b06b68,
//CourseCategoryAlias = 护理学,
//ReadingNum = 1,
//AuditingAlias = 已发布,
//CreatedTime = 2017-06-19 17:55:56,
//TeacherDesc = ,
//CollectNum = 0,
//PhotoPath = ,
//Poster = http://upload.jkbat.com/Files/20170619/5u4iaynf.va1.jpg,
//CourseTypeAlias = 图文,
//ClassHour = 0,
//IsCollection = 0,
//CourseCategory = 1,
//CourseTitle = GG,
//Id = 59479fac1a4c650d383b7e33,
//NickName = ,
//TrueName = ,
//AccountId = 594343f31a4c6510ec77657f,
//IsSetStar = 0,
//MainContent = <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"> <style>img{max-width: 100%; width:auto; height:auto;}</style><div><img src="http://upload.jkbat.com/Files/20170619/5u4iaynf.va1.jpg" style="padding-left:10%%;padding-right:10%% height:auto;width:80%%;"></div>停车场吃v复合弓富贵花<br><i>刚回家光棍节</i>v句拒绝<i>性高潮广场<sub>凤凰凤凰干活<u>v加不加班看</u></sub></i>,
//AttachmentUrl = ,
//CourseDesc = 衣服凤凰凤凰,
//CourseType = 13,
//AuditContent = 审核通过

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *Poster;
@property (nonatomic, strong) NSString *CourseCategoryAlias;
@property (nonatomic, strong) NSString *CourseTitle;
/**
 浏览数
 */
@property (nonatomic, assign) NSInteger ReadingNum;
@property (nonatomic, strong) NSString *CourseDesc;
@property (nonatomic, strong) NSString *CollectNum;
@property (nonatomic, strong) NSString *MainContent;
@property (nonatomic, assign) NSInteger CourseType;
/** 视频分类 */
@property (nonatomic, assign) NSInteger  CourseCategory;
/** <#属性描述#> */
@property (nonatomic, strong) NSString *AuditingAlias;


@end
