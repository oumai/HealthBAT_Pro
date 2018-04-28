//
//  BATHealthEvaluationView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthEvaluationView.h"
#import "BATAppDelegate.h"
#import "BATHealthEvalutionServce.h"
#import "BATPerson.h"
#import "BATHealthEvalutionModel.h"
#import "BATHomeBouncesView.h"
#import "BATGetUserStatus.h"
#import "BATEatSearchViewController.h"
@interface BATHealthEvaluationView ()

//@property (nonatomic,strong) UIView *contentView;
@property (strong, nonatomic) BATHealthEvalutionModel *EvalutionModel;

@property (nonatomic,strong) BATHomeBouncesView *contentViewNew; //评估

@property (nonatomic, strong) BATGetUserStatus *needStatus;

@end

@implementation BATHealthEvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
        [self dealNotification];
    }
    return self;
}

#pragma mark - pageLayout
- (void)pageLayout {
    [self addSubview:self.bgImageView];
    [self addSubview:self.pgLabel];
    [self addSubview:self.jyLabel];
    [self addSubview:self.topMenuBgView];
    [self addSubview:self.sljkBtn];
    [self addSubview:self.xljkBtn];
    [self addSubview:self.shjkBtn];
    [self addSubview:self.segmentedControl];
    [self addSubview:self.sportsDietView];
    [self addSubview:self.psychologicalSocietyView];
    
    WEAK_SELF(self);
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.pgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.topMenuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX);
        if (iPhone5 || iPhone4) {
            make.top.equalTo(self.pgLabel.mas_bottom).offset(45*scaleValue);
            make.size.mas_offset(CGSizeMake(176 * scaleValue, 172  * scaleValue));
        } else {
            make.top.equalTo(self.pgLabel.mas_bottom).offset(45);
            make.size.mas_offset(CGSizeMake(176, 172));
        }
    }];
    
    [self.sljkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.topMenuBgView.mas_centerX);
        make.bottom.equalTo(self.topMenuBgView.mas_top).offset(10);
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(50*scaleValue, 50*scaleValue));
        } else {
            make.size.mas_offset(CGSizeMake(50, 50));
        }
    }];
    
    [self.xljkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.topMenuBgView.mas_left).offset(-10);
        make.bottom.equalTo(self.topMenuBgView.mas_bottom).offset(7);
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(50*scaleValue, 50*scaleValue));
        } else {
            make.size.mas_offset(CGSizeMake(50, 50));
        }
    }];
    
    [self.shjkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.topMenuBgView.mas_right).offset(10);
        make.bottom.equalTo(self.topMenuBgView.mas_bottom).offset(7);
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(50*scaleValue, 50*scaleValue));
        } else {
            make.size.mas_offset(CGSizeMake(50, 50));
        }
    }];
    
    [self.jyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        if (iPhone5 || iPhone4) {
            make.top.equalTo(self.topMenuBgView.mas_bottom).offset(10*scaleValue);
        } else {
            make.top.equalTo(self.topMenuBgView.mas_bottom).offset(10);
        }
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.jyLabel.mas_bottom).offset(10);
        make.height.mas_offset(40);
    }];
    
    [self.sportsDietView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.bottom.equalTo(self);
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
    [self.psychologicalSocietyView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.sportsDietView.mas_top);
//        make.bottom.equalTo(self);
        make.left.equalTo(self.sportsDietView.mas_right);
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
//    self.scrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 0);
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.window addSubview:self.contentView];
    
    [appDelegate.window addSubview:self.contentViewNew];
    
    
    WEAK_SELF(appDelegate);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        make.left.right.equalTo(appDelegate.window);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [self.contentViewNew mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        make.left.right.equalTo(appDelegate.window);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
//    [self bringSubviewToFront:self.contentView];
    
    [self.segmentedControl setBottomBorderWithColor:[UIColor whiteColor] width:SCREEN_WIDTH height:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"DINDING_PHONE_SUCCESS" object:nil];
    [self loadViewData];
}
- (void)dealloc {
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - Action
- (void)sljkBtnAction
{
    
//    self.contentView.titleLabel.text = @"生理健康";
//    self.contentView.contentLabel.attributedText = [self formatContent:@"生理健康，即一般意义的身体健康， 是指身体各器官和系统都能够正常运作，身体没有疾病， 具有良好的健康行为和习惯。在完整的健康含义中，生理健康只是一个方面。它是心理健康和社会健康的基础，反过来也受到心理健康和社会健康的影响。"];
//
//    [self showContentView:YES];
    
    
    self.contentViewNew.textStr = @"测试";
    self.contentViewNew.status = SLstatus;
    self.contentViewNew.model = self.EvalutionModel;
    [self showNewContentView:YES];
    
  
    
}

- (void)xljkBtnAction
{
//    self.contentView.titleLabel.text = @"心理健康";
//    self.contentView.contentLabel.attributedText = [self formatContent:@"心理健康不仅仅指的是没有精神疾病。现代医学研究表明，心理健康与生理健康密切相关，焦虑、抑郁和充满压力的情绪，会减弱人体对疾病的抵抗力，也会直接引发头痛、肠胃不适等生理疾病。中国传统医学也把心理健康放到了相当重要的位置，比如“怒伤肝，忧思伤脾”。"];
//
//    [self showContentView:YES];
    
   
    self.contentViewNew.textStr = @"测试";
    self.contentViewNew.status = XLstatus;
    self.contentViewNew.model = self.EvalutionModel;
    [self showNewContentView:YES];

    
    
}

- (void)shjkBtnAction
{
//    self.contentView.titleLabel.text = @"社会健康";
//    self.contentView.contentLabel.attributedText = [self formatContent:@"社会健康与人的身心健康紧密相关，它关注的是个体能够良好地适应他人及社会环境，具有良好的人际关系和实现社会角色的能力，并能主动获得社会资源和社会支持。"];
//    [self showContentView:YES];
    
    self.contentViewNew.textStr = @"测试";
    self.contentViewNew.status = SHstatus;
    self.contentViewNew.model = self.EvalutionModel;
    [self showNewContentView:YES];
}

- (NSMutableAttributedString *)formatContent:(NSString *)text
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1)} range:NSMakeRange(0, string.length)];
    
    return string;
}

- (void)showContentView:(BOOL)isShow
{
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    WEAK_SELF(appDelegate);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        if (isShow) {
            make.top.equalTo(appDelegate.window.mas_top);
        } else {
            make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        }
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        [appDelegate.window setNeedsLayout];
        [appDelegate.window layoutIfNeeded];
    }];
}
- (void)showNewContentView:(BOOL)isShow {
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    WEAK_SELF(appDelegate);
    [self.contentViewNew mas_updateConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        if (isShow) {
            make.top.equalTo(appDelegate.window.mas_top);
        } else {
            make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        }
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        [appDelegate.window setNeedsLayout];
        [appDelegate.window layoutIfNeeded];
    }];
    
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    
    WEAK_SELF(self);
    [self.sportsDietView mas_updateConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            make.left.equalTo(self.mas_left).offset(0);
        } else {
            make.left.equalTo(self.mas_left).offset(-SCREEN_WIDTH);
        }
        
    }];
    
 
//    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//
//    } completion:nil];
    
}

#pragma mark - get & set
- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        iPhoneX ?  _bgImageView.lee_theme.LeeConfigImage(RoundGuide_bottom_x) : _bgImageView.lee_theme.LeeConfigImage(RoundGuide_bottom);
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)pgLabel
{
    if (_pgLabel == nil) {
        _pgLabel = [[UILabel alloc] init];
        
      
        _pgLabel.textColor = UIColorFromHEX([self returnTitleColor], 1);
        if (iPhone5 || iPhone4) {
            _pgLabel.font = [UIFont systemFontOfSize:17 * scaleValue];
        } else {
            _pgLabel.font = [UIFont systemFontOfSize:17];
        }
        _pgLabel.text = @"健康评估";
        [_pgLabel sizeToFit];
    }
    return _pgLabel;
}

- (UILabel *)jyLabel
{
    if (_jyLabel == nil) {
        _jyLabel = [[UILabel alloc] init];
        
        //关于颜色

        _jyLabel.textColor = UIColorFromHEX([self returnTitleColor], 1);
        if (iPhone5 || iPhone4) {
            _jyLabel.font = [UIFont systemFontOfSize:17 * scaleValue];
        } else {
            _jyLabel.font = [UIFont systemFontOfSize:17];
        }
        _jyLabel.text = @"健康建议";
        [_jyLabel sizeToFit];
    }
    return _jyLabel;
}

- (UIImageView *)topMenuBgView {
    if (_topMenuBgView == nil) {
        _topMenuBgView = [[UIImageView alloc] init];
        _topMenuBgView.lee_theme.LeeConfigImage(RoundGuide_icon_jkpg);
        _topMenuBgView.userInteractionEnabled = YES;
    }
    return _topMenuBgView;
}

- (UIButton *)sljkBtn {
    if (_sljkBtn == nil) {
        _sljkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sljkBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xffffff, 0.6)] forState:UIControlStateNormal];
        [_sljkBtn setTitleColor:UIColorFromHEX(0x14719a, 1) forState:UIControlStateNormal];
        [_sljkBtn addTarget:self action:@selector(sljkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _sljkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sljkBtn.titleLabel.numberOfLines = 0;
        _sljkBtn.alpha = 1.0f;
        _sljkBtn.layer.masksToBounds = YES;
        [self configButton:_sljkBtn text:@"生理\n健康"];
    }
    return _sljkBtn;
}

- (UIButton *)xljkBtn {
    if (_xljkBtn == nil) {
        _xljkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xljkBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xffffff, 0.6)] forState:UIControlStateNormal];
        [_xljkBtn addTarget:self action:@selector(xljkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _xljkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _xljkBtn.titleLabel.numberOfLines = 0;
        _xljkBtn.alpha = 1;
        _xljkBtn.layer.masksToBounds = YES;
        [self configButton:_xljkBtn text:@"心理\n健康"];
    }
    return _xljkBtn;
}

- (UIButton *)shjkBtn {
    if (_shjkBtn == nil) {
        _shjkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shjkBtn setTitle:@"社会\n健康" forState:UIControlStateNormal];
        [_shjkBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xffffff, 0.6)] forState:UIControlStateNormal];
        [_shjkBtn setTitleColor:UIColorFromHEX(0x14719a, 1) forState:UIControlStateNormal];
        [_shjkBtn addTarget:self action:@selector(shjkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _shjkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _shjkBtn.titleLabel.numberOfLines = 0;
        _shjkBtn.alpha = 1;
        _shjkBtn.layer.masksToBounds = YES;
        [self configButton:_shjkBtn text:@"社会\n健康"];
    }
    return _shjkBtn;
}

- (void)configButton:(UIButton *)button text:(NSString *)text {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range = [text rangeOfString:@"\n"];
    if (iPhone5 || iPhone4) {
        button.layer.cornerRadius = (50 * scaleValue) / 2;
        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 *scaleValue],NSForegroundColorAttributeName:UIColorFromHEX([self returnButtonColor], 1)} range:NSMakeRange(0, range.location)];
        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 *scaleValue],NSForegroundColorAttributeName:UIColorFromHEX([self returnButtonColor], 1)} range:NSMakeRange(range.location, text.length - range.location)];
    } else {
        button.layer.cornerRadius = 50 / 2;
        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromHEX([self returnButtonColor], 1)} range:NSMakeRange(0, range.location)];
        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromHEX([self returnButtonColor], 1)} range:NSMakeRange(range.location, text.length - range.location)];
    }
    [button setAttributedTitle:string forState:UIControlStateNormal];
    
}

- (HMSegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        //设置图片(普通)
        NSArray<UIImage *> *images = @[[UIImage imageNamed:@"wz_n_ydys"],
                                       [UIImage imageNamed:@"wz_n_xlsh"]];
        NSArray<UIImage *> *selectedImages = [self getCurrentThemeImageWith:@[@"wz_n_ydys",
                                                                              @"wz_n_xlsh"]];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        //设置底部下划线的高度
        _segmentedControl.selectionIndicatorHeight = 2;
        //设置底部下划线的颜色
        // 黄帆一样哦
        
        _segmentedControl.selectionIndicatorColor = UIColorFromHEX([self returnNowColorOfItem], 1);
        
        
        //设置底下的线和文字一样大
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //添加点击事件
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (BATSportsDietView *)sportsDietView {
    if (_sportsDietView == nil) {
        _sportsDietView = [[BATSportsDietView alloc] init];
        _sportsDietView.backgroundColor = [UIColor clearColor];
    }
    return _sportsDietView;
}

- (BATPsychologicalSocietyView *)psychologicalSocietyView {
    if (_psychologicalSocietyView == nil) {
        _psychologicalSocietyView = [[BATPsychologicalSocietyView alloc] init];
        _psychologicalSocietyView.backgroundColor = [UIColor clearColor];
    }
    return _psychologicalSocietyView;
}

- (BATHealthEvaluationContentView *)contentView {
    if (_contentView == nil) {
        _contentView = [[BATHealthEvaluationContentView alloc] init];
        
        WEAK_SELF(self);
        _contentView.closeContentBlock = ^{
            STRONG_SELF(self);
            [self showContentView:NO];
        };
    }
    return _contentView;
}

- (BATHomeBouncesView *)contentViewNew {
    if (!_contentViewNew) {
        BATHomeBouncesView *view = [[BATHomeBouncesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        WEAK_SELF(self);
        view.closeContentBlock = ^{
            STRONG_SELF(self);
            [self showNewContentView:NO];
        };
        _contentViewNew = view;
    }
    return _contentViewNew;
    
}
- (BATGetUserStatus *)needStatus {
    if (!_needStatus) {
        
        _needStatus = [[BATGetUserStatus alloc] init];
    }
    return _needStatus;
    
}
#pragma mark - 界面数据加载
- (void)dealNotification {
    //正常退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewData) name:@"LOGINOUT" object:nil];
    //被挤掉退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewData) name:BATuserOnForceOfflineNotification object:nil];
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewData) name:BATLoginSuccessGetUserInfoSucessNotification object:nil];
}

- (void)loadViewData {
    /**********************此时加载数据*/
    BATPerson *personModel = PERSON_INFO;
    //判断用户是否登录
    if (personModel.Data.PhoneNumber) {
        NSDictionary *dic = @{@"Phone":personModel.Data.PhoneNumber};
        //        NSDictionary *dic = @{@"Phone":@"18681377992"};
        BATHealthEvalutionServce *servce = [[BATHealthEvalutionServce alloc] init];
        [servce getHealthEvalutionInfoWithParamters:dic success:^(BATHealthEvalutionModel *respose) {
            self.EvalutionModel = respose;
            //给界面赋值
            self.sportsDietView.model = self.EvalutionModel;
            self.psychologicalSocietyView.model = self.EvalutionModel;
            [self upateOurBtn];
        } failure:^(NSError *error) {
            
        }];
    }
    [self updateSegmentedStatus];
}

- (void)loginSuccess {
    [self loadViewData];
}

//给我们的btn赋值
- (void)upateOurBtn {
    NSString *sheHui = [NSString stringWithFormat:@"%ld分",(long)self.EvalutionModel.ReturnData.SocialResult.Score];
    NSString *shengLi = [NSString stringWithFormat:@"%ld分",(long)self.EvalutionModel.ReturnData.PersonDeseaseCategory.PhysiologicalHealth];
    NSString *xinLi = [NSString stringWithFormat:@"%ld分",(long)self.EvalutionModel.ReturnData.PsychologyResult.Score];
    
    if ([sheHui isEqualToString:@"0分"]) {
        sheHui = @"健康";
    }
    if ([shengLi isEqualToString:@"0分"]) {
        shengLi = @"健康";
    }
    if ([xinLi isEqualToString:@"0分"]) {
        xinLi = @"健康";
    }
    
    [self configButton:_shjkBtn text:[NSString stringWithFormat:@"社会\n%@",sheHui]];
    [self configButton:_xljkBtn text:[NSString stringWithFormat:@"心理\n%@",xinLi]];
    [self configButton:_sljkBtn text:[NSString stringWithFormat:@"生理\n%@",shengLi]];

    
}

- (NSArray<UIImage *> *)getCurrentThemeImageWith:(NSArray<NSString *> *)imageName {
    BATHomeThemeType homeThemeType = [[BATHomeThemeManager shareInstance] getCurrentThemeType];
    switch (homeThemeType) {
        case BATHomeThemeTypeDefault: {
            return [self getSelectedImageWith:imageName replaceStr:@"_q"];
        }
        case BATHomeThemeTypeMaleBlue: {
            return [self getSelectedImageWith:imageName replaceStr:@"_b"];
        }
        case BATHomeThemeTypeFemalePink: {
            return [self getSelectedImageWith:imageName replaceStr:@"_p"];
        }
        case BATHomeThemeTypeFemaleCyan: {
            return [self getSelectedImageWith:imageName replaceStr:@"_c"];
        }
        default: {
            return [self getSelectedImageWith:imageName replaceStr:@"_q"];
        }
    }
}

- (NSArray<UIImage *> *)getSelectedImageWith:(NSArray<NSString *> *)imageNameArr replaceStr:(NSString *)replaceStr {
    NSMutableArray *selImageNameArr = [[NSMutableArray alloc] init];
    for (NSString *name in imageNameArr) {
        NSString *imageName = [NSString stringWithFormat:@"%@%@",name,replaceStr];
        UIImage *selImage = [UIImage imageNamed:imageName];
        [selImageNameArr addObject:selImage];
    }
    return selImageNameArr;
}

- (void)updateSegmentedStatus {
    NSArray<UIImage *> *selectedImages = [self getCurrentThemeImageWith:@[@"wz_n_ydys",
                                                                          @"wz_n_xlsh"]];
    self.segmentedControl.sectionSelectedImages = selectedImages;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlChangedValue:_segmentedControl];
    _sportsDietView.helpStrig  = @"1";
    _pgLabel.textColor = UIColorFromHEX([self returnTitleColor], 1);
    _jyLabel.textColor = UIColorFromHEX([self returnTitleColor], 1);
    _segmentedControl.selectionIndicatorColor = UIColorFromHEX([self returnNowColorOfItem], 1);
    self.psychologicalSocietyView.helpStrig = @"1";
}

- (int)returnNowColorOfItem {//这个是和下划线保持一致的采用这个方法

    //关于颜色
    int colorX = 0x509AB7; //--- > 默认颜色
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; //--- > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; //--- > 默认颜色
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xF6595C; //--- > 粉色

    } else { //蓝色
        colorX = 0x2DF9E0; //--- > 深蓝

    }
    return colorX;

}
- (int)returnWeekColor {  //关于Week颜色
   
    int colorX = 0x509AB7; // - > 默认浅蓝
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; // - > 默认浅蓝
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xFFFFFF; // - > 白色
        
    } else { //蓝色
        colorX = 0xFFFFFF; // - > 白色
        
    }
    return colorX;
    
}
- (int)returnTitleColor { // 标题颜色
    int colorX = 0x000000; // - > 黑色
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x000000; // - > 黑色
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xF6595C; // - > 粉色
    } else { //蓝色
        colorX = 0xffffff; // - > 白色
    }
    return colorX;
    
}
- (int)returnButtonColor { //按钮颜色
    
    int colorX = 0x509AB7; // - > 默认浅蓝
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; // - > 默认浅蓝
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xF6595C; // - > 粉色
    } else { //蓝色
        colorX = 0xFFFFFF; // - > 就是蓝色？白色
    }
    return colorX;
    
}
- (int)returnSmallItemColor { //牛奶这些
    
    int colorX = 0x509AB7; // - > 默认浅蓝
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; // - > 默认浅蓝
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xFFFFFF; // - > 白色
        
    } else { //蓝色
        colorX = 0xFFFFFF; // - > 白色
        
    }
    return colorX;
    
    
}
@end
