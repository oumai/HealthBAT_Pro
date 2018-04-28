//
//  BATProgramDetailViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramDetailViewController.h"
#import "BATdrugTableViewcell.h"
#import "BATProgramDetailModel.h"
#import "BATProgramDescriptionTableViewCell.h"
#import "BATProgramPunchCardTableViewCell.h"
#import "BATProgramItemTableViewCell.h"
#import "BATProgramItemArrowTableViewCell.h"
#import "BATSingleTitleCell.h"
#import "BATRelatedProgramTableViewCell.h"
#import "BATExecutePointsViewController.h"
#import "BATHomeMallViewController.h"
#import "UINavigationController+ShouldPopOnBackButton.h"
//#import "BATCourseNewDetailViewController.h"
#import "BATClockManager.h"
#import <UserNotifications/UserNotifications.h>
#import "BATPunchCardViewController.h"
#import "UIScrollView+ScalableCover.h"
#import "BATProgramAlarmTableViewCell.h"

#import "BATCalendarCell.h"

static NSString *const CalendarCellID = @"BATCalendarCell";

@interface BATProgramDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATProgramDetailModel *programDetailModel;

/**
 是否展开Section
 */
@property (nonatomic,assign) BOOL isOpen;

/**
 计时器
 */
@property (nonatomic,strong) NSTimer *timer;

/**
 离开当前界面
 */
@property (nonatomic,assign) BOOL isLeave;


@end

@implementation BATProgramDetailViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.isLeave = NO;
    
    //    [self checkClockIn];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:BASE_LINECOLOR]];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.isLeave = YES;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.programDetailView.tableView registerClass:[BATProgramDescriptionTableViewCell class] forCellReuseIdentifier:@"BATProgramDescriptionTableViewCell"];
    [self.programDetailView.tableView registerClass:[BATProgramPunchCardTableViewCell class] forCellReuseIdentifier:@"BATProgramPunchCardTableViewCell"];
    [self.programDetailView.tableView registerClass:[BATProgramItemTableViewCell class] forCellReuseIdentifier:@"BATProgramItemTableViewCell"];
    [self.programDetailView.tableView registerClass:[BATProgramItemArrowTableViewCell class] forCellReuseIdentifier:@"BATProgramItemArrowTableViewCell"];
    
    [self.programDetailView.tableView registerNib:[UINib nibWithNibName:@"BATSingleTitleCell" bundle:nil
                                                   ] forCellReuseIdentifier:@"BATSingleTitleCell"];
    [self.programDetailView.tableView registerClass:[BATRelatedProgramTableViewCell class] forCellReuseIdentifier:@"BATRelatedProgramTableViewCell"];
    [self.programDetailView.tableView registerClass:[BATdrugTableViewcell class] forCellReuseIdentifier:@"BATdrugTableViewcell"];
    
    [self.programDetailView.tableView registerClass:[BATCalendarCell class] forCellReuseIdentifier:CalendarCellID];
    [self.programDetailView.tableView registerClass:[BATProgramAlarmTableViewCell class] forCellReuseIdentifier:@"BATProgramAlarmTableViewCell"];
    
    
    _isOpen = NO;
    
    //    [self.programDetailView.tableView.mj_header beginRefreshing];
    
    [self requestGetProgrammeDeltails];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)navigationShouldPopOnBackButton {
//
//    BOOL flag = YES;
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//
//        if ([vc isKindOfClass:[BATCourseNewDetailViewController class]]) {
//
//            flag = NO;
//
//            [self.navigationController popToViewController:vc animated:YES];
//
//            break;
//        }
//    }
//
//    return flag;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.programDetailModel && self.programDetailModel.Data.IsSelected) {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.programDetailModel) {
        if (section == 0) {
            return self.programDetailModel.Data.IsSelected ? 1 : 2;
        } else if (section == 1 && self.programDetailModel.Data.IsSelected) {
            //加入方案后第二个section显示打卡提醒推送
            return 1;
        } else if (section == [tableView numberOfSections] - 3) {
            //最后第三个显示子方案列表
            if (_isOpen) {
                return self.programDetailModel.Data.ProgrammeLst.count + 1;
            }
            
            return self.programDetailModel.Data.ProgrammeLst.count > 3 ? 4 : self.programDetailModel.Data.ProgrammeLst.count;
        } else if (section == [tableView numberOfSections] - 2) {
            //最后第二个Section显示日历打卡记录
            return 2;
        } else if (section == [tableView numberOfSections] - 1) {
            //最后一个section显示推荐方案和药品
            if (self.programDetailModel.Data.ProductList.count > 0) {
                return 4;
            }
            return 2;
        }
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (self.programDetailModel.Data.IsSelected) {
            if (indexPath.row == 0) {
                return 65;
            }
        } else {
            if (indexPath.row == 1) {
                return 65;
            }
        }
    } else if (indexPath.section == [tableView numberOfSections] - 2) {
        //最后第二个Section显示日历打卡记录
        return indexPath.row == 0 ? 45 : 250;
    } else if (indexPath.section == [tableView numberOfSections] - 1) {
        //最后一个section显示推荐方案和药品
        if (indexPath.row == 0 || indexPath.row == 2) {
            return 45;
        } else if (indexPath.row == 1) {
            
            if (self.programDetailModel.Data.RelevantSolutionList.count > 0) {
                return 124;
            }else {
                return 0;
            }
            
        } else if (indexPath.row == 3) {
            
            if (self.programDetailModel.Data.ProductList.count > 0) {
                return 120;
            }else {
                return 0;
            }
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            
            BATProgramPunchCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATProgramPunchCardTableViewCell" forIndexPath:indexPath];
            
            if (self.programDetailModel != nil) {
                cell.countLabel.text = [NSString stringWithFormat:@"%ld次",(long)self.programDetailModel.Data.ALLClockInCount];
                [cell loadUsers:self.programDetailModel.Data.ClockInList];
            }
            
            cell.titleLabel.text = @"打卡";
            return cell;
            
        } else {
            BATProgramDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATProgramDescriptionTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"方案说明";
            if (self.programDetailModel != nil) {
                cell.descLabel.text = self.programDetailModel.Data.SolutionsThat;
            }
            return cell;
        }
        
    } else if (indexPath.section == 1 && self.programDetailModel.Data.IsSelected) {
        //加入方案后第二个section显示打卡提醒推送
        BATProgramAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATProgramAlarmTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"打卡提醒推送";
        cell.alarmSwitch.on = self.programDetailModel.Data.IsFlag;
        
        WEAK_SELF(self);
        cell.alarmBlock = ^(BOOL flag) {
            STRONG_SELF(self);
            [self switchClock:flag];
        };
        
        return cell;
        
    } else if (indexPath.section == [tableView numberOfSections] - 3) {
        //最后第三个显示子方案列表
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 && _programDetailModel.Data.ProgrammeLst.count > 3) {
            BATProgramItemArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATProgramItemArrowTableViewCell" forIndexPath:indexPath];
            
            cell.arrowImageView.image = !_isOpen ? [UIImage imageNamed:@"iconfont-arrow-down"] : [UIImage imageNamed:@"iconfont-arrow-up-1"];
            
            return cell;
        }
        
        BATProgramItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATProgramItemTableViewCell" forIndexPath:indexPath];
        
        if (self.programDetailModel.Data.ProgrammeLst.count > 0) {
            
            BATProgramItem *programItem = self.programDetailModel.Data.ProgrammeLst[indexPath.row];
            
            cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",programItem.JobTime,programItem.Title];
            cell.descLabel.text = programItem.ResultDesc;
        }
        
        return cell;
        
    } else if (indexPath.section == [tableView numberOfSections] - 2) {
        //最后第二个Section显示日历打卡记录
        if (indexPath.row == 0) {
            
            BATSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSingleTitleCell"];
            cell.titleLb.textColor = UIColorFromHEX(0X333333, 1);
            cell.titleLb.font = [UIFont systemFontOfSize:15];
            [cell setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
            cell.titleLb.text = @"打卡记录";
            
            return  cell;
            
        }else{
            
            BATCalendarCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:CalendarCellID];
            calendarCell.datesSelected =  self.programDetailModel.Data.ClockInTimeListFormat;
            calendarCell.ClockFirstAndLastDate = self.programDetailModel.Data.ClockFirstAndLastDate;
            return calendarCell;
        }
        
    } else if (indexPath.section == [tableView numberOfSections] - 1) {
        //最后一个section显示推荐方案和药品
        if (indexPath.row == 0 || indexPath.row == 2) {
            //        if (indexPath.row == 0) {
            
            BATSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSingleTitleCell"];
            cell.titleLb.textColor = UIColorFromHEX(0X333333, 1);
            cell.titleLb.font = [UIFont systemFontOfSize:15];
            [cell setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
            //            cell.titleLb.text = @"相关方案";
            
            if (indexPath.row == 0) {
                cell.titleLb.text = @"相关方案";
            } else {
                cell.titleLb.text = @"大家买了";
            }
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            BATRelatedProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRelatedProgramTableViewCell" forIndexPath:indexPath];
            
            if (self.programDetailModel.Data.RelevantSolutionList.count > 0) {
                [cell loadData:self.programDetailModel.Data.RelevantSolutionList];
                
                WEAK_SELF(self);
                cell.relatedProgramBlock = ^(NSIndexPath *cellIndexPath) {
                    STRONG_SELF(self);
                    
                    BATRelevantSolutionItem *item = [self.programDetailModel.Data.RelevantSolutionList objectAtIndex:cellIndexPath.row];
                    
                    BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];
                    
                    programDetailVC.templateID = item.ID;
                    programDetailVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:programDetailVC animated:YES];
                };
            }
            
            return cell;
            
        } else {
            
            BATdrugTableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATdrugTableViewcell"];
            if (self.programDetailModel != nil) {
                cell.dataArry = self.programDetailModel.Data.ProductList;
            }
            
            WEAK_SELF(self);
            cell.didselectBlock = ^(NSIndexPath *path) {
                STRONG_SELF(self);
                ProductList *list = self.programDetailModel.Data.ProductList[path.row];
                
                NSString *url = [NSString stringWithFormat:@"http:m.km1818.com/products/%@.html?kmCloud",list.Sku_ID];
                
                BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
                homeMallVC.url = url;
                homeMallVC.title = list.PRODUCT_NAME;
                homeMallVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homeMallVC animated:YES];
                
            };
            return cell;
            
        }
    }
    
    return nil;
    
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = 1;
    
    if (self.programDetailModel.Data.IsSelected) {
        row = 2;
    }

    if (indexPath.section == row) {
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 && self.programDetailModel.Data.ProgrammeLst.count > 3) {
            
            _isOpen = !_isOpen;
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    } if (indexPath.section == 0) {
        if (self.programDetailModel.Data.IsSelected) {
            
            if (indexPath.row == 0) {
                BATPunchCardViewController *punchCardVC = [[BATPunchCardViewController alloc] init];
                punchCardVC.templateID = self.templateID;
                punchCardVC.title = self.programDetailModel.Data.Remark;
                [self.navigationController pushViewController:punchCardVC animated:YES];
            }
            
        } else {
            if (indexPath.row == 1) {
                BATPunchCardViewController *punchCardVC = [[BATPunchCardViewController alloc] init];
                punchCardVC.templateID = self.templateID;
                punchCardVC.title = self.programDetailModel.Data.Remark;
                [self.navigationController pushViewController:punchCardVC animated:YES];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (!self.isLeave) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 50) {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:BASE_LINECOLOR]];
            self.navigationItem.title = self.programDetailModel.Data.Remark;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationItem.title = @"";
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
    
}

#pragma mark - Action
- (void)switchClock:(BOOL)flag
{
    [self requestIsAlarmClock:flag];
}

- (void)refresh:(NSNotification *)notif
{
    [self requestGetProgrammeDeltails];
}

- (void)settingClock:(BOOL)flag
{
    BATClockManager *clockManager = [BATClockManager shared];
    
    if (flag) {
        for (BATProgramItem *programItem in self.programDetailModel.Data.ProgrammeLst) {
            
            [clockManager settingClock:programItem.Title body:programItem.ResultDesc clockTime:programItem.JobTime identifier:[NSString stringWithFormat:@"template_%ld_%ld",(long)self.templateID,(long)programItem.ID] nextDay:self.programDetailModel.Data.IsSecondDayOpenclock];
            
        }
    } else {
        
        NSMutableArray *identifiers = [NSMutableArray array];
        for (BATProgramItem *programItem in self.programDetailModel.Data.ProgrammeLst) {
            [identifiers addObject:[NSString stringWithFormat:@"template_%ld_%ld",(long)self.templateID,(long)programItem.ID]];
        }
        
        [clockManager removeClock:identifiers];
    }
}

- (BOOL)checkClockIn
{
    
    if (self.programDetailModel != nil && self.programDetailModel.Data.IsSelected) {
        
        BATProgramItem *lastProgramItem = self.programDetailModel.Data.ProgrammeLst.firstObject;
        
        NSArray *times = [lastProgramItem.JobTime componentsSeparatedByString:@":"];
        
        NSInteger hour = [[times objectAtIndex:0] integerValue];
        NSInteger minute = [[times objectAtIndex:1] integerValue];
        
        NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
        
        if ((components.hour > hour) || (components.hour == hour && components.minute > minute)) {
            
            return YES;
            //            self.programDetailView.taskStateButton.hidden = YES;
            //            self.programDetailView.punchCardButton.hidden = NO;
            //
            //            [self.programDetailView.punchCardButton setTitle:[NSString stringWithFormat:@"打卡第%ld天",(long)self.programDetailModel.Data.ClockInCount] forState:UIControlStateNormal];
            //
            //            WEAK_SELF(self);
            //            [self.programDetailView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            //                STRONG_SELF(self);
            //                make.bottom.equalTo(self.programDetailView.mas_bottom).offset(-57.5);
            //            }];
            
        }
        
        
        //        WEAK_SELF(self);
        //        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
        //            STRONG_SELF(self);
        //
        //            NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
        //
        //            if ((components.hour > hour) || (components.hour == hour && components.minute > minute)) {
        //                self.programDetailView.taskStateButton.hidden = YES;
        //                self.programDetailView.punchCardButton.hidden = NO;
        //
        //                [self.programDetailView.punchCardButton setTitle:[NSString stringWithFormat:@"打卡第%ld天",(long)self.programDetailModel.Data.ClockInCount] forState:UIControlStateNormal];
        //
        //                WEAK_SELF(self);
        //                [self.programDetailView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        //                    STRONG_SELF(self);
        //                    make.bottom.equalTo(self.programDetailView.mas_bottom).offset(-57.5);
        //                }];
        //
        //                [timer invalidate];
        //            }
        //
        ////            components.hour = [[times objectAtIndex:0] integerValue];
        ////            components.minute = [[times objectAtIndex:1] integerValue];
        //
        //        } repeats:YES];
    }
    
    return NO;
    
    
}

#pragma mark - Net
#pragma mark - 获取方案详情
- (void)requestGetProgrammeDeltails
{
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetProgrammeDeltails" parameters:@{@"templateID":@(self.templateID)} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        
        self.programDetailModel = [BATProgramDetailModel mj_objectWithKeyValues:responseObject];
        
        self.programDetailView.headerView.titleLabel.text = self.programDetailModel.Data.Remark;
        self.programDetailView.headerView.countLabel.text = [NSString stringWithFormat:@"%ld人参加",(long)self.programDetailModel.Data.JoinCount];
        //        [self.programDetailView.headerView.bgView sd_setImageWithURL:[NSURL URLWithString:self.programDetailModel.Data.TemplateImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
        
        WEAK_SELF(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
            
            [downLoader downloadImageWithURL:[NSURL URLWithString:self.programDetailModel.Data.TemplateImage] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                STRONG_SELF(self);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.programDetailView.tableView addScalableCoverWithImage:image];
                });
                
            }];
        });
        
        
        
        if (self.programDetailModel.Data.IsSelected) {
            self.programDetailView.headerView.joinProgramButton.hidden = YES;
            self.programDetailView.headerView.executePointsButton.hidden = NO;
            
            self.programDetailView.taskStateButton.hidden = YES;
            self.programDetailView.punchCardButton.hidden = NO;
            
            if (self.programDetailModel.Data.ExpectClockInCount == 0) {
                //任务完成
                self.programDetailView.punchCardButton.hidden = YES;
                self.programDetailView.taskStateButton.hidden = NO;
                [self.programDetailView.taskStateButton setTitle:@"任务完成" forState:UIControlStateNormal];
                
            }
            //打卡的控制
            if (!self.programDetailModel.Data.IsCanClockIn) {
               self.programDetailView.punchCardButton.selected = YES;
               self.programDetailView.punchCardButton.userInteractionEnabled = NO;
            }
            //            else {
            //                [self.programDetailView.punchCardButton setTitle:[NSString stringWithFormat:@"打卡第%ld天",(long)self.programDetailModel.Data.ClockInCount] forState:UIControlStateNormal];
            //            }
            
            
            WEAK_SELF(self);
            [self.programDetailView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.bottom.equalTo(self.programDetailView.mas_bottom).offset(-57.5);
            }];
            
            //            [self checkClockIn];
            
        } else {
            self.programDetailView.headerView.joinProgramButton.hidden = NO;
            self.programDetailView.headerView.executePointsButton.hidden = YES;
            
            self.programDetailView.taskStateButton.hidden = YES;
            self.programDetailView.punchCardButton.hidden = YES;
        }
        
        
        
        //        [self.programDetailView.tableView.mj_header endRefreshing];
        [self.programDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

#pragma mark - 开启闹钟
- (void)requestIsAlarmClock:(BOOL)flag
{
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/IsAlarmClock" parameters:@{@"templateID":@(self.templateID),@"isFlag":(flag ? @"true" : @"false")} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        
        self.programDetailModel.Data.IsFlag = flag;
        
        [self settingClock:flag];
        
        [self.programDetailView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

#pragma mark - 加入方案
- (void)requestInsertProgramme
{
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/InsertProgramme" parameters:@{@"templateID":@(self.templateID)} type:kGET success:^(id responseObject) {
         
        BOOL isSelect = [[responseObject objectForKey:@"Data"] boolValue];
        
        if (isSelect) {
            
//            [self showText:@"您已成功加入方案，任务闹钟已开启"];
            self.programDetailModel.Data.IsSecondDayOpenclock = YES;
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestGetProgrammeDeltails];
//            });
            
            
            
            //            self.programDetailModel.Data.IsSelected = YES;
            //
            //            self.programDetailView.headerView.joinProgramButton.hidden = YES;
            //            self.programDetailView.headerView.executePointsButton.hidden = NO;
            //
            //            self.programDetailView.taskStateButton.hidden = YES;
            //            self.programDetailView.punchCardButton.hidden = NO;
            //            [self.programDetailView.punchCardButton setTitle:[NSString stringWithFormat:@"打卡第%ld天",(long)self.programDetailModel.Data.ClockInCount] forState:UIControlStateNormal];
            //
            //            self.programDetailModel.Data.JoinCount += 1;
            //            self.programDetailView.headerView.countLabel.text = [NSString stringWithFormat:@"%ld人参加",(long)self.programDetailModel.Data.JoinCount];
            //
            //            [self.programDetailView.tableView reloadData];
            
//            [self settingClock:true];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否需要开启推送？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self switchClock:NO];
            }];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self switchClock:YES];

            }];
            [alert addAction:noAction];
            [alert addAction:yesAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [self showText:@"加入失败"];
        }
        
        
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 打卡
- (void)requestInsertClockIn
{
    
    if (!self.programDetailModel.Data.IsCanClockIn) {
        [self showText:@"温馨提示：您今天已经打过卡了"];
        return;
    }
    
    if (![self checkClockIn]) {
        
        [self showText:@"温馨提示：记得在今天第一个闹铃后打卡哦！否则计划会往后自动为您顺延一天。"];
        return;
        
    }
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/InsertClockIn" parameters:@{@"templateID":@(self.templateID)} type:kPOST success:^(id responseObject) {
        
        self.programDetailModel.Data.ExpectClockInCount--;
        
        if (self.programDetailModel.Data.ExpectClockInCount == 0) {
            //任务完成
            
            self.programDetailView.taskStateButton.hidden = NO;
            self.programDetailView.punchCardButton.hidden = YES;
            
            [self.programDetailView.taskStateButton setTitle:@"任务完成" forState:UIControlStateNormal];
            
            [self settingClock:false];
        } else {
            self.programDetailView.taskStateButton.hidden = YES;
            self.programDetailView.punchCardButton.hidden = NO;
        }
        
        self.programDetailModel.Data.IsCanClockIn = NO;
        
        
        [self requestGetProgrammeDeltails];
        //        [self.programDetailView.tableView reloadData];
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜你！" message:@"你已完成今天的打卡任务" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
                
                BATPunchCardViewController *punchCardVC = [[BATPunchCardViewController alloc] init];
                punchCardVC.templateID = self.templateID;
                punchCardVC.title = self.programDetailModel.Data.Remark;
                [self.navigationController pushViewController:punchCardVC animated:YES];
            });
            
        }];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.programDetailView];
    
    WEAK_SELF(self);
    [self.programDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - get & set
- (BATProgramDetailView *)programDetailView
{
    if (_programDetailView == nil) {
        _programDetailView = [[BATProgramDetailView alloc] init];
        _programDetailView.tableView.delegate = self;
        _programDetailView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        //        _programDetailView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //            STRONG_SELF(self);
        //            [self requestGetProgrammeDeltails];
        //        }];
        //
        //        _programDetailView.tableView.mj_footer.hidden = YES;
        
        
        _programDetailView.headerView.joinProgramBlock = ^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            [self requestInsertProgramme];
        };
        
        _programDetailView.headerView.executePointsBlock = ^{
            STRONG_SELF(self);
            
            BATExecutePointsViewController *executePointsVC = [[BATExecutePointsViewController alloc] init];
            executePointsVC.programDetailModel = self.programDetailModel;
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:executePointsVC];
            [self presentViewController:navVC animated:YES completion:nil];
        };
        
        _programDetailView.punchCardBlock = ^{
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
            [self requestInsertClockIn];
        };
    }
    return _programDetailView;
}


@end
