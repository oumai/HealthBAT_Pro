//
//  BATTraditionFouthViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionFouthViewController.h"
#import "BATFourthTableViewCell.h"
#import "BATFourthHeaderView.h"
#import "BATTraditionNextFooter.h"

#import "BATTraditionMedicineHumanUIViewController.h"

static  NSString * const FOURTH_CELL = @"BATFourthTableViewCell";

@interface BATTraditionFouthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *questionTableView;
@property (nonatomic,copy) NSArray *questionArray;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *popBtn;
@property (nonatomic,assign) NSInteger expandSection;

@property (nonatomic,strong) NSMutableDictionary *answerDic;
@property (nonatomic,strong) NSMutableArray *healthResultArray;

@end

@implementation BATTraditionFouthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.questionArray = @[
                           @"您手脚发凉吗？",
                           @"您比一般人耐受不了寒冷吗？",
                           @"您不太适应季节气候和地域环境的变化，比别人容易患感冒吗？",
                           @"您感到手脚心发热吗？",
                           @"您感觉身体、脸上发热吗？",
                           @"您容易便秘或大便干燥吗？",
                           @"你精力不够充沛，容易疲乏吗？",
                           @"您说话声音无力吗？",
                           @"您感到胸闷或腹部胀满吗？",
                           @"您嘴里有黏黏的感觉吗？",
                           @"你容易生痤疮或疮疖吗？",
                           @"您感到闷闷不乐吗？",
                           @"您容易精神紧张、焦虑不安吗？",
                           @"您容易受到惊吓或感到害怕吗？",
                           @"您面色晦黯或容易出现褐斑吗？",
                           @"您容易忘事吗？",
                           @"您容易过敏（对药物、食物、气味、花粉或在气候变化时）吗？",
                           @"您因过敏出现过紫癜（紫红色瘀点、瘀斑）吗？",
                           @"您容易失眠吗？",
                           ];
    self.expandSection = 0;

    self.answerDic = [NSMutableDictionary dictionary];
    NSArray *tmpArray = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"},@{@"id":@"6"},@{@"id":@"7"},@{@"id":@"8"},@{@"id":@"9"},@{@"id":@"10"},@{@"id":@"11"},@{@"id":@"12"},@{@"id":@"13"},@{@"id":@"14"},@{@"id":@"15"},@{@"id":@"16"},@{@"id":@"17"},@{@"id":@"18"},@{@"id":@"19"},@{@"id":@"20"}];
    self.healthResultArray = [NSMutableArray arrayWithArray:tmpArray];

    [self layoutPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.questionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == self.expandSection) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATFourthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FOURTH_CELL forIndexPath:indexPath];

    if ([self.answerDic.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        NSIndexPath *tmpIndexPath = self.answerDic[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        cell.tmpIndexPath = tmpIndexPath;
    }
    else {
        cell.tmpIndexPath = nil;
    }
    [cell.answerCollectionView reloadData];

    __weak BATFourthTableViewCell *weakCell = cell;
    WEAK_SELF(self);
    [cell setAnswerSelectedIndexPath:^(NSIndexPath *answerIndexPath) {
        STRONG_SELF(self);
        [self.answerDic setObject:answerIndexPath forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        weakCell.tmpIndexPath = answerIndexPath;
        [weakCell.answerCollectionView reloadData];
    }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    BATFourthHeaderView *header = [[BATFourthHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    header.questionLabel.text = self.questionArray[section];

    WEAK_SELF(self);
    [header bk_whenTapped:^{

        STRONG_SELF(self);
        self.expandSection = section;
        [self.questionTableView reloadData];
    }];
    return header;
}

- (void)createParaAndRequest {

    NSArray *answerArray = @[@"没有",@"很少",@"有时",@"经常",@"总是"];

    for (NSString *key in self.answerDic.allKeys) {

        NSIndexPath *indexPath = self.answerDic[key];
        NSDictionary *tmpDic = self.healthResultArray[[key integerValue]];
        NSMutableDictionary *tmpDicM = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        [tmpDicM setObject:answerArray[indexPath.row] forKey:@"result"];

        [self.healthResultArray replaceObjectAtIndex:[key integerValue] withObject:tmpDicM];
    }

    NSString *healthResult = [Tools dataTojsonString:self.healthResultArray];
    self.model.HealthResult = healthResult;

    [self SavePatientInfoRequest];
}

#pragma mark - net
- (void)SavePatientInfoRequest {

    [HTTPTool requestWithURLString:@"/api/ChineseMedicine/SavePatientInfo"
                        parameters:@{
                                     @"AccountID":@(self.model.AccountID),
                                     @"Height":@(self.model.Height),
                                     @"Weight":@(self.model.Weight),
                                     @"BodyStatus":self.model.BodyStatus,
                                     @"HealthResult":self.model.HealthResult
                                     }
                              type:kPOST
                           success:^(id responseObject) {

                               BATTraditionMedicineHumanUIViewController *vc = [[BATTraditionMedicineHumanUIViewController alloc] init];
                               vc.hidesBottomBarWhenPushed = YES;
                               [self.navigationController pushViewController:vc animated:YES];

                               [self bk_performBlock:^(id obj) {

                                   self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject,vc];
                                   
                               } afterDelay:1];
    }
                           failure:^(NSError *error) {
                               
                               [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - layout
- (void)layoutPages {

    WEAK_SELF(self);

    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];

    [self.view addSubview:self.popBtn];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.top.equalTo(@30);
    }];

    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.popBtn.mas_bottom).offset(15);
    }];

    [self.view addSubview:self.questionTableView];
    [self.questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(@0);
    }];
}

#pragma mark -  
- (UIImageView *)backgroundView {

    if (!_backgroundView) {

        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guoyiguan-back"]];

    }
    return _backgroundView;
}

- (UIButton *)popBtn {

    if (!_popBtn) {

        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_popBtn bk_whenTapped:^{

            [self createParaAndRequest];

        }];
    }
    return _popBtn;
}


- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:24] textColor:UIColorFromHEX(0xfefefe, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"体质测试";
    }
    return _titleLabel;
}

- (UITableView *)questionTableView {

    if (!_questionTableView) {

        _questionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        [_questionTableView registerClass:[BATFourthTableViewCell class] forCellReuseIdentifier:FOURTH_CELL];

        BATTraditionNextFooter *footer = [[BATTraditionNextFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        [footer.nextBtn bk_whenTapped:^{

            [self createParaAndRequest];
        }];
        _questionTableView.tableFooterView = footer;
        _questionTableView.backgroundColor = [UIColor clearColor];
        _questionTableView.rowHeight = (SCREEN_WIDTH-20)/5.0;

        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
    }
    return _questionTableView;
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
