//
//  BATConsultationOrderViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationOrderViewController.h"

@interface BATConsultationOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation BATConsultationOrderViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _consultationOrderView.tableView.delegate = nil;
    _consultationOrderView.tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_consultationOrderView == nil) {
        _consultationOrderView = [[BATConsultationOrderView alloc] init];
        _consultationOrderView.tableView.delegate = self;
        _consultationOrderView.tableView.dataSource = self;
        [self.view addSubview:_consultationOrderView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
