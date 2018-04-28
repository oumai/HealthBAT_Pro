//
//  BATDieaseSymptomDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDieaseSymptomDetailController.h"
#import "BATSymptomNameCell.h"
#import "BATSymptomModel.h"
#import "BATSymptomCauseCell.h"
#import "BATRelateTreatmentCell.h"
#import "BATSymptomRelateTreatmentCell.h"
#import "BATDieaseInfoDeatilController.h"
#import "BATShowView.h"
#import "BATDieaseCell.h"
@interface BATDieaseSymptomDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTab;
@property (nonatomic,strong) BATSymptomModel *model;
@property (nonatomic,strong) BATShowView *showView;
@property (nonatomic,assign) CGFloat contentoffset;
@end

@implementation BATDieaseSymptomDetailController

static NSString *const symptonNameCell = @"symptonNameCell";
static NSString *const symptonCauseCell = @"symptonCauseCell";
static NSString *const symptonRelateCell = @"symptonRelateCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"症状百科";
    
//    self.ID = 12; 
    
    [self symptonDetailRequest];
   

}


//延时1秒钟
- (void)delayAction
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.showView.alpha = 1;
        
    }];
    
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
        BATSymptomNameCell *cell = [tableView dequeueReusableCellWithIdentifier:symptonNameCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         cell.iconView.image = [UIImage imageNamed:@"icon01"];
        cell.path = indexPath;
        [cell configCellWithModel:self.model];
        
        WEAK_SELF(cell);
        cell.nameBlock = ^(NSIndexPath *path){
            STRONG_SELF(cell);
            CGRect rc2 = [cell convertRect:cell.moreBtn.frame toView:self.view];
            
            
            [UIView animateWithDuration:0.2f animations:^{
                [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
            } completion:^(BOOL finished) {
                [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];//延时：让弹框晚出来 1秒钟
                NSString *contentString = self.model.Data.BRIEFINTRO_CONTENT;
                
                [self.showView calculateContentSizeWithContent:contentString];
                self.showView.showViewTitle.text = self.model.Data.SYMPTOM_NAME;
                self.showView.showViewContent.text = contentString;
                [self.showView animationStart];
            }];
            
            
            
            
            WEAK_SELF(self);
            self.showView.complicateBlock = ^(){
                STRONG_SELF(self);
                [UIView animateWithDuration:0.5f animations:^{
                    
                    self.showView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [self.showView removeFromSuperview];
                    self.showView = nil;
                    // self.myTab.tableFooterView = [UIView new];
                    [cell.moreBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                }];
                
            };
                  };
        return cell;

    }else if(indexPath.row == 1) {
        BATSymptomCauseCell *cell = [tableView dequeueReusableCellWithIdentifier:symptonCauseCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         cell.iconView.image = [UIImage imageNamed:@"icon02"];
        cell.path = indexPath;
        [cell configCellWithModel:self.model];
        
        WEAK_SELF(cell);
        cell.causeblock = ^(NSIndexPath *path){
            STRONG_SELF(cell);
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _myTab.tableFooterView = view;
            CGRect rc2 = [cell convertRect:cell.moreBtn.frame toView:self.view];
            
            
            [UIView animateWithDuration:0.2f animations:^{
                [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
            } completion:^(BOOL finished) {
                
                [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];//延时：让弹框晚出来 1秒钟
                
                NSString *contentString = self.model.Data.CAUSE_DETAIL;
                
                [self.showView calculateContentSizeWithContent:contentString];
                self.showView.showViewTitle.text = @"症状原因";
                self.showView.showViewContent.text = contentString;
                [self.showView animationStart];
            }];
            
            
            
            
            WEAK_SELF(self);
            self.showView.complicateBlock = ^(){
                STRONG_SELF(self);
                [UIView animateWithDuration:0.2f animations:^{
                    
                    self.showView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [self.showView removeFromSuperview];
                    self.showView = nil;
                    self.myTab.tableFooterView = [UIView new];
                    [cell.moreBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                }];
                
            };
            
        };
        return cell;
    }else {
        BATSymptomRelateTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:symptonRelateCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nursedLb.text = @"预防";
        cell.examineLb.text = @"检查";
        cell.treatmentLb.text = @"诊断";
        cell.path = indexPath;
        [cell configCellWithModel:self.model];
        
        WEAK_SELF(cell);
        cell.RelateTreatmentblock = ^(NSIndexPath *path,NSInteger num){
            STRONG_SELF(cell);
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _myTab.tableFooterView = view;
            NSString *content = nil;
            CGRect rc2 = CGRectZero;
            NSString *title = nil;
            switch (num) {
                case 0: {
                    rc2 = [cell convertRect:cell.examineBtn.frame toView:self.view];
                    content = self.model.Data.RELATED_INSPECTIONS_NLIST;
                    title = @"检查";
                    break;
                }
                case 1: {
                    rc2 = [cell convertRect:cell.treatmentBtn.frame toView:self.view];
                    content = self.model.Data.IDENTIFICATION_DETAIL;
                    title = @"诊断";
                    break;
                }
                case 2: {
                    rc2 = [cell convertRect:cell.nursedBtn.frame toView:self.view];
                    content = self.model.Data.PREVENTION_DETAIL;
                    title = @"预防";
                    break;
                }

                default:
                    break;
            }
            
            [UIView animateWithDuration:0.2f animations:^{
                [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
            } completion:^(BOOL finished) {
              
                [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];//延时：让弹框晚出来 1秒钟

                
                [self.showView calculateContentSizeWithContent:content];
                self.showView.showViewTitle.text = title;
                self.showView.showViewContent.text = content;
                [self.showView animationStart];
            }];
            
            WEAK_SELF(self);
            self.showView.complicateBlock = ^(){
                STRONG_SELF(self);
                [UIView animateWithDuration:0.2f animations:^{
                    
                    self.showView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [self.showView removeFromSuperview];
                    self.showView = nil;
                    self.myTab.tableFooterView = [UIView new];
                    
                    if (num == 0) {
                        
                        [cell.examineBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
                        
                    }else if(num == 1) {
                        
                        [cell.treatmentBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
                        
                    }else {
                        
                        [cell.nursedBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];
                        
                    }
                    

                }];
                
            };
            
        };
        
        [cell configCellWithModel:self.model];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            CGFloat height = [BATSymptomNameCell HeightWithModel:self.model];
            return height;
        }
            break;
        case 1: {
            CGFloat height = [BATSymptomCauseCell HeightWithModel:self.model];
            return height;
        }
            break;
        case 2: {
            CGFloat height = [BATSymptomRelateTreatmentCell HeightWithModel:self.model];
            return height;
        }
            break;
        default:
            break;
    }
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

#pragma mark - NET
-(void)symptonDetailRequest {
    [self showProgressWithText:@"正在加载"];
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Symptom/GetSymptomDetail?ID=%zd",self.ID] parameters:nil type:kGET success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSMutableParagraphStyle * commomPara = [[NSMutableParagraphStyle alloc] init];
        [commomPara setLineSpacing:10];
        
        self.model = [BATSymptomModel mj_objectWithKeyValues:responseObject];
   
        CGSize examineSize = [self.model.Data.RELATED_INSPECTIONS_NLIST boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        
        if (examineSize.height < 40) {
            self.model.Data.isExaimBtnShow = NO;
        }else {
            self.model.Data.isExaimBtnShow = YES;
        }
        
        NSMutableAttributedString * exaimString = [[NSMutableAttributedString alloc] initWithData:[self.model.Data.RELATED_INSPECTIONS_NLIST dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
        [exaimString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, exaimString.length)];
        
        
        if (![self.model.Data.RELATED_INSPECTIONS_NLIST containsString:@"<p"]) {
            [exaimString addAttribute:NSParagraphStyleAttributeName value:commomPara range:NSMakeRange(0, [exaimString length])];
        }
        self.model.Data.RELATED_INSPECTIONS_NLIST = exaimString.string;
        
        CGSize treatmentSize = [self.model.Data.IDENTIFICATION_DETAIL boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        
        if (treatmentSize.height < 40) {
            self.model.Data.isTreatmentBtnShow = NO;
        }else {
            self.model.Data.isTreatmentBtnShow = YES;
        }
        
        NSMutableAttributedString *treatmentString = [[NSMutableAttributedString alloc] initWithData:[self.model.Data.IDENTIFICATION_DETAIL dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
        [treatmentString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, treatmentString.length)];
        
        
        if (![self.model.Data.IDENTIFICATION_DETAIL containsString:@"<p"]) {
            [treatmentString addAttribute:NSParagraphStyleAttributeName value:commomPara range:NSMakeRange(0, [treatmentString length])];
        }
        
        self.model.Data.IDENTIFICATION_DETAIL = treatmentString.string;
        
        CGSize nurseDetailSize = [self.model.Data.PREVENTION_DETAIL boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        
        if (nurseDetailSize.height < 40) {
            self.model.Data.isNurseBtnShow = NO;
        }else {
            self.model.Data.isNurseBtnShow = YES;
        }
        
        NSMutableAttributedString *nurseString = [[NSMutableAttributedString alloc] initWithData:[self.model.Data.PREVENTION_DETAIL dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
        [nurseString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, nurseString.length)];
        
        
        if (![self.model.Data.PREVENTION_DETAIL containsString:@"<p"]) {
            [nurseString addAttribute:NSParagraphStyleAttributeName value:commomPara range:NSMakeRange(0, [nurseString length])];
        }

        self.model.Data.PREVENTION_DETAIL = nurseString.string;
        
//        self.model.Data.BRIEFINTRO_CONTENT
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithData:[self.model.Data.BRIEFINTRO_CONTENT dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
        [contentString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length)];
        
        
        if (![self.model.Data.BRIEFINTRO_CONTENT containsString:@"<p"]) {
            [contentString addAttribute:NSParagraphStyleAttributeName value:commomPara range:NSMakeRange(0, [contentString length])];
        }
        self.model.Data.BRIEFINTRO_CONTENT = contentString.string;
        
//    self.model.Data.CAUSE_DETAIL    
        NSMutableAttributedString *causeString = [[NSMutableAttributedString alloc] initWithData:[self.model.Data.CAUSE_DETAIL dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
        [causeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, causeString.length)];
        
        
        if (![self.model.Data.CAUSE_DETAIL containsString:@"<p"]) {
            [causeString addAttribute:NSParagraphStyleAttributeName value:commomPara range:NSMakeRange(0, [causeString length])];
        }
        self.model.Data.CAUSE_DETAIL = causeString.string;
        
        [self.view addSubview:self.myTab];
        [self dismissProgress];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

    }];
}

#pragma mark - SETTER - GETTER
-(UITableView *)myTab {
    if (!_myTab) {
        _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTab.delegate = self;
        _myTab.dataSource = self;
        [_myTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_myTab registerClass:[BATSymptomNameCell class] forCellReuseIdentifier:symptonNameCell];
        [_myTab registerClass:[BATSymptomCauseCell class] forCellReuseIdentifier:symptonCauseCell];
        [_myTab registerClass:[BATSymptomRelateTreatmentCell class] forCellReuseIdentifier:symptonRelateCell];
    }
    return _myTab;
}

- (BATShowView *)showView {
    
    if (!_showView) {
        _showView = [[BATShowView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
        _showView.alpha = 0;
    }
    return _showView;
}

@end
