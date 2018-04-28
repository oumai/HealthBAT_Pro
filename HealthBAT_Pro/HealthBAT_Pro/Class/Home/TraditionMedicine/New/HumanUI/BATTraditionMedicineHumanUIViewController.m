//
//  BATTraditionMedicineHumanUIViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionMedicineHumanUIViewController.h"
#import "BATTraditionMedicineSymptomCollectionViewCell.h"
#import "BATTraditionMedicineModel.h"
#import "BATHomeTraditionMedicineViewController.h"

#import "BATLoginModel.h"

#import "BATGraditorButton.h"

static  NSString * const SYMPTOM_COLLECTION_CELL = @"BATTraditionMedicineSymptomCollectionViewCell";

@interface BATTraditionMedicineHumanUIViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *humanView;
@property (nonatomic,strong) UIButton *headBtn;
@property (nonatomic,strong) UIButton *topBody;
@property (nonatomic,strong) UIButton *bottomBody;
@property (nonatomic,strong) UIButton *leftArm;
@property (nonatomic,strong) UIButton *rightArm;
@property (nonatomic,strong) UIButton *leftLeg;
@property (nonatomic,strong) UIButton *rightLeg;
@property (nonatomic,strong) UIButton *allBody;
@property (nonatomic,strong) UIButton *tmpBtn;

@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UICollectionView *bottomCollectionView;
@property (nonatomic,copy) NSString *selectedString;

@property (nonatomic,copy) NSArray *headArray;
@property (nonatomic,copy) NSArray *topArray;
@property (nonatomic,copy) NSArray *bottomArray;
@property (nonatomic,copy) NSArray *armArray;
@property (nonatomic,copy) NSArray *legArray;
@property (nonatomic,copy) NSArray *allArray;
@property (nonatomic,copy) NSArray *currentArray;

@property (nonatomic,strong) UILabel *scendLabel;
@property (nonatomic,strong) BATGraditorButton *whereLabel;
@property (nonatomic,strong) BATGraditorButton *pointLable;
@property (nonatomic,strong) BATGraditorButton *detailBtn;
@property (nonatomic,strong) BATGraditorButton *allBodyBtn;
//@property (nonatomic,strong) UIButton *leftBtn;
//@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;
@property (nonatomic,strong) NSIndexPath *oldIndexPath;
@end

@implementation BATTraditionMedicineHumanUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"国医馆";
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    self.headArray = @[@"头痛",@"失眠",@"脱发",@"健忘",@"耳鸣",@"眼干",@"咽炎",@"鼻炎"];
    self.topArray = @[@"心烦",@"胸闷",@"哮喘",@"胃胀",@"胃痛",@"呕吐",@"胁痛",@"厌食",];
    self.bottomArray = @[@"尿频",@"尿痛",@"腹泻",@"腹痛",@"腰痛",@"便秘",@"不孕",@"早泄",];
    self.armArray = @[@"手麻",@"手抖",@"手凉",@"手心热",@"肩颈痛",@"鼠标手",@"关节痛",];
    self.legArray = @[@"筋膜炎",@"关节痛",@"静脉炎",@"脚汗",@"脚臭",@"足心热",@"脚藓",@"水肿",];
    self.allArray = @[@"疲乏",@"发热",@"盗汗",@"自汗",@"畏寒",@"烦躁",@"肥胖",@"消瘦",];

    self.selectedString = @"头部";
    self.currentArray = self.headArray;
    [self partBtnClick:self.headBtn];


    [self layoutPages];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.bottomCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.headArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.currentArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BATTraditionMedicineSymptomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMPTOM_COLLECTION_CELL forIndexPath:indexPath];

    cell.symptomLabel.text = self.currentArray[indexPath.row];
    [cell.symptomBtn setTitle:self.currentArray[indexPath.row] forState:UIControlStateNormal];
   
    if (indexPath == self.currentIndexPath) {
        [cell selectCellWithYesAndNo:YES];
    }else{
        [cell selectCellWithYesAndNo:NO];
    }

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 10, 0, -10);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(80, 80);
    return size;
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    BATTraditionMedicineSymptomCollectionViewCell *cell = (BATTraditionMedicineSymptomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [self createConsultRoomRequestWithDisease:cell.symptomLabel.text];
    
    self.oldIndexPath = self.currentIndexPath;
    self.currentIndexPath = indexPath;
    [self.bottomCollectionView reloadData];
}
//
//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"didUnhighlightItemAtIndexPath");
//    
//    if (self.currentIndexPath == indexPath) {
//        BATTraditionMedicineSymptomCollectionViewCell *cell = (BATTraditionMedicineSymptomCollectionViewCell *)[self.bottomCollectionView cellForItemAtIndexPath:indexPath];
//        cell.symptomLabel.backgroundColor = START_COLOR;
//    }
//    
//    if (self.currentIndexPath != indexPath) {
//        BATTraditionMedicineSymptomCollectionViewCell *cell = (BATTraditionMedicineSymptomCollectionViewCell *)[self.bottomCollectionView cellForItemAtIndexPath:indexPath];
//        cell.symptomLabel.backgroundColor = [UIColor whiteColor];
//    }
//}

#pragma mark - private
- (void)partBtnClick:(UIButton *)sender {

    self.tmpBtn.selected = NO;
    self.tmpBtn = sender;
    self.tmpBtn.selected = YES;
    [self.bottomCollectionView reloadData];

//    self.detailLabel.attributedText = [self createDetailAttributeStr];
    self.detailLabel.text = @"选择症状                 开始问诊";
    [self.detailBtn setTitle:[NSString stringWithFormat:@"%@",self.selectedString] forState:UIControlStateNormal];
}

//- (NSMutableAttributedString *)createDetailAttributeStr {
//
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择症状 %@ 开始问诊",self.selectedString]];
//
//
//    NSDictionary *attributeDict =@{
//                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:30],
//                                   NSForegroundColorAttributeName:BASE_COLOR,
//                                   };
//
//    NSRange range = NSMakeRange(5, 2);
//
//    [attrStr addAttributes:attributeDict range:range];
//    return attrStr;
//    
//}

#pragma mark - net
- (void)createConsultRoomRequestWithDisease:(NSString *)disease {

    [HTTPTool requestWithURLString:@"/api/ChineseMedicine/CreateConsultRoom" parameters:@{@"Token":LOCAL_TOKEN,@"DiseaseName":disease} type:kPOST success:^(id responseObject) {

        BATTraditionMedicineModel *model = [BATTraditionMedicineModel mj_objectWithKeyValues:responseObject];

        BATLoginModel *login = LOGIN_INFO;

        NSString *url = [NSString stringWithFormat:@"%@/app/ChatInterface?accountId=%ld&chanelId=%@&message=1&token=%@",APP_WEB_DOMAIN_URL,(long)login.Data.ID,model.Data.ChannelID,LOCAL_TOKEN];


        BATHomeTraditionMedicineViewController *traditionIM_VC = [[BATHomeTraditionMedicineViewController alloc] init];
        traditionIM_VC.urlStr = url;
        traditionIM_VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:traditionIM_VC animated:YES];

    } failure:^(NSError *error) {

    }];
}

#pragma mark - layout
- (void)layoutPages {

    WEAK_SELF(self);

    [self.view addSubview:self.backScrollView];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    [self.backScrollView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(600);
    }];

    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@20);
    }];
    
    [self.backView addSubview:self.whereLabel];
    [self.whereLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.bottom.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.backView addSubview:self.scendLabel];
    [self.scendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.whereLabel.mas_bottom).offset(10);
    }];
    
    [self.backView addSubview:self.pointLable];
    [self.pointLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@32);
        make.bottom.equalTo(self.scendLabel.mas_bottom).offset(8);
    }];

    [self.backView addSubview:self.humanView];
    [self.humanView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];

    [self.humanView addSubview:self.headBtn];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [self.humanView addSubview:self.topBody];
    [self.topBody mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@70);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.humanView addSubview:self.bottomBody];
    [self.bottomBody mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@130);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.humanView addSubview:self.leftArm];
    [self.leftArm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.top.equalTo(@120);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.humanView addSubview:self.rightArm];
    [self.rightArm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.top.equalTo(@120);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.humanView addSubview:self.leftLeg];
    [self.leftLeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@43);
        make.top.equalTo(@225);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.humanView addSubview:self.rightLeg];
    [self.rightLeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-43);
        make.top.equalTo(@225);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];

    [self.backView addSubview:self.allBody];
    [self.allBody mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.humanView.mas_right).offset(0);
        make.bottom.equalTo(self.humanView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.backView addSubview:self.allBodyBtn];
    [self.allBodyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.humanView.mas_right).offset(0);
        make.bottom.equalTo(self.humanView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    [self.backView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.humanView.mas_bottom).offset(15);
    }];
    
    [self.backView addSubview:self.detailBtn];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.centerY.equalTo(self.detailLabel.mas_centerY);
    }];

    [self.backView addSubview:self.bottomCollectionView];
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 60));
    }];
    
//    [self.backView addSubview:self.leftBtn];
//    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(5);
//        make.centerY.equalTo(self.bottomCollectionView.mas_centerY);
//        make.width.height.mas_equalTo(30);
//    }];
//    
//    [self.backView addSubview:self.rightBtn];
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-5);
//        make.centerY.equalTo(self.bottomCollectionView.mas_centerY);
//        make.width.height.mas_equalTo(30);
//    }];
}

#pragma mark -
- (UIScrollView *)backScrollView {

    if (!_backScrollView) {

        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _backScrollView;
}
- (UIView *)backView {

    if (!_backView) {

        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 600)];
    }
    return _backView;
}
- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;

//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"今天哪里不舒服？\n请指给我们看。"];
//
//
//        NSDictionary *attributeDict =@{
//                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:30],
//                                       NSForegroundColorAttributeName:BASE_COLOR,
//                                       };
//
//        NSRange rangeOne = NSMakeRange(2, 2);
//        NSRange rangeTwo = NSMakeRange(10, 1);
//
//        [attrStr addAttributes:attributeDict range:rangeOne];
//        [attrStr addAttributes:attributeDict range:rangeTwo];
//        _titleLabel.attributedText = attrStr;
        _titleLabel.text = @"今天               不舒服？";

    }
    return _titleLabel;
}

- (UILabel *)scendLabel {
    
    if (!_scendLabel) {
        _scendLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _scendLabel.numberOfLines = 2;
        _scendLabel.text = @"请        给我们看。";
    }
    return _scendLabel;
}

- (BATGraditorButton *)whereLabel {
    
    if (!_whereLabel) {
        _whereLabel = [[BATGraditorButton alloc] init];
        _whereLabel.backgroundColor = [UIColor clearColor];
        _whereLabel.enbleGraditor = YES;
        [_whereLabel setGradientColors:@[START_COLOR,END_COLOR]];
        _whereLabel.titleLabel.font = [UIFont systemFontOfSize:30];
        [_whereLabel setTitle:@"哪里" forState:UIControlStateNormal];;
    }
    return _whereLabel;
}

- (BATGraditorButton *)pointLable {
    
    if (!_pointLable) {
        _pointLable = [[BATGraditorButton alloc] init];
        [_pointLable setGradientColors:@[START_COLOR,END_COLOR]];
        _pointLable.backgroundColor = [UIColor clearColor];
        _pointLable.enbleGraditor = YES;
        _pointLable.titleLabel.font = [UIFont systemFontOfSize:25];
        [_pointLable setTitle:@"指" forState:UIControlStateNormal];;
        
    }
    return _pointLable;
}

- (UIImageView *)humanView {

    if (!_humanView) {

        _humanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-rt"]];
        _humanView.userInteractionEnabled = YES;
    }
    return _humanView;
}

- (UIButton *)headBtn {

    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_headBtn setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_headBtn sizeToFit];

        WEAK_SELF(self);
        [_headBtn bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"头部";
            self.currentArray = self.headArray;

            [self partBtnClick:self.headBtn];


        }];
    }
    return _headBtn;
}

- (UIButton *)topBody {

    if (!_topBody) {
        _topBody = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBody setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_topBody setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_topBody sizeToFit];

        WEAK_SELF(self);
        [_topBody bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"上身";
            self.currentArray = self.topArray;

            [self partBtnClick:self.topBody];


        }];
    }
    return _topBody;
}

- (UIButton *)bottomBody {

    if (!_bottomBody) {
        _bottomBody = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBody setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_bottomBody setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_bottomBody sizeToFit];

        WEAK_SELF(self);
        [_bottomBody bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"下身";
            self.currentArray = self.bottomArray;

            [self partBtnClick:self.bottomBody];


        }];
    }
    return _bottomBody;
}

- (UIButton *)leftArm {

    if (!_leftArm) {
        _leftArm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftArm setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_leftArm setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_leftArm sizeToFit];

        WEAK_SELF(self);
        [_leftArm bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"上肢";
            self.currentArray = self.armArray;

            [self partBtnClick:self.leftArm];


        }];
    }
    return _leftArm;
}

- (UIButton *)rightArm {

    if (!_rightArm) {
        _rightArm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightArm setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_rightArm setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_rightArm sizeToFit];

        WEAK_SELF(self);
        [_rightArm bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"上肢";
            self.currentArray = self.armArray;

            [self partBtnClick:self.rightArm];


        }];
    }
    return _rightArm;
}

- (UIButton *)leftLeg {

    if (!_leftLeg) {
        _leftLeg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftLeg setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_leftLeg setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_leftLeg sizeToFit];

        WEAK_SELF(self);
        [_leftLeg bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"下肢";
            self.currentArray = self.legArray;

            [self partBtnClick:self.leftLeg];


        }];
    }
    return _leftLeg;
}

- (UIButton *)rightLeg {

    if (!_rightLeg) {
        _rightLeg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightLeg setImage:[UIImage imageNamed:@"ic-l"] forState:UIControlStateNormal];
        [_rightLeg setImage:[UIImage imageNamed:@"ic-lp"] forState:UIControlStateSelected];
        [_rightLeg sizeToFit];

        WEAK_SELF(self);
        [_rightLeg bk_whenTapped:^{

            STRONG_SELF(self);
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.allBodyBtn.hidden = YES;
            self.selectedString = @"下肢";
            self.currentArray = self.legArray;
            [self partBtnClick:self.rightLeg];

        }];
    }
    return _rightLeg;
}

- (UIButton *)allBody {

    if (!_allBody) {
        _allBody = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBody setTitle:@"全身" forState:UIControlStateNormal];

        [_allBody setBackgroundImage:[UIImage imageWithColor:UIColorFromHEX(0xfefefe, 1)] forState:UIControlStateNormal];
        [_allBody setTitleColor:UIColorFromHEX(0x333333, 1) forState:UIControlStateNormal];

        [_allBody setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateSelected];
        [_allBody setTitleColor:UIColorFromHEX(0xfefefe, 1) forState:UIControlStateSelected];

        _allBody.layer.cornerRadius = 30;
        _allBody.clipsToBounds = YES;

        WEAK_SELF(self);
        [_allBody bk_whenTapped:^{

            STRONG_SELF(self);
            self.allBodyBtn.hidden = NO;
            self.selectedString = @"全身";
            self.currentArray = self.allArray;
            [self partBtnClick:self.allBody];
        }];
    }
    return _allBody;
}

- (BATGraditorButton *)allBodyBtn{
    if (!_allBodyBtn) {
        _allBodyBtn = [[BATGraditorButton alloc] init];
        _allBodyBtn.enablehollowOut = YES;
        _allBodyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _allBodyBtn.clipsToBounds= YES;
        _allBodyBtn.layer.cornerRadius = 30;
        [_allBodyBtn setTitle:@"全身" forState:UIControlStateNormal];
        _allBodyBtn.titleColor = [UIColor whiteColor];
        _allBodyBtn.hidden = YES;
        [_allBodyBtn setGradientColors:@[START_COLOR,END_COLOR]];
    }
    return _allBodyBtn;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _detailLabel;
}



- (BATGraditorButton *)detailBtn{
    
    if (!_detailBtn) {
        _detailBtn = [[BATGraditorButton alloc] init];
        [_detailBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _detailBtn.backgroundColor = [UIColor clearColor];
        _detailBtn.enbleGraditor = YES;
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_detailBtn setTitle:@"全身" forState:UIControlStateNormal];;
        
    }
    return _detailBtn;
}

- (UICollectionView *)bottomCollectionView {

    if (!_bottomCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;

        [_bottomCollectionView registerClass:[BATTraditionMedicineSymptomCollectionViewCell class] forCellWithReuseIdentifier:SYMPTOM_COLLECTION_CELL];
    }
    return _bottomCollectionView;
}

/*
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:UIControlStateNormal];
//        _leftBtn.backgroundColor = [UIColor redColor];
        [_leftBtn bk_whenTapped:^{
            DDLogInfo(@"左移动一个");
            
            self.oldIndexPath = self.currentIndexPath;
        
            
            if (self.currentIndexPath.row > 0) {
                self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row - 1 inSection:0];
                
                [self.bottomCollectionView reloadItemsAtIndexPaths:@[self.oldIndexPath,self.currentIndexPath]];
                [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                
            }else{
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            
            DDLogInfo(@"%ld===%ld===%ld===%ld",self.oldIndexPath.section,self.oldIndexPath.row,self.currentIndexPath.section,self.currentIndexPath.row);
            

            
        }];
    }
    
    return  _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
//        _rightBtn.backgroundColor = [UIColor redColor];
        [_rightBtn bk_whenTapped:^{
            DDLogInfo(@"右移动一个");
            
            self.oldIndexPath = self.currentIndexPath;
            if (self.currentIndexPath.row < self.currentArray.count - 1) {
                self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
                
                [self.bottomCollectionView reloadItemsAtIndexPaths:@[self.oldIndexPath,self.currentIndexPath]];
                [self.bottomCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                
            }else{
                self.currentIndexPath = [NSIndexPath indexPathForRow:self.self.currentArray.count - 1 inSection:0];
            }
            
            DDLogInfo(@"%ld===%ld===%ld===%ld",self.oldIndexPath.section,self.oldIndexPath.row,self.currentIndexPath.section,self.currentIndexPath.row);
            
        }];
    }
    
    return  _rightBtn;
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
