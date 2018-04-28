//
//  BATNewHospitalInfoDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewHospitalInfoDetailViewController.h"

//cell
#import "DrugAttributeCell.h"

@interface BATNewHospitalInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BATNewHospitalInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DrugAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrugAttributeCell"];
    
    cell.titleLabel.textColor = UIColorFromHEX(0x999999,1);
    
    NSString *descStr = @"";
    NSRange range = NSMakeRange (0, 0);
    if (indexPath.section == 0){
        descStr = [NSString stringWithFormat:@"医院信息 HOSPITAL INFORMATION"];
        
        cell.titleLabel.textColor = UIColorFromHEX(0x82aa53,1);
        range = NSMakeRange (0, 4);
        //添加文字属性
        NSMutableAttributedString *descAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:descStr font:15][0]];
        
        [descAttributedStr addAttribute:NSFontAttributeName
         
                                  value:[UIFont systemFontOfSize:15.0]
         
                                  range:range];
        
        [descAttributedStr addAttribute:NSForegroundColorAttributeName
         
                                  value:UIColorFromHEX(0x333333,1)
         
                                  range:range];
        
        CGSize size = [descStr boundingRectWithSize:CGSizeMake(  SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:descStr font:15][1] context:nil].size;
        
        cell.titleLabel.attributedText = descAttributedStr;
        cell.titleLabel.frame = CGRectMake(10, 5,   SCREEN_WIDTH - 20, size.height + 15);
        cell.frame = CGRectMake(0, 0,   SCREEN_WIDTH, size.height + 15);
        return cell;
        
    }else{
        if (self.hospitalDetailModel.Data.DETAIL == nil) {
            descStr = [NSString stringWithFormat:@""];
        }else{
            descStr = self.hospitalDetailModel.Data.DETAIL;
        }
        //添加文字属性
        NSMutableAttributedString *descAttributedStr  = [[NSMutableAttributedString alloc]initWithAttributedString:[self titleAddAttribute:descStr font:15][0]];
        
        CGSize size = [descStr boundingRectWithSize:CGSizeMake(  SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self titleAddAttribute:descStr font:15][1] context:nil].size;
        //            cell.titleLabel.backgroundColor = [UIColor redColor];
        cell.titleLabel.attributedText = descAttributedStr;
        cell.titleLabel.frame = CGRectMake(10, 5,   SCREEN_WIDTH - 20, size.height + 15);
        cell.frame = CGRectMake(0, 0,SCREEN_WIDTH, size.height + 30);
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HospitalDetailData *data = self.hospitalDetailModel.Data;
    
    if(section == 0){
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,   SCREEN_WIDTH, 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,   SCREEN_WIDTH, 60)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@简介",data.UNIT_NAME==nil?self.hospitalDetailModel:data.UNIT_NAME];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = UIColorFromHEX(0x45a0f0,1);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        return view;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,   SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        return nil;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.000001;
    }else{
        return 60;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 0.0000001;
    }
    
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


#pragma mark - layoutPages
- (void)layoutPages{

    WEAK_SELF(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.bottom.equalTo(self.view);
    }];
}



#pragma mark -setter & getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[DrugAttributeCell class] forCellReuseIdentifier:@"DrugAttributeCell"];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
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
