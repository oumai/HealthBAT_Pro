//
//  BATJSObject.h
//  HealthBAT_Pro
//
//  Created by KM on 16/11/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectProtocol <JSExport>

- (void)chooseImage;

- (void)chooseCamera;

- (void)exitChineseMedicine;

- (void)messageVCBackBlock;

- (void)jumpToLogin;

- (void)chooseSymptom:(NSString *)ID;

- (void)goToBatHome;

- (void)removeAnimation;

- (void)goBackDrKang:(NSString *)result;

- (void)DrKangPlayMusic:(NSString *)index;

- (void)mallRemoveAnimation;

- (void)goToHealthConsultation;

- (void)goToHealthSecends;

- (void)goToMedicine;

- (void)goToDiseases:(NSString *)diseaseID;

- (void)goToMemberCenter;

- (void)newsCanComment:(NSString *)flag;

- (void)goToDrKang;

@end

@interface BATJSObject : NSObject<JSObjectProtocol>

@property (nonatomic,copy) void(^chooseImageBlock)(void);
@property (nonatomic,copy) void(^chooseCameraBlock)(void);
@property (nonatomic,copy) void(^exitChineseMedicineBlock)(void);
@property (nonatomic,copy) void(^messageVCBackVCBlock)(void);
@property (nonatomic,copy) void(^jumpToLoginBlock)(void);
@property (nonatomic,copy) void(^chooseSymptomBlock)(NSString *ID);
@property (nonatomic,copy) void(^goToBatHomeBlock)(void);
@property (nonatomic,copy) void(^removeAnimationBlock)(void);
@property (nonatomic,copy) void(^goBackDrKangBlock)(NSString *result);
@property (nonatomic,copy) void(^DrKangPlayMusicBlock)(NSString *index);
@property (nonatomic,copy) void(^mallRemoveAnimationBlock)(void);
@property (nonatomic,copy) void(^goToHealthConsultationBlock)(void);
@property (nonatomic,copy) void(^goToHealthSecendsBlock)(void);
@property (nonatomic,copy) void(^goToMedicineBlock)(void);
@property (nonatomic,copy) void(^goToDiseasesBlock)(NSString *diseaseID);
@property (nonatomic,copy) void(^goToMemberCenterBlock)(void);
@property (nonatomic,copy) void(^newsCanCommentBlock)(NSString *flag);
@property (nonatomic,copy) void(^goToDrKangBlock)(void);

@end
