//
//  BATSearchSimpleModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/9/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//    BATSearchListViewController * searchListVC = [BATSearchListViewController new];
//    searchListVC.title = title;
//    searchListVC.type = type;
//    searchListVC.key = self.searchResultModel.key;
//    searchListVC.lat = self.lat;
//    searchListVC.lon = self.lon;
//    searchListVC.keySourceType = self.keywordSource;
//    searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
//    [self.navigationController pushViewController:searchListVC animated:YES];

@interface BATSearchSimpleModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) NSString *key;

@property (nonatomic,assign) CGFloat lat;

@property (nonatomic,assign) CGFloat lon;

@property (nonatomic,assign) NSInteger keySourceType;

@property (nonatomic,strong) NSString *searchUserID;

@end
