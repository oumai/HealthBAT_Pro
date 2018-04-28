//
//  BATMainAttendController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMainAttendController.h"
#import "BATMyAttendUserListViewController.h"
#import "BATMyAttendTopicListViewController.h"
//
//#import "BATMyAttendController.h"
//#import "BATTopicController.h"

#import "HMSegmentedControl.h"
#import "UIColor+Gradient.h"
#import "BATPerson.h"


@interface BATMainAttendController ()<UIScrollViewDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BATPerson *loginUserModel;
@property (nonatomic, assign) BOOL isMyHomepage;

@end

@implementation BATMainAttendController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginUserModel = PERSON_INFO;
    
   _isMyHomepage =  [self.accountID isEqualToString:[NSString stringWithFormat:@"%ld",(long)_loginUserModel.Data.AccountID]];
   self.title = _isMyHomepage ? @"我的主页" : @"TA的主页";
    
    self.view.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addSubViewControl];
    
}
- (void)addSubViewControl{
    
//    BATMyAttendController *myAttendUserVC = [[BATMyAttendController alloc]init];
    
    BATMyAttendUserListViewController *myAttendUserVC = [[BATMyAttendUserListViewController alloc]init];

    myAttendUserVC.accountID = self.accountID;
    
    BATMyAttendTopicListViewController *attendTopicVC = [[BATMyAttendTopicListViewController alloc]init];
    
    
//    BATTopicController *attendTopicVC = [[BATTopicController alloc]init];
    attendTopicVC.accountID = self.accountID;
    myAttendUserVC.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    attendTopicVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    
    [self addChildViewController:myAttendUserVC];
    [self addChildViewController:attendTopicVC];
    
    
    [self.scrollView addSubview:myAttendUserVC.view];
    [self.scrollView addSubview:attendTopicVC.view];
    
    
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtr{
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * segmentCtr.selectedSegmentIndex, 0) animated:YES];

}
#pragma UIScrollViewDelegate
/**
 停止减速时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        
    //    计算页码
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
        
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    // 页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
//    CGFloat scrollviewW =  scrollView.frame.size.width;
//    CGFloat x = scrollView.contentOffset.x;
//    int page = (x + scrollviewW / 2) /  scrollviewW;
//    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
//    
//}
#pragma mark - lazy load
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT  - 45 - 64 )];
        _scrollView.contentSize = CGSizeMake( SCREEN_WIDTH *2, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}
- (HMSegmentedControl *)segmentControl{
    if (!_segmentControl) {
        
        
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"用户",@"话题"]];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        //设置底部下划线的高度
        _segmentControl.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentControl.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
        //设置中间分割线显示及颜色
//        _segmentControl.verticalDividerColor = UIColorFromHEX(0xe0e0e0, 1);
//        _segmentControl.verticalDividerEnabled = YES;
        
        
        //设置边框
        _segmentControl.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentControl.layer.borderWidth = 0.5;
        _segmentControl.layer.masksToBounds = YES;
        
        
        //设置底下的线和文字一样大
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //设置文字颜色及字体
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : UIColorFromHEX(0x333333, 1),
                                                   NSFontAttributeName : [UIFont fontWithName:@"PingFang-SC-Regular" size:15]};
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:20],
                                                           NSFontAttributeName :[UIFont fontWithName:@"PingFang-SC-Regular" size:15]};
        
        //添加点击事件
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    DDLogDebug(@"%s---",__func__);
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
