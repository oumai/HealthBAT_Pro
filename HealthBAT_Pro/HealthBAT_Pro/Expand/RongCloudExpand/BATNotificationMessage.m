//
//  BATNotificationMessage.m
//  HealthBAT_Pro
//
//  Created by KM on 17/4/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNotificationMessage.h"
#define KEY_BATMSG_CONTENT @"content"
#define KEY_BATMSG_ACTIONSTATUS @"actionStatus"
#define KEY_BATMSG_ORDERNO @"orderNo"
#define KEY_BATMSG_TARGETID @"targetId"
#define KEY_BATMSG_DOCTORNAME @"doctorName"
#define KEY_BATMSG_PATIENTNAME @"patientName"

@implementation BATNotificationMessage

+ (instancetype)messageWithActionStatus:(NSString *)actionStatus
                                orderNo:(NSString *)orderNo
                               targetId:(NSString *)targetId
                             doctorName:(NSString *)doctorName
                            patientName:(NSString *)patientName {
    
    BATNotificationMessage *msg = [[BATNotificationMessage alloc] init];
    if (msg) {
        msg.actionStatus = actionStatus;
        msg.orderNo = orderNo;
        msg.targetId = targetId;
        msg.doctorName = doctorName;
        msg.patientName = patientName;
    }
    return msg;
}

+ (RCMessagePersistent)persistentFlag {
    
    return MessagePersistent_STATUS;
}


#pragma mark – NSCoding protocol methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_BATMSG_CONTENT];
        self.actionStatus = [aDecoder decodeObjectForKey:KEY_BATMSG_ACTIONSTATUS];
        self.orderNo = [aDecoder decodeObjectForKey:KEY_BATMSG_ORDERNO];
        self.targetId = [aDecoder decodeObjectForKey:KEY_BATMSG_TARGETID];
        self.doctorName = [aDecoder decodeObjectForKey:KEY_BATMSG_DOCTORNAME];
        self.patientName = [aDecoder decodeObjectForKey:KEY_BATMSG_PATIENTNAME];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_BATMSG_CONTENT];
    [aCoder encodeObject:self.actionStatus forKey:KEY_BATMSG_ACTIONSTATUS];
    [aCoder encodeObject:self.orderNo forKey:KEY_BATMSG_ORDERNO];
    [aCoder encodeObject:self.targetId forKey:KEY_BATMSG_TARGETID];
    [aCoder encodeObject:self.doctorName forKey:KEY_BATMSG_DOCTORNAME];
    [aCoder encodeObject:self.patientName forKey:KEY_BATMSG_PATIENTNAME];
    
}

#pragma mark – RCMessageCoding delegate methods

- (NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.actionStatus forKey:KEY_BATMSG_ACTIONSTATUS];
    [dataDict setObject:self.orderNo forKey:KEY_BATMSG_ORDERNO];
    [dataDict setObject:self.targetId forKey:KEY_BATMSG_TARGETID];
    [dataDict setObject:self.doctorName forKey:KEY_BATMSG_DOCTORNAME];
    [dataDict setObject:self.patientName forKey:KEY_BATMSG_PATIENTNAME];
    
    if (self.content) {
        [dataDict setObject:self.content forKey:KEY_BATMSG_CONTENT];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    
    if (json) {
        self.content = json[KEY_BATMSG_CONTENT];
        self.actionStatus = json[KEY_BATMSG_ACTIONSTATUS];
        self.orderNo = json[KEY_BATMSG_ORDERNO];
        self.targetId = json[KEY_BATMSG_TARGETID];
        self.doctorName = json[KEY_BATMSG_DOCTORNAME];
        self.patientName = json[KEY_BATMSG_PATIENTNAME];
        
        NSObject *__object = [json objectForKey:@"user"];
        NSDictionary *userinfoDic = nil;
        if (__object &&[__object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic =(NSDictionary *)__object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"id"];
            userinfo.name =[userinfoDic objectForKey:@"name"];
            userinfo.portraitUri =[userinfoDic objectForKey:@"icon"];
            self.senderUserInfo = userinfo;
        }
        
    }
}

+ (NSString *)getObjectName {
    
    return @"BATNotificationMessage";
}

@end
