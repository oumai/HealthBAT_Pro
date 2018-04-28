//
//  DrugInfoDetailViewController.m
//  HealthBAT
//
//  Created by four on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDrugInfoDetailViewController.h"
//model
#import "DrugModel.h"
//cell
#import "DrugAttributeCell.h"
#import "DrugGoodsDetailCell.h"

#import "BATGraditorButton.h"

static  NSString * const DRUGOODS_CELL = @"DrugGoodsCell";
static  NSString * const DRUGDETAIL_CELL = @"DrugDetailCell";

@interface BATDrugInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BATGraditorButton *_goodsBtn;
    BATGraditorButton *_detailBtn;
    UIView  *_line;
//    NSInteger _currentIndex; //0：商品 1：详情
    UIScrollView *contentView;
    BOOL IsButton;
    
}
@property (nonatomic,strong) UITableView *tvLeftContent;

@property (nonatomic,strong) UITableView *tvRightContent;

@property (nonatomic,strong) DrugModel *drugModel;

@property (nonatomic,strong) NSString *beginTime;


@end

@implementation BATDrugInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = self.drugTitle;
    self.title = @"药品详情";
//    _currentIndex = 0;
    
    [self creatSegment];
    
//    [self.view addSubview:self.tvContent];
    [self initContentView];
    
    [self getDrugDetail];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self popAction];
}

-(void)popAction {
    /*
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Tools getPostUUID] forKey:@"deviceNo"];
    [dict setValue:@"IOS" forKey:@"deviceType"];
    if (LOGIN_STATION) {
        [dict setValue:[Tools getCurrentID] forKey:@"userId"];
    }
    NSString *ipString = [Tools get4GorWIFIAddress];
    [dict setValue:ipString forKey:@"userIp"];
    [dict setValue:@"drug_info" forKey:@"moduleName"];
    [dict setValue:self.drugID forKey:@"moduleId"];
    [dict setValue:self.drugTitle forKey:@"browsePage"];
    [dict setValue:self.beginTime forKey:@"startTime"];
    [dict setValue:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"leaveTime"];
    
    [HTTPTool requestWithSearchURLString:@"/kmStatistical-sync/saveUserBrowse" parameters:dict success:^(id responseObject) {
        NSLog(@"11111");
    } failure:^(NSError *error) {
        
    }];
     */
    [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"drug_info" moduleId:self.drugID beginTime:self.beginTime browsePage:self.pathName];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tvLeftContent) {
        return 2;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tvLeftContent) {
        if(section == 0){
            return 1;
        }else{
            return 6;
        }
    }else{
        if(section == 0){
            return 1;
        }else{
            return 8;
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DurgData *drugDict = self.drugModel.Data;
    
    if (tableView == self.tvLeftContent) {
        if (indexPath.section == 0) {
            DrugGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DRUGOODS_CELL];
            if(cell == nil){
                cell = [[DrugGoodsDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DRUGOODS_CELL];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:drugDict.PICTURE_URL] placeholderImage:[UIImage imageNamed:@"默认图"]];
            
            NSString *nameStr = @"";
            if ([drugDict.DRUG_NAME isEqual:[NSNull null]] || drugDict.DRUG_NAME == nil) {
                nameStr = [NSString stringWithFormat:@"商品名称："];
            }else{
                nameStr = [NSString stringWithFormat:@"商品名称：%@",drugDict.DRUG_NAME];
            }
            
            //添加文字属性
            NSMutableAttributedString *nameAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:nameStr font:16][0]];
            CGSize nameSize = [nameStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:nameStr font:16][1] context:nil].size;
            cell.nameLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x, CGRectGetMaxY(cell.imageV.frame) + 32, SCREEN_WIDTH - 20, nameSize.height);
            cell.nameLabel.attributedText = nameAttributedStr;
            
            NSString *subNameStr = @"";
            if ([drugDict.DRUG_ALIAS isEqual:[NSNull null]] || drugDict.DRUG_ALIAS == nil) {
                subNameStr= [NSString stringWithFormat:@"通用名称："];
            }else{
                subNameStr= [NSString stringWithFormat:@"通用名称：%@",drugDict.DRUG_ALIAS];
            }
            
            
            //添加文字属性
            NSMutableAttributedString *subNameAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:subNameStr font:16][0]];
            CGSize subNameSize = [subNameStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:subNameStr font:16][1] context:nil].size;
            cell.subNameLabel.frame = CGRectMake(cell.subNameLabel.frame.origin.x, CGRectGetMaxY(cell.nameLabel.frame) + 10, SCREEN_WIDTH - 20, subNameSize.height);
            cell.subNameLabel.attributedText = subNameAttributedStr;
            
            
            NSString *priceStr = [NSString stringWithFormat:@"参考价：%@%@",[drugDict.PRICE floatValue]>0?@"￥":@"",[drugDict.PRICE floatValue]?drugDict.PRICE:@"暂无"];
            //添加文字属性
            NSMutableAttributedString *priceAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:priceStr font:15][0]];
            CGSize priceSize = [priceStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:priceStr font:15][1] context:nil].size;
            cell.priceLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x, CGRectGetMaxY(cell.subNameLabel.frame) + 27, SCREEN_WIDTH - 20, priceSize.height);
            cell.priceLabel.attributedText = priceAttributedStr;
            
            [priceAttributedStr addAttribute:NSFontAttributeName
             
                                       value:[UIFont systemFontOfSize:15.0]
             
                                       range:NSMakeRange(0, 4)];
            
            [priceAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                       value:UIColorFromHEX(0x999999,1)
             
                                       range:NSMakeRange(0, 4)];
            
            cell.priceLabel.attributedText = priceAttributedStr;
            
            CGFloat height = 24 + 432/590.0*(SCREEN_WIDTH - 78) + 32 + 10 + 27 + nameSize.height + subNameSize.height + priceSize.height;
            DDLogDebug(@"%f",height);
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
            return cell;
            
        }else{
            
            DrugAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:DRUGDETAIL_CELL];
            if(cell == nil){
                cell = [[DrugAttributeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DRUGDETAIL_CELL];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            cell.bottomLine.hidden = YES;

            NSString *descStr = @"";
            if (indexPath.row == 0) {
                if (drugDict.INDICATIONS.length > 0) {
                   descStr = [NSString stringWithFormat:@"功能主治：%@\n",drugDict.INDICATIONS];
                    cell.bottomLine.hidden = NO;
                }
            }else if(indexPath.row == 1){
                if (drugDict.CAT_NAME.length > 0) {
                    descStr = [NSString stringWithFormat:@"药品属性：%@",drugDict.CAT_NAME];
                }
            }else if(indexPath.row == 2){
                if (drugDict.DOSAGE_FORM.length > 0) {
                    descStr = [NSString stringWithFormat:@"剂型：%@",drugDict.DOSAGE_FORM];
                }
            }else if(indexPath.row == 3){
                if (drugDict.INSTRUCTIONS.length > 0) {
                    descStr = [NSString stringWithFormat:@"用法用量：%@",drugDict.INSTRUCTIONS];
                }
                
            }else if(indexPath.row == 4){
                if (drugDict.MANUFACTOR_NAME.length > 0) {
                    descStr = [NSString stringWithFormat:@"生产企业：%@",drugDict.MANUFACTOR_NAME];
                }
                
            }else if(indexPath.row == 5){
                if (drugDict.DiseaseList.count > 0) {
                    
                    NSMutableArray *diseaseList = [NSMutableArray array];
                    
                    for (DiseaseList *disease in drugDict.DiseaseList) {
                        [diseaseList addObject:disease.Disease_Name];
                    }
                    descStr = [NSString stringWithFormat:@"相关疾病：%@",[diseaseList componentsJoinedByString:@"、"]];
                }
            }

            
//            NSString *descStr = @"";
//            if (indexPath.row == 0) {
//                if ([drugDict.INDICATIONS isEqual:[NSNull null]] || drugDict.INDICATIONS != nil) {
//                    descStr = [NSString stringWithFormat:@"功能主治："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"功能主治：%@",drugDict.INDICATIONS];
//                }
//            }else if(indexPath.row == 1){
//                if ([drugDict.CAT_NAME isEqual:[NSNull null]] || drugDict.CAT_NAME == nil) {
//                    descStr = [NSString stringWithFormat:@"药品属性："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"药品属性：%@",drugDict.CAT_NAME];
//                }
//                
//            }else if(indexPath.row == 2){
//                descStr = [NSString stringWithFormat:@"剂型："];
//            }else if(indexPath.row == 3){
//                if ([drugDict.INSTRUCTIONS isEqual:[NSNull null]] || drugDict.INSTRUCTIONS == nil) {
//                    descStr = [NSString stringWithFormat:@"用法用量："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"用法用量：%@",drugDict.INSTRUCTIONS];
//                }
//                
//            }else if(indexPath.row == 4){
//                if ([drugDict.MANUFACTOR_NAME isEqual:[NSNull null]] || drugDict.MANUFACTOR_NAME == nil) {
//                    descStr = [NSString stringWithFormat:@"生产企业："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"生产企业：%@",drugDict.MANUFACTOR_NAME];
//                }
//                
//            }else if(indexPath.row == 5){
//                descStr = [NSString stringWithFormat:@"相关疾病："];
//            }
            
            if (descStr.length > 0) {
                //添加文字属性
                NSMutableAttributedString *descAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:descStr font:15][0]];
                
                if (indexPath.row == 2) {
                    
                    [descAttributedStr addAttribute:NSFontAttributeName
                     
                                              value:[UIFont systemFontOfSize:15.0]
                     
                                              range:NSMakeRange(0, 3)];
                    
                    [descAttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                              value:UIColorFromHEX(0x999999,1)
                     
                                              range:NSMakeRange(0, 3)];
                    
                    
                }else{
                    
                    [descAttributedStr addAttribute:NSFontAttributeName
                     
                                              value:[UIFont systemFontOfSize:15.0]
                     
                                              range:NSMakeRange(0, 5)];
                    
                    [descAttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                              value:UIColorFromHEX(0x999999,1)
                     
                                              range:NSMakeRange(0, 5)];
                    
                }
                
                cell.titleLabel.attributedText = descAttributedStr;

            }
            

            
//            CGSize size = [descStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:descStr font:15][1] context:nil].size;
            
//            cell.titleLabel.backgroundColor = [UIColor redColor];
//            cell.titleLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, size.height + 15);
//            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height + 15);
            return cell;
        }
        
    }else{
        DrugAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:DRUGDETAIL_CELL];
        if(cell == nil){
            cell = [[DrugAttributeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DRUGDETAIL_CELL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLabel.textColor = UIColorFromHEX(0x999999,1);

        NSString *descStr = @"";
        NSRange range = NSMakeRange (0, 0);
        if (indexPath.section == 0){
            descStr = [NSString stringWithFormat:@"产品信息：PRODUCT INFORMATION"];
            
            cell.titleLabel.textColor = UIColorFromHEX(0x82aa53,1);
            range = NSMakeRange (0, 5);
        }else{
            
            if (indexPath.row == 0) {
                if (drugDict.SIDEEFFECTS.length > 0) {
                    descStr = [NSString stringWithFormat:@"不良反应：%@",drugDict.SIDEEFFECTS];
                    
                    range = NSMakeRange (0, 5);
                }
            }else if(indexPath.row == 1){
                if (drugDict.UNSUITABLE_PEOPLE.length > 0) {
                    descStr = [NSString stringWithFormat:@"禁忌：%@",drugDict.UNSUITABLE_PEOPLE];
                    
                    range = NSMakeRange (0, 3);
                }
            }else if(indexPath.row == 2){
                if (drugDict.NOTICE.length > 0) {
                    descStr = [NSString stringWithFormat:@"注意事项：%@",drugDict.NOTICE];
                    range = NSMakeRange (0, 5);
                }
            }else if(indexPath.row == 3){
                if (drugDict.COMPOSITION.length > 0) {
                    descStr = [NSString stringWithFormat:@"成分：%@",drugDict.COMPOSITION];
                    range = NSMakeRange (0, 3);
                }
            }else if(indexPath.row == 4){
                if (drugDict.WOMEN_MEDICATION.length > 0) {
                    descStr = [NSString stringWithFormat:@"孕妇及哺乳期妇女用药：%@",drugDict.WOMEN_MEDICATION];
                    range = NSMakeRange (0, 11);
                }
            }else if(indexPath.row == 5){
                if (drugDict.CHILD_MEDICATION.length > 0) {
                    descStr = [NSString stringWithFormat:@"儿童用药：%@",drugDict.CHILD_MEDICATION];
                    range = NSMakeRange (0, 5);
                }
            }else if(indexPath.row == 6){
                if (drugDict.ELDERLY_MEDICATION.length > 0) {
                    descStr = [NSString stringWithFormat:@"老年用药：%@",drugDict.ELDERLY_MEDICATION];
                    range = NSMakeRange (0, 5);
                }
            }else if(indexPath.row == 7){
                if (drugDict.DRUG_INTERACTION.length > 0) {
                    descStr = [NSString stringWithFormat:@"药物相互作用：%@",drugDict.DRUG_INTERACTION];
                    range = NSMakeRange (0, 7);
                }
            }
            
//            if (indexPath.row == 0) {
//                if ([drugDict.SIDEEFFECTS isEqual:[NSNull null]] || drugDict.SIDEEFFECTS == nil) {
//                    descStr = [NSString stringWithFormat:@"不良反应："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"不良反应：%@",drugDict.SIDEEFFECTS];
//                }
//                
//                range = NSMakeRange (0, 5);
//            }else if(indexPath.row == 1){
//                if ([drugDict.UNSUITABLE_PEOPLE isEqual:[NSNull null]] || drugDict.UNSUITABLE_PEOPLE == nil) {
//                    descStr = [NSString stringWithFormat:@"禁忌："];
//                }else{
//                    descStr = [NSString stringWithFormat:@"禁忌：%@",drugDict.UNSUITABLE_PEOPLE];
//                }
//                
//                range = NSMakeRange (0, 3);
//            }else if(indexPath.row == 2){
//                descStr = [NSString stringWithFormat:@"注意事项："];
//                range = NSMakeRange (0, 5);
//            }else if(indexPath.row == 3){
//                descStr = [NSString stringWithFormat:@"成分："];
//                range = NSMakeRange (0, 3);
//            }else if(indexPath.row == 4){
//                descStr = [NSString stringWithFormat:@"孕妇及哺乳期妇女用药："];
//                range = NSMakeRange (0, 11);
//            }else if(indexPath.row == 5){
//                descStr = [NSString stringWithFormat:@"儿童用药："];
//                range = NSMakeRange (0, 5);
//            }else if(indexPath.row == 6){
//                descStr = [NSString stringWithFormat:@"老年用药："];
//                range = NSMakeRange (0, 5);
//            }else if(indexPath.row == 7){
//                descStr = [NSString stringWithFormat:@"药物相互作用："];
//                range = NSMakeRange (0, 7);
//            }
            
        }
        
        if (descStr.length > 0) {
            //添加文字属性
            NSMutableAttributedString *descAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:descStr font:15][0]];
            
            [descAttributedStr addAttribute:NSFontAttributeName
             
                                      value:[UIFont systemFontOfSize:15.0]
             
                                      range:range];
            
            [descAttributedStr addAttribute:NSForegroundColorAttributeName
             
                                      value:UIColorFromHEX(0x333333,1)
             
                                      range:range];
            
            //        CGSize size = [descStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:descStr font:15][1] context:nil].size;
            //        cell.titleLabel.backgroundColor = [UIColor redColor];
            cell.titleLabel.attributedText = descAttributedStr;
            //        cell.titleLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, size.height + 15);
            //        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height + 15);
        }
        

        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tvLeftContent) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [self tableView:self.tvLeftContent cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
        return UITableViewAutomaticDimension;
    }else{
        if (indexPath.section == 0) {
            return 40;
        }
        return UITableViewAutomaticDimension;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tvLeftContent) {
        return nil;
    }else{
        DurgData *drugDict = self.drugModel.Data;
        
        if(section == 0){
            return nil;
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = drugDict.DRUG_ALIAS==nil?drugDict.DRUG_NAME:drugDict.DRUG_ALIAS;
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = UIColorFromHEX(0x45a0f0,1);
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            return view;
        }
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tvLeftContent) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        if (section == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }else{
            return nil;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tvLeftContent) {
        return CGFLOAT_MIN;
    }else{
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
//            DurgData *drugDict = self.drugModel.Data;
//            if ([drugDict.DRUG_NAME isEqual:[NSNull null]] ||  drugDict.DRUG_NAME == nil) {
//                return 0.000001;
//            }else{
//                return 60;
//            }
            return 60;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == self.tvLeftContent) {
        if (section == 0) {
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        if (section == 0) {
            return 1;
        }else{
            return CGFLOAT_MIN;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/**
 *  文字加属性
 *
 *  @return 富文本属性数组
 */
- (NSArray *)titleAddAttribute:(NSString *)descStr font:(NSUInteger)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.2f
                          };
    
    NSMutableAttributedString *descAttributedStr = [[NSMutableAttributedString alloc] initWithString:descStr attributes:dic];
    
    NSArray *array = @[descAttributedStr,dic];
    return array;
}


/**
 *  选择按钮
 */
-(void)creatSegment{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _goodsBtn = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
    _goodsBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
    [_goodsBtn setTitle:@"商品" forState:UIControlStateNormal] ;
    _goodsBtn.enbleGraditor = YES;
    _goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_goodsBtn setGradientColors:@[START_COLOR,END_COLOR]];
    
//    _goodsBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
//    _goodsBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
//    [_goodsBtn setTitle: @"商品" forState:UIControlStateNormal];
//    [_goodsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_goodsBtn setTitleColor:BASE_COLOR forState:UIControlStateSelected];
//    _goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_goodsBtn addTarget:self action:@selector(btnSegmentClick:) forControlEvents:UIControlEventTouchUpInside];
    _goodsBtn.selected = YES;//默认选择第一项
    [backView addSubview:_goodsBtn];
    
    
    _detailBtn = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
    _detailBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44);
    [_detailBtn setTitle:@"详情" forState:UIControlStateNormal] ;
    _detailBtn.enbleGraditor = YES;
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_detailBtn setGradientColors:@[[UIColor blackColor] ,[UIColor blackColor] ]];
//    _detailBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
//    _detailBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44);
//    [_detailBtn setTitle: @"详情" forState:UIControlStateNormal];
//    [_detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_detailBtn setTitleColor:BASE_COLOR forState:UIControlStateSelected];
//    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_detailBtn addTarget:self action:@selector(btnSegmentClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_detailBtn];
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH/2, 3.75)];
    _line.backgroundColor = START_COLOR;
    [backView addSubview:_line];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.75, SCREEN_WIDTH, 0.25)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
}

#pragma mark -点击方法
-(void)btnSegmentClick:(UIButton *)sender
{
    if (sender == _goodsBtn)
    {
//        _detailBtn.selected = NO;
        [_detailBtn setGradientColors:@[[UIColor blackColor] ,[UIColor blackColor] ]];
        [_goodsBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [self lineAnimation:sender];
        [contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
//        _goodsBtn.selected = NO;
        [_goodsBtn setGradientColors:@[[UIColor blackColor] ,[UIColor blackColor] ]];
        [_detailBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [self lineAnimation:sender];
        [contentView setContentOffset: CGPointMake(SCREEN_WIDTH,0) animated:YES ];
    }
    IsButton = YES;
}

-(void)lineAnimation:(UIButton *)sender{
    UIView *view = sender.superview;
    for (UIButton *btn in view.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    _line.frame = CGRectMake(sender.frame.origin.x , 41, SCREEN_WIDTH/2, 3.75);
    [UIView commitAnimations];
}

#pragma mark - 网络请求
- (void)getDrugDetail{
    
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Drug/GetDrugDetail?ID=%@",self.drugID] parameters:nil type:kGET success:^(id responseObject) {
        self.drugModel = [DrugModel mj_objectWithKeyValues:responseObject];
        [self.tvLeftContent reloadData];
        [self.tvRightContent reloadData];
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return ;
    }];
    /*
    [HTTPTool GETMethodWithURL:[NSString stringWithFormat:@"/api/Drug/GetDrugDetail?ID=%@",self.drugID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.drugModel = [DrugModel mj_objectWithKeyValues:responseObject];
//        DLog(@"药品详情%@", responseObject);
        if (self.drugModel.ResultCode == 0) {
            [self.tvLeftContent reloadData];
            [self.tvRightContent reloadData];
        }else if (self.drugModel.ResultCode == -1) {
            [self showOnlyMessageHUD:self.drugModel.ResultMessage inView:self.view];
        }else{
            [self showOnlyMessageHUD:@"请重新登入" inView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showOnlyMessageHUD:BADNETWORK inView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return ;
    }];
     */
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    contentView.scrollEnabled = YES;
    CGPoint pt =scrollView.contentOffset;
    if(scrollView == contentView){
        if (pt.x == 0){
            [self lineAnimation: _goodsBtn];
        }
        else{
            [self lineAnimation: _detailBtn];
        }
    }

}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//    if(scrollView == self.tvLeftContent){
//        //上滑动
//        if (IsButton) {
//            IsButton = NO;
//        }
//        
//        contentView.scrollEnabled = YES;
//        CGPoint pt =scrollView.contentOffset;
//
//        if (pt.y > 150 ){
//            [self lineAnimation: _detailBtn];
//        }
//    
//    }else if (scrollView == self.tvRightContent) {
//        
//    }else{
//        //左右滑动
//        contentView.scrollEnabled = YES;
//        CGPoint pt =scrollView.contentOffset;
//        if (pt.x == 0){
//            [self lineAnimation: _goodsBtn];
//        }
//        else{
//            [self lineAnimation: _detailBtn];
//        }
//    }
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(scrollView == self.tvLeftContent){
//        //上滑动
//        if (IsButton)
//        {
//            [self scrollViewDidEndDecelerating:contentView];
//            return;
//        }
//        CGPoint pt =scrollView.contentOffset;
//        if (pt.y > 150 && pt.x ==0)
//        {
//            contentView.scrollEnabled = NO;
//            [self btnSegmentClick: _detailBtn];
//        }
//    }else if (scrollView == self.tvRightContent) {
//        
//    }else{
//        //左右滑动
//    }
//
//}

#pragma mark -setter & getter
- (UITableView *)tvLeftContent{
    if (!_tvLeftContent) {
        _tvLeftContent = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) style:UITableViewStyleGrouped];
        _tvLeftContent.backgroundColor = [UIColor clearColor];
        _tvLeftContent.delegate = self;
        _tvLeftContent.dataSource = self;
        _tvLeftContent.estimatedRowHeight = 40;
//        _tvLeftContent.bounces = YES;
        _tvLeftContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tvLeftContent;
}

- (UITableView *)tvRightContent{
    if (!_tvRightContent) {
        _tvRightContent = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) style:UITableViewStyleGrouped];
        _tvRightContent.backgroundColor = [UIColor clearColor];
        _tvRightContent.delegate = self;
        _tvRightContent.dataSource = self;
        _tvRightContent.estimatedRowHeight = 40;
//        _tvRightContent.bounces = NO;
        _tvRightContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tvRightContent;
}

#pragma mark -
-(void)initContentView
{
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
//    contentView.bounces = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    [contentView setContentSize: CGSizeMake( SCREEN_WIDTH*2, SCREEN_HEIGHT-64 -45)];
    [self.view addSubview:contentView];
    [contentView addSubview:self.tvLeftContent];
    [contentView addSubview:self.tvRightContent];
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
