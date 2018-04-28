//
//  BATSystemMessageViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSystemMessageViewController.h"

@interface BATSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView        *messageTableView;

@end

@implementation BATSystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统消息";
    
    [self layoutPages];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    return -50;
//}
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    return [[NSAttributedString alloc] initWithString:@"敬请期待"];
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    return [[NSAttributedString alloc] initWithString:@"升级中..."];
//}
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    return [UIImage imageNamed:@"iconfont--search-no"];
//}


#pragma mark - layout
- (void)layoutPages {
    [self.view addSubview:self.messageTableView];
}


#pragma mark - getter && setter
- (UITableView *)messageTableView {
    
    if (!_messageTableView) {
        
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.emptyDataSetSource = self;
        _messageTableView.emptyDataSetDelegate = self;
        _messageTableView.tableFooterView = [[UIView alloc] init];
    }
    return _messageTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
