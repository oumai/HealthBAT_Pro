//
//  BATJSObject.m
//  HealthBAT_Pro
//
//  Created by KM on 16/11/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATJSObject.h"

@implementation BATJSObject

- (void)chooseImage {

    if (self.chooseImageBlock) {
        self.chooseImageBlock();
    }
    
}

- (void)chooseCamera {

    if (self.chooseCameraBlock) {
        self.chooseCameraBlock();
    }
}

- (void)exitChineseMedicine {

    if (self.exitChineseMedicineBlock) {
        self.exitChineseMedicineBlock();
    }

}

- (void)messageVCBackBlock {
    
    if (self.messageVCBackVCBlock) {
        self.messageVCBackVCBlock();
    }
    
}

//-(void)chooseSymptom {
//    if (self.chooseSymptomBlock) {
//        self.chooseSymptomBlock();
//    }
//}
-(void)chooseSymptom:(NSString *)ID {
    if (self.chooseSymptomBlock) {
        self.chooseSymptomBlock(ID);
    }
}

- (void)jumpToLogin
{
    if (self.jumpToLoginBlock) {
        self.jumpToLoginBlock();
    }
}

- (void)goToBatHome {
    
    if (self.goToBatHomeBlock) {
        self.goToBatHomeBlock();
    }
}

- (void)removeAnimation {
    
    if (self.removeAnimationBlock) {
        self.removeAnimationBlock();
    }
}

- (void)goBackDrKang:(NSString *)result {
    
    if (self.goBackDrKangBlock) {
        self.goBackDrKangBlock(result);
    }
}

- (void)DrKangPlayMusic:(NSString *)index {
    
    if (self.DrKangPlayMusicBlock) {
        self.DrKangPlayMusicBlock(index);
    }
}

- (void)mallRemoveAnimation{
    
    if (self.mallRemoveAnimationBlock) {
        self.mallRemoveAnimationBlock();
    }
}

- (void)goToHealthConsultation{
    
    if (self.goToHealthConsultationBlock) {
        self.goToHealthConsultationBlock();
    }
}

- (void)goToHealthSecends{
    
    if (self.goToHealthSecendsBlock) {
        self.goToHealthSecendsBlock();
    }
}

- (void)goToMedicine{
    
    if (self.goToMedicineBlock) {
        self.goToMedicineBlock();
    }
}

- (void)goToDiseases:(NSString *)diseaseID {

    if (self.goToDiseasesBlock) {
        self.goToDiseasesBlock(diseaseID);
    }
}

- (void)goToMemberCenter
{
    if (self.goToMemberCenterBlock) {
        self.goToMemberCenterBlock();
    }
}

- (void)newsCanComment:(NSString *)flag
{
    if (self.newsCanCommentBlock) {
        self.newsCanCommentBlock(flag);
    }
}

- (void)goToDrKang {
    
    if (self.goToDrKangBlock) {
        self.goToDrKangBlock();
    }
}

@end
