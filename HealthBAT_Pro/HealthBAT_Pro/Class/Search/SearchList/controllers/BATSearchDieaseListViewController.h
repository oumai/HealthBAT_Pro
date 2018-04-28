//
//  SearchListViewController.h
//  HealthBAT
//
//  Created by KM on 16/8/32016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BATSearchDieaseListViewController : UIViewController

@property (nonatomic,assign) kSearchType type;
@property (nonatomic,copy) NSString *key;

@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;

@property (nonatomic,strong) NSString *searchUserID;

@property (nonatomic,assign) NSInteger keySourceType;

@property(nonatomic,assign) BOOL isNewAPI;

@property (nonatomic,strong) NSString *searchType;

@property(nonatomic,assign) NSInteger doctorType;

@property (nonatomic,strong) UICollectionView *searchCollectionView;


@end
