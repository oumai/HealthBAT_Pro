//
//  BATAudioCell.m
//  RecordTest
//
//  Created by kmcompany on 2017/3/15.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "BATAudioCell.h"
#import "Masonry.h"
#import "TrianglePathView.h"
#import "BATSingleRepeatCell.h"
#import <AVFoundation/AVFoundation.h>
@interface BATAudioCell()<UITableViewDelegate,UITableViewDataSource,BATSingleRepeatCellDelegate>
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIButton *commitBtn;
@property (nonatomic,strong) UIButton *priseBtn;
@property (nonatomic,strong) UILabel *secondLb;
@property (nonatomic,strong) TrianglePathView *trianglePathView;
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation BATAudioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.btnContent];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.secondLb];
        [self.contentView addSubview:self.priseBtn];
        [self.contentView addSubview:self.commitBtn];
        [self.contentView addSubview:self.trianglePathView];
        [self.contentView addSubview:self.commentTableView];

        WEAK_SELF(self);
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.headImage.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).offset(15);
        }];
        
        [self.btnContent mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.headImage.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 35));
        }];


        [self.secondLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.btnContent.mas_right).offset(5);
            make.centerY.equalTo(self.btnContent.mas_centerY);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.btnContent.mas_bottom).offset(15);
        }];
        
        [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.timeLb.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.timeLb.mas_centerY);
            make.right.equalTo(self.priseBtn.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        [self.trianglePathView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.timeLb.mas_centerX);
            make.top.equalTo(self.timeLb.mas_bottom).offset(10).priority(750);
            make.height.mas_offset(10).priority(250);
            make.width.mas_offset(20);
            
        }];
        
        [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.trianglePathView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_greaterThanOrEqualTo(0).priority(250);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];

        
        
    }
    return self;
    
}


- (void)setModel:(TopicReplyData *)model {

    _model = model;
    
    [_priseBtn setTitle:[NSString stringWithFormat:@"%zd",model.StarNum] forState:UIControlStateNormal];
    
    [_commitBtn setTitle:model.ReplyNum forState:UIControlStateNormal];
    
    self.secondLb.text = [NSString stringWithFormat:@"%@''",model.AudioLong];
    
    self.nameLb.text = model.UserName;
    
    self.timeLb.text = [self getTimeStringFromDateString:model.CreatedTime];
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath]];
    
    
    
    if (model.secondReplyList.count > 0) {
        
        WEAK_SELF(self);
        [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.btnContent.mas_bottom).offset(15);
        }];
        
        [self.trianglePathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.timeLb.mas_centerX);
            make.top.equalTo(self.timeLb.mas_bottom).offset(10).priority(750);
            make.height.mas_offset(10).priority(250);
            make.width.mas_offset(20);

        }];
        
        
        [self.commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.trianglePathView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_greaterThanOrEqualTo(model.secondReplyList.count * 45).priority(250);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            
        }];

    }else {

        WEAK_SELF(self);
        [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.btnContent.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priority(250);
        }];
        
        [self.trianglePathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
    }
    
    
    [self.trianglePathView setNeedsDisplay];
    
    if (model.IsSetStar) {
        [self.priseBtn setImage:[UIImage imageNamed:@"点赞-选择"] forState:UIControlStateNormal];
    }else {
       [self.priseBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
    

    /*
    [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.trianglePathView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(model.secondReplyList.count * 45);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priority(250);
        
    }];
     */
    
   
    
    [self.contentView updateConstraints];
    [self.contentView layoutIfNeeded];
    
     [self.commentTableView reloadData];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _model.secondReplyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATSingleRepeatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"789"];
    cell.delegate = self;
    cell.model = _model.secondReplyList[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

- (void)BATSingleRepeatCellPlayerWithURL:(NSString *)URL {

    if ([self.delegate respondsToSelector:@selector(BATAudioCellDelegateWithURL:)]) {
        [self.delegate BATAudioCellDelegateWithURL:URL];
    }
}


//播放录音
- (void)btnContentClick {
    if ([self.delegate respondsToSelector:@selector(BATAudioCellDelegateWithURL:)]) {
        [self.delegate BATAudioCellDelegateWithURL:_model.AudioUrl];
    }
}

//点赞按钮
- (void)priseAction {
    if (self.priseBlock) {
        self.priseBlock(self.paht);
    }
}

//弹出录音界面
- (void)showRecordView {
    if (self.commentBlock) {
        self.commentBlock(self.paht);
    }
}

//头像点击回调
- (void)headImagetapAction {

    if (self.headImageBlock) {
        self.headImageBlock(self.paht);
    }

}

#pragma mark - Lazy Load
- (UIImageView *)headImage {

    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.clipsToBounds = YES;
        _headImage.layer.borderColor = [UIColor clearColor].CGColor;
        _headImage.layer.borderWidth = 1;
        _headImage.layer.cornerRadius = 20;
        _headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImagetapAction)];
        [_headImage addGestureRecognizer:tap];
    }
    return _headImage;
}

- (UILabel *)nameLb {

    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
        _nameLb.font = [UIFont systemFontOfSize:14];
    }
    return _nameLb;
}

- (UILabel *)timeLb {

    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.font = [UIFont systemFontOfSize:13];
        _timeLb.textColor = UIColorFromHEX(0X999999, 1);
    }
    return _timeLb;
}

- (UIButton *)commitBtn {

    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc]init];
        [_commitBtn addTarget:self action:@selector(showRecordView)  forControlEvents:UIControlEventTouchUpInside];
        
        UIEdgeInsets    titleEdgeInsets =UIEdgeInsetsMake(0,
                                                          10/2,
                                                          0,
                                                          -10/2);
        
        UIEdgeInsets    imageEdgeInsets = UIEdgeInsetsMake(0,
                                                           -10/2,
                                                           0,
                                                           10/2);
        [_commitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_commitBtn setImage:[UIImage imageNamed:@"回复"] forState:UIControlStateNormal];
        [_commitBtn setTitleEdgeInsets:titleEdgeInsets];
        [_commitBtn setImageEdgeInsets:imageEdgeInsets];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_commitBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    }
    return _commitBtn;
    
}

- (UIButton *)priseBtn {

    if (!_priseBtn) {
        _priseBtn = [[UIButton alloc]init];
        [_priseBtn addTarget:self action:@selector(priseAction)  forControlEvents:UIControlEventTouchUpInside];

    UIEdgeInsets    titleEdgeInsets =UIEdgeInsetsMake(0,
                                          10/2,
                                          0,
                                          -10/2);
        
    UIEdgeInsets    imageEdgeInsets = UIEdgeInsetsMake(0,
                                           -10/2,
                                           0,
                                           10/2);
        
        
        [_priseBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_priseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_priseBtn setTitleEdgeInsets:titleEdgeInsets];
        [_priseBtn setImageEdgeInsets:imageEdgeInsets];
        _priseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_priseBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    }
    return _priseBtn;
}

- (UUMessageContentButton *)btnContent {

    if (!_btnContent) {
        _btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [_btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        
        _btnContent.clipsToBounds = YES;
        _btnContent.layer.borderWidth = 1;
        _btnContent.layer.cornerRadius = 15;
        _btnContent.layer.borderColor = UIColorFromHEX(0Xcccccc, 1).CGColor;
        [_btnContent setTitle:@"" forState:UIControlStateNormal];

    }
    return _btnContent;
}

- (TrianglePathView *)trianglePathView {

    if (!_trianglePathView) {
        _trianglePathView = [[TrianglePathView alloc]init];
        _trianglePathView.backgroundColor = [UIColor whiteColor];
    }
    return _trianglePathView;
}


- (UILabel *)secondLb {

    if (!_secondLb) {
        _secondLb = [[UILabel alloc]init];
        _secondLb.textColor = UIColorFromHEX(0X333333, 1);
        _secondLb.font = [UIFont systemFontOfSize:15];
    }
    return _secondLb;
}

- (UITableView *)commentTableView {

    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]init];
        [_commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.scrollEnabled = NO;
        [_commentTableView registerClass:[BATSingleRepeatCell class] forCellReuseIdentifier:@"789"];
    }
    return _commentTableView;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

- (NSString *)getTimeStringFromDateString:(NSString *)dateString
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:dateString];
    NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
    
    NSDate *nowDate = [NSDate date];
    NSString *strNow = [formatter stringFromDate:nowDate];
    NSDate *nowingDate = [formatter dateFromString:strNow];
    NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
    
    NSTimeInterval minusInterval = nowInterval - sendInterval;
    
    if (minusInterval < 60) {
        timeString = @"刚刚...";
    }
    else if (minusInterval >= 60 && minusInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
    }
    else if (minusInterval >= 3600 && minusInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
    }
    else if (minusInterval >= 86400 ) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
}


@end
