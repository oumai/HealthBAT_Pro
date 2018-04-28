//
//  BATHealthCircleTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATBBSCircleTableViewCell.h"

@interface BATBBSCircleTableViewCell () <BATHealthCircleCommentTableViewDelegate
//BATHealthCircleImageCollectionViewDelegate
>

@property (strong, nonatomic) UITapGestureRecognizer *avatarTapGestureRecognizer;

@end

@implementation BATBBSCircleTableViewCell

- (void)dealloc
{
    _commentTableView.delegate = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _commentTableView.delegate = self;
    
    //设置头像圆形
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    
    _avatarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction:)];
    _avatarTapGestureRecognizer.numberOfTapsRequired = 1;
    _avatarTapGestureRecognizer.numberOfTouchesRequired = 1;
    [_avatarImageView addGestureRecognizer:_avatarTapGestureRecognizer];
    
    _nicknameLabel.textColor = UIColorFromHEX(0X0182eb, 1);
    _nicknameLabel.font = [UIFont systemFontOfSize:15];
    
    //设置cell的separator
    [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0];
    
    self.desLB.userInteractionEnabled = YES;
    UITapGestureRecognizer *desTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentButtonAction:)];
    [self.desLB addGestureRecognizer:desTap];

    self.thumbsUpCountLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *thumbsUpCountLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumpUpButtonAction:)];
    [self.thumbsUpCountLabel addGestureRecognizer:thumbsUpCountLabelTap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public
#pragma mark - 配置数据
- (void)configrationCell:(BATMomentData *)model
{

//    if (model.AccountType == 1) {
        //用户
        //头像
        if([model.PhotoPath hasPrefix:@"http://"]) {

            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        }else{

            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DOMAIN_URL,model.PhotoPath]] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
        }
//    }
//    else {
//        //头像
//        if([model.PhotoPath hasPrefix:@"http://"]){
//
//            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath]placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image) {
//                    _avatarImageView.image = [Tools findFace:image];
//                }
//            }];
//
//            //        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
//        }else{
//            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.PhotoPath]] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image) {
//                    _avatarImageView.image = [Tools findFace:image];
//                }
//            }];
//            //        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.PhotoPath]] placeholderImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
//        }
//    }
    
    //1：达人 0：普通
    if (model.IsMaster == 1) {
        
        _markView.hidden = NO;
        
        if(model.AccountType == 1) {
            _markView.image = [UIImage imageNamed:@"icon_level"];
        } else {
            _markView.image = [UIImage imageNamed:@"icon_level_doctor"];
        }
    } else {
        _markView.hidden = YES;
    }
    
    //类型。1 动态 非1 问题
    if (model.PostType == 1) {
        _problemImageView.hidden = NO;
    } else if(model.PostType != 1 ) {
        _problemImageView.hidden = YES;
    }
    
    //昵称
    _nicknameLabel.text = model.UserName;
    
    // 0：男  1：女
    if (model.Sex == 1) {
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_man"];
    } else {
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_girl"];
    }
    
    //个性签名
    if ([model.Signature isEqualToString:@""] || !model.Signature) {
        _motoLabel.text = @"这个家伙很懒，什么都没有留下。";
    } else {
        _motoLabel.text = model.Signature;
    }
    
    //内容
    _contentLabel.text = model.DynamicContent;

    //更新图片view的高度
    [_collectionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.collectionImageViewHeight).priorityLow();
    }];
    
    //加载图片数据
    [_collectionImageView loadImageData:model.imgList];
    
    //定位
    _addressLabel.text = model.Address;
    
    //时间
    _timeLabel.text = [self getTimeStringFromDateString:model.CreatedTime];
    
    _thumbsUpButton.selected = model.MarkHelpful;
    
    //点赞数
    _thumbsUpCountLabel.text = model.MarkHelpfulCount > 0 ? [NSString stringWithFormat:@"%ld", (long)model.MarkHelpfulCount] : @"0";
    _thumbsUpCountLabel.textColor = UIColorFromHEX(0X999999, 1);
    
    _desLB.text = [NSString stringWithFormat:@"%zd",model.Comments.count];
    _desLB.textColor = UIColorFromHEX(0X999999, 1);
    
    //评论小剪头
    if (model.Comments.count <= 0) {
        
        [_trianglePathView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom);
            make.height.mas_equalTo(0);
        }];
        
    } else {
        
        if (model.IsHideCommon) {
            [_trianglePathView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_timeLabel.mas_bottom);
                make.height.mas_equalTo(0);
            }];
        }else {
        
            [_trianglePathView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_timeLabel.mas_bottom).offset(8).priority(1000);
                make.height.mas_equalTo(10);
            }];
        
        }
       
        
        
        [_trianglePathView setNeedsDisplay];
        
    }
    
    if (model.IsHideCommon) {
        [_commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            //更新评论的高度
            make.height.mas_equalTo(0).priorityLow();
        }];
    }else {
        [_commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            //更新评论的高度
            make.height.mas_equalTo(model.commentTableViewHeight).priorityLow();
        }];
    }
//    [_commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        //更新评论的高度
//        make.height.mas_equalTo(model.commentTableViewHeight).priorityLow();
//    }];
    
    //加载评论数据
    [_commentTableView loadCommentsData:model.Comments];

   
    
    [self.contentView layoutIfNeeded];
}

/**
 *  格式化时间
 *
 *  @param dateString 时间
 *
 *  @return 格式后的时间
 */
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
    else if (minusInterval >= 86400 && minusInterval< 1296000) {
        timeString = [NSString stringWithFormat:@"%ld天前", (long)minusInterval / 86400];
    }
    else if (minusInterval >= 1296000 && minusInterval< 2592000) {
        timeString = @"半个月前";
    }
    else if (minusInterval >= 2592000 && minusInterval< 15552000) {
        timeString = [NSString stringWithFormat:@"%ld个月前", (long)minusInterval / 2592000];
    }
    else if (minusInterval >= 15552000 && minusInterval< 31104000) {
        timeString = @"半年前";
    }
    else if (minusInterval >= 31104000) {
        timeString = [NSString stringWithFormat:@"%ld年前", (long)minusInterval / 31104000];
    }
    
    return timeString;
}

#pragma mark - Action

#pragma mark - 头像点击
- (IBAction)avatarAction:(id)sender
{
    if (self.avatarAction) {
        self.avatarAction(_indexPath);
    }
}

#pragma mark - 更多操作点击
- (IBAction)moreButtonAction:(id)sender
{
    if (self.moreAction) {
        self.moreAction(_indexPath);
    }
}

#pragma mark - 评论按钮点击
- (IBAction)commentButtonAction:(id)sender
{
    if (self.commentAction) {
        self.commentAction(_indexPath);
    }
}

- (IBAction)thumpUpButtonAction:(id)sender
{
    if (self.thumbsUpAction) {
        self.thumbsUpAction(_indexPath);
    }
}

#pragma mark - BATHealthCircleCommentTableViewDelegate
- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView clickedUser:(NSIndexPath *)indexPath comments:(BATComments *)comments
{
    if (self.commentTapUserAction) {
        self.commentTapUserAction(indexPath,comments);
    }
}

- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView reply:(NSIndexPath *)indexPath comments:(BATComments *)comments
{
    if (self.commentReplyAction) {
        self.commentReplyAction(indexPath,comments);
    }
}

- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView delete:(NSIndexPath *)indexPath comments:(BATComments *)comments
{
    if (self.longTapCommentAction) {
        self.longTapCommentAction(indexPath,comments);
    }
}

//#pragma mark - BATHealthCircleImageCollectionViewDelegate
//- (void)healthCircleImageCollectionView:(BATHealthCircleImageCollectionView *)healthCircleImageCollectionView imageClicked:(NSInteger)index
//{
//    if (self.collectionImageClickAction) {
//        self.collectionImageClickAction(index);
//    }
//}

@end
