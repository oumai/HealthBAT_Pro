//
//  HospitalRegisterViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegisterHospitalRegisterViewController.h"
#import "BATChooseTreatmentPersonController.h"
#import "BATVerifycodeCell.h"

#import "BATRegisterTableViewCell.h"
#import "BATTreatmentCell.h"
#import "BATRegisterFooterView.h"

#import "BATRegisterTimeModel.h"
#import "ChooseTreatmentModel.h"

#import "BATHealthFilesListVC.h"



@interface BATRegisterHospitalRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,BATVerifycodeCellDelegate>

@property (nonatomic,strong) UITableView           *confirmTableView;
@property (nonatomic,copy  ) NSArray               *dataArray;
@property (nonatomic,strong) BATRegisterFooterView *footerView;
@property (nonatomic,strong) BATRegisterTimeModel  *registerTime;

@property (nonatomic,copy  ) NSString              *timePara;
@property (nonatomic,copy  ) NSString              *END_TIME;
@property (nonatomic,copy  ) NSString              *BEGIN_TIME;

@property (nonatomic,strong) ChooseTreatmentModel *treatmentModel;
@property (nonatomic,strong) NSString *bookTime;

@end

@implementation BATRegisterHospitalRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"确认预约";

    self.dataArray = @[@"就诊医院",@"就诊科室",@"就诊医生",@"医生职称",@"预约费用"];
    [self pagesLayout];
    [self getSchDetl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 3) {
        return 1;
    }else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BATTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"treatmentCell"];
        if (self.treatmentModel) {
            cell.infoLabel.text = self.treatmentModel.name;
        }
        return cell;
    }else if (indexPath.section == 1) {
        BATRegisterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.eventLabel.text = self.dataArray[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.infoLabel.text = self.hospitalName;
                break;
            case 1:
                cell.infoLabel.text = self.departmentName;
                break;
            case 2:
                cell.infoLabel.text = self.doctorName;
                
                break;
            case 3:
            {
                NSString * level = @"";
                switch ([self.ZCID intValue]) {
                    case 1:
                        level = @"主任医生";
                        break;
                    case 2:
                        level = @"副主任医生";
                        break;
                    case 3:
                        level = @"主治医生";
                        break;
                    case 4:
                        level = @"医师";
                        break;
                    default:
                        level = @"医生";
                        break;
                }
                cell.infoLabel.text = level;
            }
                break;
            case 4:
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld",(long)self.duty.GUAHAO_AMT];
                break;
            default:
                break;
        }
        return cell; 
    }else if(indexPath.section == 2) {
        
        BATTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"treatmentCell"];
        NSDictionary * attDic = @{NSForegroundColorAttributeName:[UIColor redColor]};
        NSRange range;
        range.location = 6;
        range.length = 1;
        
        NSString * str = [NSString stringWithFormat:@"%@ *",@"就诊时间段"];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr setAttributes:attDic range:range];
        cell.eventLabel.attributedText = attStr;
        if (self.bookTime) {
            cell.infoLabel.text = self.bookTime;
        }else {
        cell.infoLabel.text = @"请选择就诊时段";
        }
        
        return cell;
    }else {
        BATVerifycodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"verifyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        if (self.treatmentModel) {
            NSMutableString *mutString = [NSMutableString stringWithString:self.treatmentModel.phoneNumber];
            [mutString replaceCharactersInRange:NSMakeRange(5, 4) withString:@"****"];
            cell.eventLabel.text = [NSString stringWithFormat:@"您的手机%@未验证,请先验证",mutString];
        }else {
        cell.eventLabel.text = @"请先确认就诊人及其电话";
        }
        return cell;
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3) {
        return 45;
    }else {
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }else {
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return nil;
    }else {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        sectionView.backgroundColor = BASE_LINECOLOR;
        return sectionView;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        BATHealthFilesListVC *chooseTreatmentVC = [[BATHealthFilesListVC alloc]init];
        chooseTreatmentVC.isConsultionAndAppointmentYes = YES;
        WEAK_SELF(self)
        chooseTreatmentVC.ChooseBlock = ^(ChooseTreatmentModel *model){
            STRONG_SELF(self)
            self.treatmentModel = model;
            
            [self.confirmTableView reloadData];
            
             BATTreatmentCell * nameCell = (BATTreatmentCell *)[self.confirmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            nameCell.infoLabel.text = model.name;
            
            [nameCell.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameCell.eventLabel.mas_right).offset(80);
                make.centerY.equalTo(nameCell.mas_centerY);
            }];
            
            [nameCell setNeedsUpdateConstraints];
            [nameCell layoutIfNeeded];
            
        };
        [self.navigationController pushViewController:chooseTreatmentVC animated:YES];
    }
    if (indexPath.section == 2) {
        UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:@"选择就诊时段" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Person_Detail_Head"]] forKey:@"_titleTextColor"];
        [actionSheet addAction:cancelAction];
        
        for (BATRegisterTimeData * time in self.registerTime.Data) {
            NSString * title = [NSString stringWithFormat:@"%@-%@ 剩余%ld",time.BEGIN_TIME,time.END_TIME,(long)time.LEFT_NUM];
            WEAK_SELF(self);
            
            
            UIAlertAction * timeAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF(self);
               

                NSString * chooseTime = [NSString stringWithFormat:@"%@ %@-%@",self.duty.TO_DATE,time.BEGIN_TIME,time.END_TIME];
                self.bookTime = chooseTime;
                BATTreatmentCell * cell = (BATTreatmentCell *)[self.confirmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                cell.infoLabel.text = chooseTime;
                
                [cell.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.eventLabel.mas_right).offset(55);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
                
                [cell setNeedsUpdateConstraints];
                [cell layoutIfNeeded];
                
                self.timePara = time.DETL_ID;
                self.BEGIN_TIME = time.BEGIN_TIME;
                self.END_TIME = time.END_TIME;

            }];
             [timeAction setValue:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Person_Detail_Head"]] forKey:@"_titleTextColor"];
            [actionSheet addAction:timeAction];
        }

        [self presentViewController:actionSheet animated:YES completion:nil];

    }
}

#pragma mark -BATVerifycodeCellDelegate
-(void)BATVerifycodeCellGetVerifyCodeWithBtn:(UIButton *)codeBtn {

 

        
    if (!self.treatmentModel) {
        [self showText:@"请先选择就诊人"];
        return;
    }
        
        [Tools countdownWithTime:120 End:^{
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            codeBtn.userInteractionEnabled = YES;
        } going:^(NSString *time) {
            [codeBtn setTitle:time forState:UIControlStateNormal];
            codeBtn.userInteractionEnabled = NO;
            
        }];

    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"%@/%@/0",@"/api/Account/SendVerifyCode",self.treatmentModel.phoneNumber] parameters:nil type:kGET success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        DDLogDebug(@"%@",error);
    }];
    
    
    
    
}

#pragma mark - Action
- (void)submitAction {
    
    if (!self.treatmentModel) {
        [self showErrorWithText:@"请选择就诊人"];
        return;
    }
    
    if (self.timePara.length == 0 ) {
        [self showErrorWithText:@"请选择就诊时间段"];
        return;
    }

  
    BATVerifycodeCell * nameCell = (BATVerifycodeCell *)[self.confirmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *verifyString = nameCell.infotextfiled.text;
    
    if (verifyString.length == 0 || [verifyString isEqualToString:@""] || verifyString == nil) {
        [self showErrorWithText:@"请先输入验证码"];
        return;
    }
    

    /*
    if (nameCell.inputTF.text.length == 0) {
        [self showErrorWithText:@"请填写就诊人"];

        return;
    }
    BATRegisterTableViewCell * cardCell = (BATRegisterTableViewCell *)[self.confirmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    if (cardCell.inputTF.text.length == 0) {
        [self showErrorWithText:@"请填写身份证"];

        return;
    }
    BATRegisterTableViewCell * phoneCell = (BATRegisterTableViewCell *)[self.confirmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

    if (phoneCell.inputTF.text.length == 0) {
        [self showErrorWithText:@"请填写手机号码"];
        return;
    }
     */
    //出生日期
   // NSString *birthDay = [NSString stringWithFormat:@"%@-%@-%@",[self.birthday substringWithRange:NSMakeRange(6, 4)],[self.birthday substringWithRange:NSMakeRange(10, 2)],[self.birthday substringWithRange:NSMakeRange(12, 2)]];

    
   /*
    * 改动前
    NSDictionary *params = @{
                             @"uid":@(self.hospitalID),
                             @"dep_id":@(self.departmentID),
                             @"doctor_id":@(self.doctorID),
                             @"phone":@"电话",
                             @"cardNo":@"身份证",
                             @"card_type":@"01",
                             @"truename":@"名字",
                             @"sex":@"0",
                             @"birth":birthDay,
                             @"detlid":self.timePara,
                             @"money":@(self.duty.GUAHAO_AMT),
                             @"clinic_no":@"",
                             @"cardPassword":@"",
                             @"visit_status":@""
                             };
    */
    
    NSDictionary *params = @{
                             @"memberID":self.treatmentModel.memberID,
                             @"invalId":self.treatmentModel.userID,
                             @"verifycode":verifyString,
                             @"phone":self.treatmentModel.phoneNumber,
                             @"money":@(self.duty.GUAHAO_AMT),
                             @"uid":@(self.hospitalID),
                             @"dep_id":@(self.departmentID),
                             @"doctor_id":@(self.doctorID),
                             @"detlid":self.timePara,
                             @"TO_DATES":self.duty.TO_DATE,
                             @"BEGIN_TIME":self.BEGIN_TIME,
                             @"END_TIME":self.END_TIME,
                             };

    

    [self submitRequestWithParams:params];
}

#pragma mark - NET
- (void)getSchDetl {
    NSDictionary *parammeters = @{
                                        @"uid":@(self.hospitalID),
                                      @"schid":self.duty.SCHEDULE_ID,
                                       @"page":@"",
                                  @"page_size":@"",
                                  };
    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/GetSchDetl" parameters:parammeters type:kGET success:^(id responseObject) {
        self.registerTime = [BATRegisterTimeModel mj_objectWithKeyValues:responseObject];
    } failure:^(NSError *error) {

    }];
}



- (void)submitRequestWithParams:(NSDictionary *)params {

    [self showProgress];

    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/SetYuyue" parameters:params type:kPOST success:^(id responseObject) {

        [self showSuccessWithText:@"预约成功"];

        [self bk_performBlock:^(id obj) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1.5];

    } failure:^(NSError *error) {

        [self showErrorWithText:error.localizedDescription];

    }];
}



#pragma mark - layout
- (void)pagesLayout {

    [self.view addSubview:self.confirmTableView];
}

#pragma mark - setter && getter
- (UITableView *)confirmTableView {
    if (!_confirmTableView) {
        _confirmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _confirmTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _confirmTableView.delegate = self;
        _confirmTableView.dataSource = self;
        _confirmTableView.estimatedRowHeight = 44;
        [_confirmTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_confirmTableView registerClass:[BATRegisterTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_confirmTableView registerClass:[BATTreatmentCell class] forCellReuseIdentifier:@"treatmentCell"];
        [_confirmTableView registerClass:[BATVerifycodeCell class] forCellReuseIdentifier:@"verifyCell"];
        _confirmTableView.tableFooterView = self.footerView;
    }
    return _confirmTableView;
}

- (BATRegisterFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[BATRegisterFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        WEAK_SELF(self);
        [_footerView setConfirmRegister:^{
            STRONG_SELF(self);
            [self submitAction];
        }];
    }
    return _footerView;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 BATRegisterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
 NSDictionary * attDic = @{NSForegroundColorAttributeName:[UIColor redColor]};
 NSRange range;
 range.location = 4;
 range.length = 1;
 
 cell.eventLabel.text = self.dataArray[indexPath.row];
 
 switch (indexPath.row) {
 case 0:
 {
 cell.eventLabel.text = nil;
 [cell.inputTF setHidden:NO];
 cell.inputTF.placeholder = @"请输入患者姓名";
 cell.inputTF.keyboardType = UIKeyboardTypeDefault;
 NSString * str = [NSString stringWithFormat:@"%@*",self.dataArray[indexPath.row]];
 NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
 [attStr setAttributes:attDic range:range];
 cell.eventLabel.attributedText = attStr;
 }
 break;
 case 1:
 {
 cell.eventLabel.text = nil;
 [cell.inputTF setHidden:NO];
 cell.inputTF.placeholder = @"请输入身份证号";
 cell.inputTF.keyboardType = UIKeyboardTypeDefault;
 NSString * str = [NSString stringWithFormat:@"%@*",self.dataArray[indexPath.row]];
 NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
 [attStr setAttributes:attDic range:range];
 cell.eventLabel.attributedText = attStr;
 }
 break;
 case 2:
 {
 cell.eventLabel.text = nil;
 [cell.inputTF setHidden:NO];
 cell.inputTF.placeholder = @"请输入手机号码";
 cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
 NSString * str = [NSString stringWithFormat:@"%@*",self.dataArray[indexPath.row]];
 NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
 [attStr setAttributes:attDic range:range];
 cell.eventLabel.attributedText = attStr;
 }
 break;
 case 3:
 cell.infoLabel.text = self.hospitalName;
 break;
 case 4:
 cell.infoLabel.text = self.departmentName;
 break;
 case 5:
 cell.infoLabel.text = self.doctorName;
 
 break;
 case 6:
 {
 NSString * level = @"";
 switch ([self.ZCID intValue]) {
 case 1:
 level = @"主任医生";
 break;
 case 2:
 level = @"副主任医生";
 break;
 case 3:
 level = @"主治医生";
 break;
 case 4:
 level = @"医师";
 break;
 default:
 level = @"医生";
 break;
 }
 cell.infoLabel.text = level;
 }
 break;
 case 7:
 cell.infoLabel.text = [NSString stringWithFormat:@"%ld",(long)self.duty.GUAHAO_AMT];
 break;
 case 8:
 {
 cell.eventLabel.text = nil;
 NSString * str = [NSString stringWithFormat:@"%@*",self.dataArray[indexPath.row]];
 NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
 [attStr setAttributes:attDic range:range];
 cell.eventLabel.attributedText = attStr;
 cell.infoLabel.text = @"请选择就诊时段";
 }
 break;
 
 default:
 break;
 }
 return cell;
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
