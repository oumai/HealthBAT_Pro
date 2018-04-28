//
//  BATContractViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//





//暂时不用，改用H5来显示
#import "BATContractViewController.h"

#import "BATContractShoutTextCell.h"
#import "BATContractlongTextCell.h"
#import "BATContractHeaderView.h"

static NSString *const ShoutText_CELL = @"BATContractShoutTextCell";
static NSString *const longText_CELL = @"BATContractlongTextCell";

@interface BATContractViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) UITableView                *contractTableView;

@property (nonatomic,strong) BATContractHeaderView      *contractHeaderView;

@property (nonatomic,strong) BATContractHeaderView      *contractFooterrView;

@end

@implementation BATContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pagesLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.contractTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            BATContractlongTextCell *longTextCell = [tableView dequeueReusableCellWithIdentifier:longText_CELL forIndexPath:indexPath];
            longTextCell.titleLable.text = @"服务内容";
            longTextCell.descLable.text = @"图文咨询";
            
            [longTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return longTextCell;
        }
            break;
        case 1:
        {
            BATContractlongTextCell *longTextCell = [tableView dequeueReusableCellWithIdentifier:longText_CELL forIndexPath:indexPath];
            longTextCell.titleLable.text = @"服务内容";
            longTextCell.descLable.text = @"图文咨询";
            
            [longTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return longTextCell;
        }
            break;
        case 2:
        {
            BATContractShoutTextCell *shoutTextCell = [tableView dequeueReusableCellWithIdentifier:ShoutText_CELL forIndexPath:indexPath];
            shoutTextCell.leftTitleLable.text = @"甲方";
            shoutTextCell.leftDescLable.text = @"SHE";
            shoutTextCell.rightTitleLable.text = @"电话";
            shoutTextCell.rightDescLable.text = @"12312738912";
            
            [shoutTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return shoutTextCell;
        }
            break;
        case 3:
        {
            BATContractlongTextCell *longTextCell = [tableView dequeueReusableCellWithIdentifier:longText_CELL forIndexPath:indexPath];
            longTextCell.titleLable.text = @"地址";
            longTextCell.descLable.text = @"啊数据克劳福德静安寺来得快甲方来看";
            
            [longTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return longTextCell;
        }
            break;
        case 4:
        {
            BATContractlongTextCell *longTextCell = [tableView dequeueReusableCellWithIdentifier:longText_CELL forIndexPath:indexPath];
            longTextCell.titleLable.text = @"乙方";
            longTextCell.descLable.text = @"金祥龙";
            
            [longTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return longTextCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark -pagesLayout
- (void)pagesLayout{
    self.title = @"合同";
    
    [self.view addSubview:self.contractFooterrView];
    [self.view addSubview:self.contractHeaderView];
    
    WEAK_SELF(self);
    [self.view addSubview:self.contractTableView];
    [self.contractTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(14);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -get&&set
- (UITableView *)contractTableView{
    if (!_contractTableView) {
        _contractTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contractTableView.delegate = self;
        _contractTableView.dataSource = self;
        _contractTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contractTableView.scrollEnabled = NO;
        
        [_contractTableView registerClass:[BATContractShoutTextCell class] forCellReuseIdentifier:ShoutText_CELL];
        [_contractTableView registerClass:[BATContractlongTextCell class] forCellReuseIdentifier:longText_CELL];
        
        _contractTableView.tableFooterView = _contractFooterrView;
        _contractTableView.tableHeaderView = _contractHeaderView;
        
    }
    return _contractTableView;
}

- (BATContractHeaderView *)contractHeaderView{
    if (!_contractHeaderView) {
        _contractHeaderView = [[BATContractHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _contractHeaderView.attachmentLabel.text = @"附件";
        _contractHeaderView.titleLabel.text = @"家庭医生服务合同";
        
    }
    return _contractHeaderView;
}

- (BATContractHeaderView *)contractFooterrView{
    if (!_contractFooterrView) {
        _contractFooterrView = [[BATContractHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _contractFooterrView.titleLabel.hidden = YES;
        _contractFooterrView.attachmentLabel.text = @"备注：服务期间内乙方有义务对甲方做出相应的服务。";
        _contractFooterrView.attachmentLabel.font = [UIFont systemFontOfSize:13];
        _contractFooterrView.attachmentLabel.tintColor = UIColorFromHEX(0x999999, 1);
        
    }
    return _contractFooterrView;
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
        }];
        
    }
    return _defaultView;
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
