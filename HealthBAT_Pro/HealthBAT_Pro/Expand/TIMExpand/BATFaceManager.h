//
//  BATFaceManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATFaceManager : NSObject

@property (nonatomic,strong) NSMutableArray *faces;

+ (BATFaceManager *)shared;

- (UIImage *)faceWithIndex:(NSInteger)index;

- (NSString *)faceFileNameWithIndex:(NSInteger)index;

- (NSData *)faceDataWithIndex:(NSInteger)index;

@end
