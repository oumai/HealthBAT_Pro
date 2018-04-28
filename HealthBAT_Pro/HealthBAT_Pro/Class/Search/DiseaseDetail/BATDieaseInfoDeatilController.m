//
//  BATDieaseInfoDeatilController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/11/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDieaseInfoDeatilController.h"
#import "BATDieaseInfoCell.h"
#import "BATDieaseDetailModel.h"
@interface BATDieaseInfoDeatilController ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) BATSymptomModel *symptomModel;
@property (nonatomic,strong) BATDieaseDetailModel *dieaseModel;
@property (nonatomic,strong) NSArray *showContentArr;
@property (nonatomic,strong) NSArray *chooseArr;

@end

@implementation BATDieaseInfoDeatilController

static NSString * const DIEASEINFOCELL = @"DIEASECELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self dieaseInfoRequest];
    
   
}

-(void)setUpUI {

    NSString *reasonOrRelate = self.isSymptom?@"症状原因":@"相关症状";
    NSString *exaimStr = self.isSymptom?@"检查":@"检查方式";
    NSString *entiyStr = self.isSymptom?@"诊断":@"治疗方式";
    NSString *praventStr = self.isSymptom?@"预防":@"预防护理";
    self.chooseArr = @[@"简介",reasonOrRelate,@"并发症",@"易感人群",@"治愈率",exaimStr,entiyStr,praventStr];

    self.title  = self.chooseArr[self.type];

    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.backScrollView];

    self.backView = [[UIView alloc] init];

    self.backView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.backView];

    NSString *showString = self.showContentArr[self.type];
    if ([showString isEqualToString:@""]) {
        showString = @"暂无相关信息";
    }


    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithData:[showString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributedString1.length)];
    
    NSInteger otherHeight = 0;
    if (![showString containsString:@"<p"]) {
        otherHeight = 10;
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
    }
   

    self.contentLb = [[UILabel alloc]init];
    [self.contentLb setFont:[UIFont systemFontOfSize:14]];
    self.contentLb.numberOfLines = 0;
    self.contentLb.textColor = UIColorFromHEX(0X666666, 1);
    self.contentLb.attributedText = attributedString1;
    [self.backView addSubview:self.contentLb];

    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(10);
        make.right.equalTo(self.backView).offset(-10);
        make.top.equalTo(self.backView.mas_top).offset(10);
    }];
    
    CGRect rect = [self.contentLb.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    NSInteger moreheigth = 0;
    if (rect.size.height <=30) {
        moreheigth = -10;
    }
    self.backView.frame =  CGRectMake(0, 0, SCREEN_WIDTH, rect.size.height + 10 + otherHeight + moreheigth);

    self.closeBtn = [[UIButton alloc]init];
    self.closeBtn.backgroundColor = BASE_COLOR;
    self.closeBtn.clipsToBounds = YES;
    self.closeBtn.layer.cornerRadius = 5;
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:self.closeBtn];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];

    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, rect.size.height + 15 + 15 + 44 + 20 +20);
}

-(void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)AttributeHeight:(NSInteger)num {
    
   
    NSString *showString = self.showContentArr[num];
    if ([showString isEqualToString:@""]) {
        showString = @"暂无相关信息";
    }
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithData:[showString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
    

//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:10];
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]
                          };

//    NSString *returnString = [self flattenHTML:showString];
    CGSize size = [attributedString1.string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
//    CGSize size = [self.showContentArr[num] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return size.height;

}






#pragma mark Net
-(void)dieaseInfoRequest {
  
    if (self.isSymptom) {
        
        [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Symptom/GetSymptomDetail?ID=%@",self.ID] parameters:nil type:kGET success:^(id responseObject) {

            self.symptomModel = [BATSymptomModel mj_objectWithKeyValues:responseObject];
        
            self.showContentArr = @[_symptomModel.Data.BRIEFINTRO_CONTENT,_symptomModel.Data.CAUSE_DETAIL,@"",@"",@"",_symptomModel.Data.RELATED_INSPECTIONS_NLIST,_symptomModel.Data.IDENTIFICATION_DETAIL,_symptomModel.Data.PREVENTION_DETAIL];
            [self setUpUI];
            
            [self dismissProgress];
        } failure:^(NSError *error) {
            if (error.code < -2) {
                [self dismissProgress];
            }
        }];

        
    }else {
    
         [self showProgressWithText:@"正在加载"];
        [HTTPTool requestWithURLString:@"/api/Disease/GetDiseaseDetails" parameters:@{@"id":self.ID} type:kGET success:^(id responseObject) {
            
            [self dismissProgress];
            
            self.dieaseModel = [BATDieaseDetailModel mj_objectWithKeyValues:responseObject];
            
            self.showContentArr = @[_dieaseModel.Data.Briefintro_Content,_dieaseModel.Data.Common_Symptom_Desc,_dieaseModel.Data.Concurrent_Disease_Nlist,_dieaseModel.Data.Susceptible_Population,_dieaseModel.Data.Cure_Rate,_dieaseModel.Data.Inspection_Detail,_dieaseModel.Data.Treatment_Detail,_dieaseModel.Data.Nursing_Detail];
            
                    [self setUpUI];
            
            
            
        } failure:^(NSError *error) {
            if (error.code < -2) {
                [self dismissProgress];
            }
            self.navigationItem.leftBarButtonItem = nil;
        }];
        
    }
   
    
}

//#pragma mark -SETTER - GETTER 
//-(UITableView *)leftTab {
//    if (!_leftTab) {
//        _leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 209, SCREEN_HEIGHT-44-64) style:UITableViewStylePlain];
//        _leftTab.delegate = self;
//        _leftTab.dataSource = self;
//        [_leftTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [_leftTab registerClass:[BATDieaseInfoCell class] forCellReuseIdentifier:DIEASEINFOCELL];
//    }
//    return _leftTab;
//}





#pragma mark Action
//-(void)backAction {
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.showView.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        self.showView.hidden = YES;
//    }];
//}


//
//-(void)showAction {
//
//    self.showView.hidden = NO;
//    [UIView animateWithDuration:0.3 animations:^{
//            self.showView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        }];
//
//}

//-(UIView *)showView {
//    if (!_showView) {
//        UIColor *color = [UIColor blackColor];
//        _showView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _showView.backgroundColor = [color colorWithAlphaComponent:0.65];
//        _showView.userInteractionEnabled = YES;
//        [_showView addSubview:self.leftTab];
//        
//        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
//        
//        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(209, 0, SCREEN_WIDTH-209, SCREEN_HEIGHT-64)];
//        rightView.userInteractionEnabled = YES;
//        [rightView addGestureRecognizer:closeTap];
//        [_showView addSubview:rightView];
//        
//        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 209, 44)];
//        [backBtn setBackgroundColor:[UIColor whiteColor]];
//        [backBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
//        UIEdgeInsets inset = UIEdgeInsetsMake(5, -55, 5, 34);
//        [backBtn setTitleEdgeInsets:inset];
//        [backBtn setTitle:@"返回详情页" forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//        [_showView addSubview:backBtn];
//        
//        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backBtn.frame), 209, 1)];
//        lineview.backgroundColor = BASE_BACKGROUND_COLOR;
//        [_showView addSubview:lineview];
//        
//        
//        UILabel *tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-64, SCREEN_WIDTH-209, 40)];
//        tipsLb.text = @"轻触这里关闭目录";
//        tipsLb.numberOfLines = 0;
//        tipsLb.textAlignment = NSTextAlignmentCenter;
//        tipsLb.font = [UIFont systemFontOfSize:16];
//        tipsLb.textColor = [UIColor whiteColor];
//        [rightView addSubview:tipsLb];
//        
//        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-209)/2-19, CGRectGetMaxY(tipsLb.frame)+15, 38.5, 44)];
//        icon.image = [UIImage imageNamed:@"点击"];
//        [rightView addSubview:icon];
//        
//        [self.view addSubview:_showView];
//    }
//    return _showView;
//}
//#pragma mark Net
//-(void)dieaseInfoRequest {
//  
//    [HTTPTool requestWithURLString:@"/api/Disease/GetDiseaseDetails" parameters:@{@"id":self.ID} type:kGET success:^(id responseObject) {
//        
//        [self dismissProgress];
//        
//        self.dieaseModel = [BATDieaseDetailModel mj_objectWithKeyValues:responseObject];
//        
//        self.showContentArr = @[_dieaseModel.Data.Briefintro_Content,_dieaseModel.Data.Common_Symptom_Desc,_dieaseModel.Data.Concurrent_Disease_Nlist,_dieaseModel.Data.Susceptible_Population,_dieaseModel.Data.Cure_Rate,_dieaseModel.Data.Inspection_Detail,_dieaseModel.Data.Treatment_Detail,_dieaseModel.Data.Nursing_Detail];
//        
//        [self setUpUI];
//        
//        
//        
//    } failure:^(NSError *error) {
//        [self showErrorWithText:error.localizedDescription];
//
//        self.navigationItem.leftBarButtonItem = nil;
//    }];
//    
//}





//#pragma mark UITableViewDelegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 4;
//            break;
//        case 2:
//            return 3;
//            break;
//        default:
//            break;
//    }
//    return 0;
//
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
//    backView.backgroundColor = [UIColor whiteColor];
//
//    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.iconArr[section]]];
//    [backView addSubview:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backView.mas_left).offset(15);
//        make.centerY.equalTo(backView.mas_centerY);
//    }];
//
//    UILabel *title = [[UILabel alloc]init];
//    title.text = self.titleArr[section];
//    title.font = [UIFont systemFontOfSize:16];
//    title.textColor = UIColorFromHEX(0X333333, 1);
//    [backView addSubview:title];
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(img.mas_right).offset(15);
//        make.centerY.equalTo(backView.mas_centerY);
//    }];
//
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
//    [backView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(backView).offset(0);
//        make.height.mas_equalTo(1);
//    }];
//
//    return backView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 45;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 45;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    BATDieaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:DIEASEINFOCELL];
//    if (cell == nil) {
//        cell = [[BATDieaseInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DIEASEINFOCELL];
//    }
//    cell.title.text = self.contentArr[indexPath.section][indexPath.row];
//    cell.icon.hidden = YES;
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSInteger num = 0;
//
//    switch (indexPath.section) {
//        case 0:
//            num = 0;
//             break;
//        case 1:
//            num = 1 + indexPath.row;
//            break;
//        case 2:
//            num = 5 + indexPath.row;
//            break;
//        default:
//            break;
//    }
//
//     CGFloat contentLbHeight = [self AttributeHeight:num] -10;
//
//    NSString *showString = self.showContentArr[num];
//    if ([showString isEqualToString:@""]) {
//        showString = @"暂无相关信息";
//    }
//
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:showString];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:10];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [showString length])];
//
//    self.contentLb.attributedText = attributedString1;
//    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentLbHeight + 20 +44 + 20 + 15);
//
//
//    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentLbHeight + 20 + 5);
//
//    [self.view layoutIfNeeded];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.showView.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        self.showView.hidden = YES;
//    }];
//
//
//    self.title = self.chooseArr[num];
//}



@end
