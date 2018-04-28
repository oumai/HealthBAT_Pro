//
//  BATMessageCenterViewController.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMessageCenterViewController.h"
#import "BATMessageViewController.h"
#import "BATMessageListViewController.h"
#import "BATHeaderView.h"
#import "YCXMenu.h"

#define kSegmentHeight 45
@interface BATMessageCenterViewController ()
<
UIScrollViewDelegate,
BATHeaderViewDelegate
>
@property (nonatomic ,strong) UIScrollView                  *scrollView;
@property (nonatomic ,strong) BATHeaderView                 *segmentHeaderV;

@property (nonatomic ,strong) NSArray                       *items;
@property (nonatomic,assign) NSInteger          type;

@property (nonatomic,strong) BATMessageViewController *messageVC;
@property (nonatomic,strong) BATMessageListViewController *privateMessageVC;

@end

@implementation BATMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupUI];
}

#pragma mark -- private
- (void)setupUI {
    [self.view addSubview:self.segmentHeaderV];
    [self.view addSubview:self.scrollView];
    
    self.messageVC = [[BATMessageViewController alloc] init];
    self.messageVC.view.frame =  CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.frame));
    [self addChildViewController:self.messageVC];
    [self.scrollView addSubview:self.messageVC.view];

    self.privateMessageVC = [[BATMessageListViewController alloc] init];
    self.privateMessageVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.frame));
    [self addChildViewController:self.privateMessageVC];
    [self.scrollView addSubview:self.privateMessageVC.view];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 6)];
    [rightBtn setImage:[UIImage imageNamed:@"icon-zwzd-gd"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark -- BATHeaderViewDelegate
- (void)BATHeaderViewSeleWithPage:(NSInteger)pages {
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*pages, 0) animated:YES];
    
    if (pages == 0) {
        self.title = @"消息";
    }
    else {
        self.title = @"私信";
    }
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger pages = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self.segmentHeaderV setLineViewPostionWihPage:pages];

        if (pages == 0) {
            self.title = @"消息中心";
        }
        else {
            self.title = @"私信";
        }
    }
}

#pragma mark - action
- (void)moreAction:(id)sender{
    
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu setHasShadow:YES];
        [YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectSolid];
        [YCXMenu setSeparatorColor:BASE_LINECOLOR];
        [YCXMenu setCornerRadius:5.f];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 55, 0, 60, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            DDLogDebug(@"%@",item.userInfo);
            
            BOOL type = [item.userInfo[@"type"] boolValue];
            [YCXMenu dismissMenu];
            
            if (type) {
                //全部标记已读,并且全部删除!
                DDLogInfo(@"全部标记已读！并且全部删除！");
                
                [self.messageVC deleteAllMessageRequest];
            }else{
                //全部标记已读
                DDLogInfo(@"全部标记已读！");
                
                [self.messageVC  setAllReadRequest];
            }
        }];
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }
}

#pragma mark -- setter & getter
- (UIScrollView *)scrollView{
    if(!_scrollView){
        CGFloat segmentControlH  = CGRectGetMaxY(self.segmentHeaderV.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentControlH+1, SCREEN_WIDTH, SCREEN_HEIGHT-segmentControlH-1)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (BATHeaderView *)segmentHeaderV {
    if (!_segmentHeaderV) {
        _segmentHeaderV = [[BATHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [_segmentHeaderV.chatBtn setTitle:@"消息" forState:UIControlStateNormal];
        [_segmentHeaderV.bookBtn setTitle:@"私信" forState:UIControlStateNormal];
        [_segmentHeaderV selectPages:0];
        [_segmentHeaderV setLineViewPostionWihPage:0];
        _segmentHeaderV.delegate = self;
    }
    return _segmentHeaderV;
}

- (NSArray *)items {
    if (!_items) {
        _items = @[
                   [YCXMenuItem menuItem:@"全部标记为已读"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@0}],
                   [YCXMenuItem menuItem:@"全部清除"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@1}]
                   ];
        
        YCXMenuItem *allMenuTitle = _items[0];
        allMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        allMenuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
        
        
        YCXMenuItem *deleteMenuTitle = _items[1];
        deleteMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        deleteMenuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
        
    }
    return _items;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
