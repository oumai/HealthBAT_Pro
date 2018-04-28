//
//  BATTeacherMessageViewController.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTeacherMessageViewController.h"

#import "BATTeacherMessageCell.h"

#import "BATTeacherMessageModel.h"

#import "BATTeacherVideoCell.h"

#import "BATCourseDetailViewController.h"

#import "BATCourseNewDetailViewController.h"

static  NSString * const TEACHER_CLASS_TEXT_CELL = @"TeacherClassText";
static  NSString * const TEACHER_CLASS_VIDEO_CELL = @"TeacherClassVideo";

@interface BATTeacherMessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView                *messageTableView;

@property (nonatomic,strong) BATTeacherMessageModel     *teacherMessageModel;

@property (nonatomic,strong) NSMutableArray             *dataArray;

@property (nonatomic,assign) BOOL                       isShowBlankImage;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATTeacherMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShowBlankImage = NO;
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.title = self.teacherName;
    
    [self layoutPages];
    
    [self getDataRequest:self.teacherID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return CGFLOAT_MIN;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATTeacherMessagesData *pic = self.dataArray[indexPath.row];
    
    if(pic.CourseType == kBATCourseType_Video){
        //视频
        //没有行间距的文字高度
        CGFloat titleHeight = [Tools calculateHeightWithText:pic.Topic width:SCREEN_WIDTH - 88 - 24 font:[UIFont systemFontOfSize:13]];
        //文字总宽度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
        CGFloat titleWidth = [pic.Topic sizeWithAttributes:attrs].width;
        //需要计算行高的行数
        NSInteger num = titleWidth/(SCREEN_WIDTH - 88 - 24);
        
        return 245 + titleHeight + num*6;
        
    }else if(pic.CourseType == kBATCourseType_WordOrPDF){
        
        //没有行间距的文字高度
        CGFloat titleHeight = [Tools calculateHeightWithText:pic.Topic width:SCREEN_WIDTH - 88 - 24 font:[UIFont systemFontOfSize:13]];
        //文字总宽度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
        CGFloat titleWidth = [pic.Topic sizeWithAttributes:attrs].width;
        //需要计算行高的行数
        NSInteger num = titleWidth/(SCREEN_WIDTH - 88 - 24);
        
        return 179 + titleHeight + num*6;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    BATTeacherMessagesData *pic = self.dataArray[indexPath.row];
    
    if(pic.CourseType == kBATCourseType_Video){
        //视频
        
        BATTeacherVideoCell *videoMessageCell = [tableView dequeueReusableCellWithIdentifier:TEACHER_CLASS_VIDEO_CELL];
        if (videoMessageCell == nil) {
            videoMessageCell = [[BATTeacherVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEACHER_CLASS_VIDEO_CELL];
        }
        
        videoMessageCell.dateLabel.text = pic.CreatedTime;
        [videoMessageCell.doctorImageV sd_setImageWithURL:[NSURL URLWithString:pic.TeacherPhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        videoMessageCell.titleLabel.attributedText = [self getAttributedStringWithString:pic.Topic lineSpace:6];
        [videoMessageCell.videoImageV sd_setImageWithURL:[NSURL URLWithString:pic.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
        videoMessageCell.subTitleLabel.text = pic.Description;
        videoMessageCell.nameLabel.text =pic.TeacherName;
        
        return videoMessageCell;
        
    }else{
        //图文
        
        BATTeacherMessageCell *textMessageCell = [tableView dequeueReusableCellWithIdentifier:TEACHER_CLASS_TEXT_CELL];
        if (textMessageCell == nil) {
            textMessageCell = [[BATTeacherMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEACHER_CLASS_TEXT_CELL];
        }
        
        textMessageCell.dateLabel.text = pic.CreatedTime;
        [textMessageCell.doctorImageV sd_setImageWithURL:[NSURL URLWithString:pic.TeacherPhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
        textMessageCell.titleLabel.attributedText = [self getAttributedStringWithString:pic.Topic lineSpace:6];
        [textMessageCell.iconImageV sd_setImageWithURL:[NSURL URLWithString:pic.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
        textMessageCell.subTitleLabel.text = pic.Description;
        textMessageCell.nameLabel.text =pic.TeacherName;
        
        return textMessageCell;
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLogInfo(@"视频点击！");
    
    
    
    BATTeacherMessagesData *pic = self.dataArray[indexPath.row];
    
    [self addCourseReadingNumRequestWithID:pic.ID];
    
//    BATCourseDetailViewController *CourseDetailVC = [[BATCourseDetailViewController alloc]init];
//    CourseDetailVC.courseID = pic.ID;
//    CourseDetailVC.courseType = pic.CourseType;
//    [self.navigationController pushViewController:CourseDetailVC animated:YES];
    
    
    
    BATCourseNewDetailViewController *courseDetailVC = [[BATCourseNewDetailViewController alloc] init];
    courseDetailVC.courseID = pic.ID;
    courseDetailVC.isPushFromHome = NO;
    courseDetailVC.courseType = pic.Category;
    courseDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:courseDetailVC animated:YES];
    
    
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
//    if (self.isShowBlankImage == NO) {
//        return nil;
//    }
//    
//    return [[NSAttributedString alloc] initWithString:@"升级中..."];
//}
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    
//    if (self.isShowBlankImage == NO) {
//        return nil;
//    }
//    
//    return [UIImage imageNamed:@"iconfont--search-no"];
//}

#pragma mark - net
//获取老师消息列表
- (void)getDataRequest:(NSInteger)teacherID{
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/TrainingTeacher/GetCourseList?pageIndex=0&pageSize=10&AccountID=%@",@(teacherID)] parameters:nil type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        self.teacherMessageModel = [BATTeacherMessageModel mj_objectWithKeyValues:responseObject];

        for (BATTeacherMessagesData *pic in self.teacherMessageModel.Data) {
            [self.dataArray addObject:pic];
        }
        
        if (self.dataArray.count == 0) {
            self.isShowBlankImage = NO;
        }
        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.messageTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self dismissProgress];
        
        [self.defaultView showDefaultView];
    }];
    
}

//添加课程阅读量
- (void)addCourseReadingNumRequestWithID:(NSInteger)courseID {
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/trainingteacher/course/updatereadingnum/%ld",(long)courseID] parameters:nil type:kGET success:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshIndexPathModelNotification object:@{@"courseID":@(courseID),@"isCollection":@(NO),@"commentState":@(NO),@"isRead":@(YES)}];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - private
- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}


#pragma mark - layout
- (void)layoutPages {
    [self.view addSubview:self.messageTableView];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}


#pragma mark - getter && setter
- (UITableView *)messageTableView {
    
    if (!_messageTableView) {
        
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _messageTableView.estimatedRowHeight = 250;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.emptyDataSetSource = self;
        _messageTableView.emptyDataSetDelegate = self;
        _messageTableView.tableFooterView = [[UIView alloc] init];
        _messageTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _messageTableView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            [self getDataRequest:self.teacherID];
        }];
        
    }
    return _defaultView;
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
