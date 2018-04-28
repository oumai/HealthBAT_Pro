//
//  MomentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMomentTableViewCell.h"

@implementation BATMomentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];

        [self.contentView addSubview:self.yyLabel];
        [self.yyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).offset(10);
            make.right.equalTo(@-10);
            make.top.equalTo(self.headerImageView.mas_top);
            make.bottom.equalTo(@-10);
        }];

        [self setBottomBorderWithColor:UIColorFromRGB(0, 0, 0, 0.2) width:SCREEN_WIDTH height:0];
    }
    return self;
}



- (void)showContentWithMoment:(BATMomentData *)moment {
    NSMutableAttributedString *text = [NSMutableAttributedString new];

    //名字
    NSMutableAttributedString * name = [[NSMutableAttributedString alloc] initWithString:moment.UserName];
    name.yy_font = [UIFont systemFontOfSize:14];
    name.yy_color = [UIColor blackColor];
    name.yy_minimumLineHeight = 20;
    [name yy_appendString:@" "];
    //性别
    UIImageView * imageView = [[UIImageView alloc] init];
    if (moment.Sex == 0) {
        imageView.image = [UIImage imageNamed:@"icon_sex_man"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"icon_sex_girl"];
    }
    imageView.bounds = CGRectMake(0, 0, 10, 10);
    NSMutableAttributedString *sex = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeBottom attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    [name appendAttributedString:sex];
    [name yy_appendString:@"\n"];
    [text appendAttributedString:name];

    //签名
    NSString * str = moment.Signature.length == 0?@"这个家伙很懒，什么都没有留下。":moment.Signature;
    NSMutableAttributedString * signature = [[NSMutableAttributedString alloc] initWithString:str];
    signature.yy_font = [UIFont systemFontOfSize:12];
    signature.yy_color = [UIColor lightGrayColor];\
    signature.yy_minimumLineHeight = 20;
    [signature yy_appendString:@"\n"];
    [text appendAttributedString:signature];

    //内容
    NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:moment.DynamicContent];
    content.yy_font = [UIFont systemFontOfSize:14];
    content.yy_color = [UIColor blackColor];
    content.yy_minimumLineHeight = 20;
    [content yy_appendString:@"\n"];
    [text appendAttributedString:content];

    // 嵌入 UIImage
    NSMutableAttributedString *attachment = nil;
    for (BATImglist * imgs in moment.imgList) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,imgs.imgs]] placeholderImage:nil];
        imageView.bounds = CGRectMake(0, 0, (SCREEN_WIDTH-95)/3, (SCREEN_WIDTH-95)/3);
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeBottom attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        attachment.yy_minimumLineHeight = (SCREEN_WIDTH-95)/3+4;

        if (([moment.imgList indexOfObject:imgs]+1)%3 == 0 || imgs == moment.imgList.lastObject) {
            [attachment yy_appendString:@"\n"];
        }
        else {
            [attachment yy_appendString:@" "];
        }
        [text appendAttributedString: attachment];
    }

    //地址
    if (moment.Address.length > 0) {
        //UIColorFromRGB(48, 153, 251, 1)
        NSMutableAttributedString * address = [[NSMutableAttributedString alloc] initWithString:moment.Address];
        address.yy_font = [UIFont systemFontOfSize:12];
        address.yy_color = UIColorFromRGB(48, 153, 251, 1);
        address.yy_minimumLineHeight = 15;
        [address yy_appendString:@"\n\n"];
        [text appendAttributedString:address];
    }

    //时间
    NSMutableAttributedString * time = [[NSMutableAttributedString alloc] initWithString:moment.CreatedTime];
    time.yy_font = [UIFont systemFontOfSize:12];
    time.yy_color = [UIColor lightGrayColor];
    time.yy_minimumLineHeight = 15;
    [text appendAttributedString:time];
    [text yy_appendString:@"\n"];

    //评论
    NSMutableAttributedString * comments = [NSMutableAttributedString new];
    for (BATComments * comment in moment.Comments) {
        //名字
        NSMutableAttributedString * commentName = [[NSMutableAttributedString alloc] initWithString:comment.UserName];
        commentName.yy_font = [UIFont systemFontOfSize:12];
        commentName.yy_color = UIColorFromRGB(48, 153, 251, 1);
        [commentName yy_appendString:@":"];
        NSRange hightRange;
        hightRange.location = 0;
        hightRange.length = commentName.length;
        [commentName yy_setTextHighlightRange:hightRange color:nil backgroundColor:[UIColor grayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {


        }];
        //内容
        NSMutableAttributedString * commentContent = [[NSMutableAttributedString alloc] initWithString:comment.CommentContent];
        commentContent.yy_font = [UIFont systemFontOfSize:12];
        commentContent.yy_color = UIColorFromRGB(103, 103, 103, 1);

        //一条评论
        NSMutableAttributedString * oneComment = [NSMutableAttributedString new];
        [oneComment appendAttributedString:commentName];
        [oneComment appendAttributedString:commentContent];
        [oneComment yy_appendString:@"\n"];

        [comments appendAttributedString:oneComment];
    }
    if (comments.length > 0) {
        NSRange commentRange;
        commentRange.location = 0;
        commentRange.length = comments.length;
        [comments yy_setTextBlockBorder:[YYTextBorder borderWithFillColor:UIColorFromRGB(236, 236, 236, 1) cornerRadius:0] range:commentRange];
        [text appendAttributedString:comments];
    }


    self.yyLabel.attributedText = text;
}

#pragma mark -
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 45/2.0f;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}


- (YYLabel *)yyLabel {
    if (!_yyLabel) {
        _yyLabel = [YYLabel new];
//        _yyLabel.backgroundColor = [UIColor grayColor];
        _yyLabel.numberOfLines = 0;
        _yyLabel.textAlignment = NSTextAlignmentLeft;


    }
    return _yyLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
