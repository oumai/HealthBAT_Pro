//
//  BATRegistrationRecordModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegistrationRecordModel.h"

@implementation BATRegistrationRecordModel

//- (id)initWithHospitalDic:(NSDictionary *)hospitalDic
//{
//    self = [super init];
//    if (self) {
//        self.name = [hospitalDic objectForKey:@"TRUENAME"];
//        self.begintime = [hospitalDic objectForKey:@"BEGIN_TIME"];
//        self.phoneNum = [hospitalDic objectForKey:@"PHONE"];
//        self.address = [hospitalDic objectForKey:@"UNIT_NAME"];
//        self.docName = [hospitalDic objectForKey:@"DOCTOR_NAME"];
//        //        self.record_id = [hospitalDic objectForKey:@"record_id"];
//        //        self.OrderState = [hospitalDic objectForKey:@"OrderState"];
//        self.registerState = [[hospitalDic objectForKey:@"YUYUE_STATE"] intValue];
//        self.yuyue_id = (NSString *)[hospitalDic objectForKey:@"YUYUE_ID"];
//        //        self.canCancel = [[hospitalDic objectForKey:@"CAN_CANCEL"] boolValue];
//        self.toDate = [hospitalDic objectForKey:@"TO_DATE"];
//    }
//    return self;
//}


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATRegistrationRecordData class]};
}
@end
@implementation BATRegistrationRecordData

@end


