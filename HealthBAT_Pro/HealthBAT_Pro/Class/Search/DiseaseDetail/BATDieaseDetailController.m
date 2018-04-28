//
//  ViewController.m
//  TableViewTest
//
//  Created by mac on 16/9/16.
//  Copyright © 2016年 sword. All rights reserved.
//
#import "UIScrollView+EmptyDataSet.h"

#import "BATDrugInfoDetailViewController.h"
#import "BATDieaseDetailController.h"

#import "BATDieaseCell.h"
#import "BATAdministrativeCell.h"
#import "BATDrugCell.h"
#import "BATRelateTreatmentCell.h"
#import "BATRelateDieaseCell.h"
#import "BATSecondDieaseCell.h"

#import "BATDieaseDetailModel.h"
#import "BATDieaseDetailEntityModel.h"

#import "BATDieaseInfoDeatilController.h"

#import "BATShowView.h"

@interface BATDieaseDetailController ()<UITableViewDelegate,UITableViewDataSource,BATRelateDieaseCellDelegate,BATDrugCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong)UITableView *myTab;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)BATDieaseDetailModel *dieaseModel;
@property (nonatomic,strong) NSString  *beginTime;
@property (nonatomic,assign) CGFloat heights;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) BATShowView *showView;


@property (nonatomic,assign) CGFloat contentoffset;

@end

@implementation BATDieaseDetailController

static NSString *const DieaseCellReuseName = @"DIEASECELL";
static NSString *const AdministerReuseName = @"ADMINISTERCELL";
static NSString *const DrugReuseName = @"DRUGCELL";
static NSString *const TreatmentReuseName = @"TreatmentCell";
static NSString *const RelateDieaseReuseName = @"RELATEDIEASECELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
   
    [self GetDieaseInfoRequset];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isSaveUserOperaAction) {
        [self saveOperation];
    }else {
    [self popAction];
    }
}

-(void)saveOperation {
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:5 beginTime:self.beginTime];
}


-(void)popAction {
    [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"disease_info" moduleId:[NSString stringWithFormat:@"%zd",self.DieaseID] beginTime:self.beginTime browsePage:self.pathName];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            CGFloat height = [BATDieaseCell HeightWithModel:model];
            return height - 5;
            break;
        }
        case 1: {
//            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
//            //此处是定高，当开关都处于关闭状态时候，直接返回高度，避免进入到Cell里面又计算一次高度，因为反正就这么高····
//            if (model.upLeftIsOpen==NO&&model.upRightIsOpen==NO&&model.downLeftIsOpen==NO&&model.downRightIsOpen==NO) {
//                return 110.5;
//            }else{
//            CGFloat height = [BATAdministrativeCell HeightWithModel:model];
//            return height;
//            }
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            CGFloat height = [BATSecondDieaseCell HeightWithModel:model];
            return height;
            break;
        }
        case 2: {
            
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            CGFloat height = [BATSecondDieaseCell HeightWithModel:model];
            return height;
            
            break;
        }
        case 3: {

            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            CGFloat height = [BATSecondDieaseCell HeightWithModel:model];
            return height;

            break;
        }
        case 4: {
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            CGFloat height = [BATSecondDieaseCell HeightWithModel:model];
            return height;

            break;
        }
        case 5: {
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            //当药品数为零时，定高40
            if (model.DieaseInfo.count==0) {
                return 40;
            }else{
                CGFloat height = [BATDrugCell HeightWithModel:model];
                return height-10;
            }
            break;
        }
        case 6: {
            BATDieaseDetailEntityModel *model = self.dataArr[indexPath.row];
            //此处是定高，当开关都处于关闭状态时候，直接返回高度，避免进入到Cell里面又计算一次高度，因为反正就这么高····
//            if (model.RelateExaminIsOpen==NO&&model.RelateTreatmentIsOpen==NO&&model.RelateNurseIsOpen==NO) {
//                return 225;
//            }else{
                CGFloat height = [BATRelateTreatmentCell HeightWithModel:model];
                return height;
//            }
            break;
        }
        case 7: {
            //            NSInteger count = [[self.dataArr[indexPath.row] relateDieaseArr] count];
            //            return (count+2)*35;//不管怎么样都要留出一行距离
            return  self.heights;
        }
        default:
            break;
    }
    return 0;
}
//延时1秒钟
- (void)delayAction
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.showView.alpha = 1;
        
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            BATDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:DieaseCellReuseName];
            cell.moreBtn.hidden = NO;
            cell.iconView.image = [UIImage imageNamed:@"icon01"];
            if (cell==nil) {
                cell = [[BATDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DieaseCellReuseName];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
            WEAK_SELF(cell);
            cell.block = ^(NSIndexPath *path){
                STRONG_SELF(cell);

//                CGRect rc2 = [cell convertRect:cell.moreBtn.frame toView:self.view];
//                [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
                [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];
                
                NSString *contentString = [self.dataArr[0] detailLb];
                
                [self.showView calculateContentSizeWithContent:contentString];
                self.showView.showViewTitle.text = self.EntryCNName;
                self.showView.showViewContent.text = contentString;
                [self.showView animationStart];
                
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
            break;
        }
        case 1: {
            
            BATSecondDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSecondDieaseCell"];
            cell.iconView.image = [UIImage imageNamed:@"icon02"];
            cell.moreBtn.hidden = NO;
            if (cell==nil) {
                cell = [[BATSecondDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BATSecondDieaseCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
            
            WEAK_SELF(cell);
            cell.block = ^(NSIndexPath *path){
                STRONG_SELF(cell);

                CGRect rc2 = [cell convertRect:cell.moreBtn.frame toView:self.view];
                
                
                [UIView animateWithDuration:0.2f animations:^{
                      [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
                } completion:^(BOOL finished) {
                    [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];
                    
                    NSString *contentString = [self.dataArr[1] detailLb];
                    
                    [self.showView calculateContentSizeWithContent:contentString];
                    self.showView.showViewTitle.text = @"相关症状";
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
                        [cell.moreBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                       // self.myTab.tableFooterView = [UIView new];
                    }];
                    
                };
                
            };
            return cell;
            break;
//            BATAdministrativeCell *cell = [tableView dequeueReusableCellWithIdentifier:AdministerReuseName];
//            if (cell==nil) {
//                cell = [[BATAdministrativeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AdministerReuseName];
//            }
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.path = indexPath;
//            [cell configCellWithModel:self.dataArr[indexPath.row]];
//            cell.Administrativeblocks = ^(NSIndexPath *path,NSInteger numbers){
//                [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//                
//                BATDieaseInfoDeatilController *infoVc = [[BATDieaseInfoDeatilController alloc]init];
//                infoVc.type = numbers + 1;
//                infoVc.ID = [NSString stringWithFormat:@"%zd",self.DieaseID];
//                [self.navigationController pushViewController:infoVc animated:YES];
//
//                
//            };
//
//            return cell;
//            break;
        }
        case 2: {
            
            BATSecondDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSecondDieaseCell"];
            cell.iconView.image = [UIImage imageNamed:@"icon03"];
            cell.moreBtn.hidden = YES;
            if (cell==nil) {
                cell = [[BATSecondDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BATSecondDieaseCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
           
            return cell;
            break;
        }
        case 3: {

            BATSecondDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSecondDieaseCell"];
            cell.iconView.image = [UIImage imageNamed:@"icon04"];
            cell.moreBtn.hidden = YES;
            cell.isRowOne = NO;
            if (cell==nil) {
                cell = [[BATSecondDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BATSecondDieaseCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
//            cell.block = ^(NSIndexPath *path){
//                [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//                
//                BATDieaseInfoDeatilController *infoVc = [[BATDieaseInfoDeatilController alloc]init];
//                infoVc.type = 0;
//                infoVc.ID = [NSString stringWithFormat:@"%zd",self.DieaseID];
//                [self.navigationController pushViewController:infoVc animated:YES];
//                
//            };
            return cell;
            break;
        }
        case 4: {
           
            BATSecondDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSecondDieaseCell"];
            cell.iconView.image = [UIImage imageNamed:@"icon05"];
            cell.moreBtn.hidden = YES;
            if (cell==nil) {
                cell = [[BATSecondDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BATSecondDieaseCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
//            cell.block = ^(NSIndexPath *path){
//                [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//                
//                BATDieaseInfoDeatilController *infoVc = [[BATDieaseInfoDeatilController alloc]init];
//                infoVc.type = 0;
//                infoVc.ID = [NSString stringWithFormat:@"%zd",self.DieaseID];
//                [self.navigationController pushViewController:infoVc animated:YES];
//                
//            };
            return cell;
            break;
        }
        case 5: {
        
            BATDrugCell  *cell = [tableView dequeueReusableCellWithIdentifier:DrugReuseName];
            cell.iconView.image = [UIImage imageNamed:@"icon06"];
            if (cell==nil) {
                cell = [[BATDrugCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DrugReuseName];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate = self;
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            cell.block = ^(NSIndexPath *path){
                [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
            break;

        }
        case 6: {
        
            BATRelateTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:TreatmentReuseName];
            cell.iconView.image = [UIImage imageNamed:@"icon07"];
            if (cell==nil) {
                cell = [[BATRelateTreatmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreatmentReuseName];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            
            WEAK_SELF(cell);
            cell.RelateTreatmentblock = ^(NSIndexPath *path,NSInteger numbers){
                STRONG_SELF(cell);
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _myTab.tableFooterView = view;
                
                NSString *title = nil;
                NSString *content = nil;
                CGRect btnRect = CGRectZero;
                if (numbers == 0) {
                    btnRect = cell.examineBtn.frame;
                    title = @"检查方式";
                    content = [self.dataArr[6] treatmentArr][0];
                }else if(numbers == 1) {
                    btnRect = cell.treatmentBtn.frame;
                    title = @"治疗方式";
                    content = [self.dataArr[6] treatmentArr][1];
                }else {
                    btnRect = cell.nursedBtn.frame;
                    title = @"预防护理";
                    content = [self.dataArr[6] treatmentArr][2];
                }

                
                CGRect rc2 = [cell convertRect:btnRect toView:self.view];
                
                
                [UIView animateWithDuration:0.2f animations:^{
                  [_myTab setContentOffset:CGPointMake(0, rc2.origin.y + self.contentoffset)];
                } completion:^(BOOL finished) {
                    [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.2f];
                    
                    
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
                        if (numbers == 0) {
                            
                            [cell.examineBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                        }else if(numbers == 1) {
                            
                            [cell.treatmentBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                        }else {
                          
                            [cell.nursedBtn setImage:[UIImage imageNamed:@"jiantou01"] forState:UIControlStateNormal];

                        }


                    }];
                    
                };
                
            };
            return cell;
            break;
            
        }
        case 7: {
        
            BATRelateDieaseCell *cell = [tableView dequeueReusableCellWithIdentifier:RelateDieaseReuseName];
            cell.iconView.image = [UIImage imageNamed:@"icon08"];
            if (cell==nil) {
                cell = [[BATRelateDieaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RelateDieaseReuseName];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate = self;
            cell.path = indexPath;
            [cell configCellWithModel:self.dataArr[indexPath.row]];
            cell.block = ^(NSIndexPath *path){
                [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            
            
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.contentoffset = scrollView.contentOffset.y;
    
}

#pragma mark - Action
//相关疾病点击代理事件
/*
 * @param row 第几个
 */
-(void)BATRelateDieaseWithRow:(NSIndexPath *)row {
    
    Aboutdiseaselst *aboutDieaseModel = _dieaseModel.Data.AboutDiseaselst[row.row];

    self.DieaseID = aboutDieaseModel.Id;
    self.title = aboutDieaseModel.Name;
    self.EntryCNName = aboutDieaseModel.Name;
    
    [self GetDieaseInfoRequset];

}

/*
 * @param row 第几个
 */
//常用药品点击代理事件
-(void)BATDrugCellDrugClickActionWithRow:(NSInteger)row {
    Drugslst *drugList = _dieaseModel.Data.Drugslst[row];
    
    BATDrugInfoDetailViewController *drugCtl = [[BATDrugInfoDetailViewController alloc]init];
    drugCtl.drugID = [NSString stringWithFormat:@"%zd",drugList.Id];
    drugCtl.drugTitle = drugList.Name;
    [self.navigationController pushViewController:drugCtl animated:YES];
}

#pragma mark - NET
-(void)GetDieaseInfoRequset {
    
    [self showProgressWithText:@"正在加载"];
    
    [HTTPTool requestWithURLString:@"/api/Disease/GetDiseaseDetails" parameters:@{@"id":@(self.DieaseID)} type:kGET success:^(id responseObject) {

        self.myTab.hidden = NO;
        
        [self dismissProgress];
       
        [self.dataArr removeAllObjects];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DDLogDebug(@"%@",jsonStr);
         
        
        self.dieaseModel = [BATDieaseDetailModel mj_objectWithKeyValues:responseObject];

        for (int i=0; i<8; i++) {
            switch (i) {
                case 0: {
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
            
                    model.name = _dieaseModel.Data.Disease_Name;
                    
                    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithData:[_dieaseModel.Data.Briefintro_Content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
                    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributedString1.length)];
                    
                    
                    if (![_dieaseModel.Data.Briefintro_Content containsString:@"<p"]) {
                        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle1 setLineSpacing:10];
                        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
                    }
                    
                    model.detailLb = attributedString1.string;
                    [self.dataArr addObject:model];
                    break;
                }
                case 1: {
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"相关症状";
                    
                    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithData:[_dieaseModel.Data.Common_Symptom_Desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
                    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributedString1.length)];
                    

                    if (![_dieaseModel.Data.Common_Symptom_Desc containsString:@"<p"]) {
                        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle1 setLineSpacing:10];
                        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
                    }
                    
                    model.detailLb = attributedString1.string;
                    [self.dataArr addObject:model];
                    break;
                
                }
                case 2: {
                    
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"并发症";
                    
                    model.detailLb = _dieaseModel.Data.Concurrent_Disease_Nlist;
                    [self.dataArr addObject:model];
                    break;
                    
                    
                }
                case 3: {
                    
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"易感人群";
                    
                    model.detailLb = _dieaseModel.Data.Susceptible_Population;
                    [self.dataArr addObject:model];
                    break;
                    
                }
                case 4: {
                    
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"治愈率";
                    
                    model.detailLb = _dieaseModel.Data.Cure_Rate;
                    [self.dataArr addObject:model];
                    break;
                    break;
                }
                case 5: {
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    NSMutableString *nameString = [NSMutableString string];
                    for (int i=0; i<1; i++) {
                        [nameString appendString:@"常用药品"];
                    }
                    model.name = nameString;
                    
                    model.DieaseInfo = _dieaseModel.Data.Drugslst;
                    
                    if (model.DieaseInfo.count>=2) {
                        model.treatmentsCount = 2;
                    }else{
                        model.treatmentsCount = _dieaseModel.Data.Drugslst.count;
                    }
                    
                    [_dataArr addObject:model];
                    break;
                }
                case 6: {
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"相关疗法";
                    
                   
                    
                    CGSize examineSize = [_dieaseModel.Data.Inspection_Detail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
                    
                    NSMutableAttributedString *exaimString = [[NSMutableAttributedString alloc] initWithData:[_dieaseModel.Data.Inspection_Detail dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
                    [exaimString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, exaimString.length)];
                    
                    
                    if (![_dieaseModel.Data.Inspection_Detail containsString:@"<p"]) {
                        NSMutableParagraphStyle * exaimPara = [[NSMutableParagraphStyle alloc] init];
                        [exaimPara setLineSpacing:10];
                        [exaimString addAttribute:NSParagraphStyleAttributeName value:exaimPara range:NSMakeRange(0, [exaimString length])];
                    }
                    _dieaseModel.Data.Inspection_Detail = exaimString.string;
                    
                    if (examineSize.height < 40) {
                        model.isExaimBtnShow = NO;
                    }else {
                        model.isExaimBtnShow = YES;
                    }
                    
                    CGSize treatmentSize = [_dieaseModel.Data.Treatment_Detail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
                    
                    if (treatmentSize.height < 40) {
                        model.isTreatmentBtnShow = NO;
                    }else {
                        model.isTreatmentBtnShow = YES;
                    }
                    
                    NSMutableAttributedString *treamtmentString = [[NSMutableAttributedString alloc] initWithData:[_dieaseModel.Data.Treatment_Detail dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
                    [treamtmentString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, treamtmentString.length)];
                    
                    
                    if (![_dieaseModel.Data.Treatment_Detail containsString:@"<p"]) {
                        NSMutableParagraphStyle * treamtmentPara = [[NSMutableParagraphStyle alloc] init];
                        [treamtmentPara setLineSpacing:10];
                        [treamtmentString addAttribute:NSParagraphStyleAttributeName value:treamtmentPara range:NSMakeRange(0, [treamtmentString length])];
                    }
                    
                    _dieaseModel.Data.Treatment_Detail = treamtmentString.string;
                    
                    CGSize nurseDetailSize = [_dieaseModel.Data.Nursing_Detail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
                    
                    if (nurseDetailSize.height < 40) {
                        model.isNurseBtnShow = NO;
                    }else {
                        model.isNurseBtnShow = YES;
                    }
                    
                    NSMutableAttributedString *nurseString = [[NSMutableAttributedString alloc] initWithData:[_dieaseModel.Data.Nursing_Detail dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:14]} documentAttributes:nil error:nil];
                    [nurseString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, nurseString.length)];
                    
                    
                    if (![_dieaseModel.Data.Nursing_Detail containsString:@"<p"]) {
                        NSMutableParagraphStyle * nursePara = [[NSMutableParagraphStyle alloc] init];
                        [nursePara setLineSpacing:10];
                        [nurseString addAttribute:NSParagraphStyleAttributeName value:nursePara range:NSMakeRange(0, [nurseString length])];
                    }
                    _dieaseModel.Data.Nursing_Detail = nurseString.string;
                    
                    NSArray *arr = @[_dieaseModel.Data.Inspection_Detail,_dieaseModel.Data.Treatment_Detail,_dieaseModel.Data.Nursing_Detail];
                    
                    model.treatmentArr = arr;
                    [_dataArr addObject:model];
                    break;
                }
                case 7: {
                    BATDieaseDetailEntityModel *model = [[BATDieaseDetailEntityModel alloc]init];
                    
                    model.name = @"相关疾病";
                    
                    
                    model.relateDieaseArr = _dieaseModel.Data.AboutDiseaselst;
                    [_dataArr addObject:model];
                    break;
                }
                default:
                    break;
            }
            
        }
        
        NSInteger count = [[self.dataArr[7] relateDieaseArr] count];
        self.heights = (count+1 )*35;//不管怎么样都要留出一行距离
        
        if (_dataArr.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        [self.myTab reloadData];
        
        //通知collectionView刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
        
    } failure:^(NSError *error) {
        self.myTab.hidden = NO;
        [self showErrorWithText:error.localizedDescription];

        [self.defaultView showDefaultView];
    }];
   
}



#pragma mark -pageLayout
-(void)pageLayout {
    self.myTab.hidden = YES;
    self.title = @"疾病百科";
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heightAction:) name:@"SENDHEIGHT" object:nil];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];

}

-(void)heightAction:(NSNotification *)notice {
    self.heights = [notice.object floatValue];
    [self.myTab reloadData];
    
}

#pragma mark - SETTER - GETTER
-(UITableView *)myTab{
    if (!_myTab) {
        _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTab.delegate = self;
        _myTab.dataSource = self;
        _myTab.emptyDataSetSource = self;
        _myTab.emptyDataSetDelegate = self;
        [_myTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_myTab registerClass:[BATDieaseCell class] forCellReuseIdentifier:DieaseCellReuseName];
        [_myTab registerClass:[BATAdministrativeCell class] forCellReuseIdentifier:AdministerReuseName];
        [_myTab registerClass:[BATDrugCell class] forCellReuseIdentifier:DrugReuseName];
        [_myTab registerClass:[BATRelateTreatmentCell class] forCellReuseIdentifier:TreatmentReuseName];
        [_myTab registerClass:[BATRelateDieaseCell class] forCellReuseIdentifier:RelateDieaseReuseName];
        [_myTab registerClass:[BATSecondDieaseCell class] forCellReuseIdentifier:@"BATSecondDieaseCell"];
        
        _myTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    }
    return  _myTab;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
            
            [self GetDieaseInfoRequset];
        }];
        
    }
    return _defaultView;
}

- (BATShowView *)showView {

    if (!_showView) {
        _showView = [[BATShowView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
        _showView.alpha = 0;
    }
    return _showView;
}
@end
