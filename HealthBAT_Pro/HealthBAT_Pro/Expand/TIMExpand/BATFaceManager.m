//
//  BATFaceManager.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFaceManager.h"

@implementation BATFaceManager

+ (BATFaceManager *)shared
{
    static BATFaceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATFaceManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FaceConfig" ofType:@"plist"];
        
        _faces = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return self;
}

- (UIImage *)faceWithIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.gif",(long)index]];
    return image;
}

- (NSString *)faceFileNameWithIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld.gif",(long)index];
}

- (NSData *)faceDataWithIndex:(NSInteger)index
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
//    return [NSData dataWithContentsOfFile:path];
    
    NSData *data = nil;
    
    for (NSDictionary *dic in _faces) {
        if ([[dic objectForKey:@"tag"] integerValue] == index) {
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"data"]];
            data = [NSData dataWithContentsOfURL:url];
            break;
        }
    }
    return data;
}

@end
