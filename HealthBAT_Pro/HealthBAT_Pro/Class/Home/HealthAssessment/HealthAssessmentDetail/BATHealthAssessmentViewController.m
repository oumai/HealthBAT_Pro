//
//  HealthAssessmentViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthAssessmentViewController.h"

#import "BATShareCommentCollectionViewCell.h"
#import "BATHeaderViewCollectionViewCell.h"

#import "BATHealthAssessmentMoreViewController.h"
#import "UINavigationController+ShouldPopOnBackButton.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "BATJSObject.h"
#import "BATPerson.h"

@interface BATHealthAssessmentViewController ()<UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *context;

//分享控件
@property (nonatomic,strong) UIView *bigMaskBGView;
@property (nonatomic,strong) UIView *clearMaskView;
@property (nonatomic,strong) UICollectionView *tvCollectionView;
@property (nonatomic,strong) NSArray *shareIconArray;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *shareTitle;

//时候开始做题
@property (nonatomic,assign) BOOL isBeginTest;
@property (nonatomic,strong) NSString *currentURL;

//专门用于55到中医体侧
@property (nonatomic,strong) NSDictionary   *jsonDict;
@property (nonatomic,strong) BATPerson      *personModel;

@property (nonatomic,strong) BATDefaultView *defaultView;
@end

@implementation BATHealthAssessmentViewController

- (void)dealloc {

    self.bigMaskBGView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutPages];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    self.title = @"健康评测";
    
    self.shareIconArray = @[
                            @{@"icon":@"icon-weixin",@"name":@"微信"},
                            @{@"icon":@"icon-pyquan",@"name":@"朋友圈"},
                            @{@"icon":@"icon-qq",@"name":@"QQ"},
                            @{@"icon":@"icon-qqzone",@"name":@"QQ空间"},
                            @{@"icon":@"icon-weibo",@"name":@"微博"},];
    
    if(LOGIN_STATION){
        [self personInfoListRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"健康评测"];
    
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:[NSString stringWithFormat:@"首页-健康评测-%@",self.title] moduleId:1 beginTime:self.beginTime];
}

- (BOOL)navigationShouldPopOnBackButton {

    if ([[self.currentURL lowercaseString] containsString:@"newsdetail"]) {

        [self.webView goBack];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    static BOOL isRequestWeb = YES;
    
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response.statusCode == 404) {
            // code for 404
            [self.defaultView showDefaultView];
        } else if (response.statusCode == 403) {
            [self.defaultView showDefaultView];
        }
    }

    
    
    self.currentURL = request.URL.absoluteString;

    if ([[request.URL.absoluteString lowercaseString] containsString:@"templateindex"]) {
        self.isBeginTest = NO;
    }

    if ([[request.URL.absoluteString lowercaseString] containsString:@"templatelist"]) {

        //去更多测评
        if (self.isFromMore) {
            //从更多测评进来的
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            BATHealthAssessmentMoreViewController *healthAssessmentMoreVC = [[BATHealthAssessmentMoreViewController alloc] init];
            healthAssessmentMoreVC.url = request.URL;
            [self.navigationController pushViewController:healthAssessmentMoreVC animated:YES];
        }

        return NO;
    }


    if ([[request.URL.absoluteString lowercaseString] containsString:@"templatetest"]) {

        //开始做题目，分享链接改变
        self.isBeginTest = YES;

    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    self.shareTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    WEAK_SELF(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"home-share-icon"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        
        DDLogDebug(@"分享被点击了");
        self.bigMaskBGView.hidden = NO;
        
        JSValue *value = [self.context[@"getZYCPResult"] callWithArguments:nil];
        
        DDLogDebug(@"-----------%@",value);
        
        
        
        
        self.jsonDict = [NSJSONSerialization JSONObjectWithData:[[value toString] dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
        
        
    }];


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //失败直接返回吧
    [self.defaultView showDefaultView];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    }else{
        return self.shareIconArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        
        BATHeaderViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.titleLabel.text = @"分享到";
            cell.backgroundColor = [UIColor clearColor];
        }else{
            cell.titleLabel.text = @"取消";
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else{
        BATShareCommentCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
        NSDictionary * dic = self.shareIconArray[indexPath.row];
        cell.nameLabel.text = dic[@"name"];
        cell.iconImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"icon"]]];
        return cell;
    }
    
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.25;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.25;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        CGSize size = CGSizeMake(SCREEN_WIDTH, 50);
        return size;
    }else{
        CGSize size = CGSizeMake((SCREEN_WIDTH-20-0.75)/4.0, (SCREEN_WIDTH-20-0.75)/4.0 + 35);
        return size;
    }
    
}

//设置section的偏移量
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return UIEdgeInsetsMake(0,0,0,0);
    }else{
        return UIEdgeInsetsMake(0,10,0,10);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *shareTitle;
    NSString *shareText;
    NSString *shareURL;
    UIImage *shareImage;
    
    if(LOGIN_STATION){
        
        if(self.jsonDict == nil || [[self.jsonDict objectForKey:@"id"] intValue] == 0){
            
            //不做操作
            shareImage = [UIImage imageNamed:@"Icon-Share"];
            shareText = [NSString stringWithFormat:@"%@",self.shareTitle ];
            shareTitle = [NSString stringWithFormat:@"%@",self.shareTitle];
            if (self.isBeginTest) {
                shareURL = [NSString stringWithFormat:@"%@/App/TemplateShare/%ld?%@",APP_WEB_DOMAIN_URL,(long)self.assessmentID,[self.currentURL componentsSeparatedByString:@"?"].lastObject];
            }
            else {
                shareURL = [NSString stringWithFormat:@"%@&%@",self.url,@"share=1"];
            }
            
        }else{
            //根据结果返回不一样的分享界面
            switch ([[self.jsonDict objectForKey:@"id"] intValue]) {
                case kBATPhysicalType_YangXuZhi:
                    //阳虚质
                    shareImage = [UIImage imageNamed:@"阳虚体质"];
                    shareText = [NSString stringWithFormat:@"听说%@火力不足啊，还怕冷，这是典型的阳虚症状，嘘！千万不要告诉别人…",self.personModel.Data.UserName];
                    shareTitle = [NSString stringWithFormat:@"%@属于阳虚体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_YinXuZhi:
                    //阴虚质
                    shareImage = [UIImage imageNamed:@"阴虚体质"];
                    shareText = [NSString stringWithFormat:@"小科普：精血和津液都属阴，缺失之后，故称阴虚，%@最近可能劳损久病后而致阴虚…",self.personModel.Data.UserName];
                    shareTitle = [NSString stringWithFormat:@"%@属于阴虚体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_QiXuZhi:
                    //气虚质
                    shareImage = [UIImage imageNamed:@"气虚体质"];
                    shareText = [NSString stringWithFormat:@"%@没精打采，这是气虚的症状，什么是“气”，“气”为何会虚？小编来告诉你…",self.personModel.Data.UserName];
                    shareTitle = [NSString stringWithFormat:@"%@属于气虚体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_TanShiZhi:
                    //痰湿质
                    shareImage = [UIImage imageNamed:@"痰湿体质"];
                    shareText = @"痰湿体质的人千万不要轻易进补，不然会，补到扑街…清谈饮食、加强锻炼才是灵丹妙药";
                    shareTitle = [NSString stringWithFormat:@"%@属于痰湿体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_ShiReZhi:
                    //湿热质
                    shareImage = [UIImage imageNamed:@"湿热体质"];
                    shareText = @"人家青春，你涨痘。捂脸哭/(ㄒoㄒ)/~~脸鼻总是油光锃亮，痘痘总是逗你不断…";
                    shareTitle = [NSString stringWithFormat:@"%@属于湿热体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_QiYuZhi:
                    //气郁质
                    shareImage = [UIImage imageNamed:@"气郁体质"];
                    shareText = [NSString stringWithFormat:@"来来，%@请你干了这碗鸡汤，不再林妹妹！神马多愁善感，神马脆弱忧伤，统统走开！",self.personModel.Data.UserName];
                    shareTitle = [NSString stringWithFormat:@"%@属于气郁体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_XueYuZhi:
                    //血瘀质
                    shareImage = [UIImage imageNamed:@"血瘀体质"];
                    shareText = @"淤青、长斑、痛经都是血瘀体质的特征，天天开心就能活血化瘀,生气是血瘀体质的大忌";
                    shareTitle = [NSString stringWithFormat:@"%@属于血瘀体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_TeBingZhi:
                    //特禀质
                    shareImage = [UIImage imageNamed:@"特禀体质"];
                    shareText = @"身体经常出现过敏反应，对有些食物、药物，花粉以及一些异味反应特强";
                    shareTitle = [NSString stringWithFormat:@"%@属于特禀体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_PingHeZhi:
                    //平和质
                    shareImage = [UIImage imageNamed:@"平和体质"];
                    shareText = @"阴阳气血调和，体态适中、面色红润、精力充沛是主要特征";
                    shareTitle = [NSString stringWithFormat:@"%@属于（健康）平和体质",self.personModel.Data.UserName];
                    break;
                case kBATPhysicalType_PingHeJianQiTa:
                    //平和质和其他
                    shareImage = [UIImage imageNamed:@"平和体质"];
                    shareText = @"阴阳气血调和，体态适中、面色红润、精力充沛是主要特征";
                    shareTitle = [NSString stringWithFormat:@"%@属于（健康）平和质或其他",self.personModel.Data.UserName];
                    break;
                default:
                    break;
            }
        }
    }else{
        
        shareImage = [UIImage imageNamed:@"Icon-Share"];
        shareText = [NSString stringWithFormat:@"%@",self.shareTitle ];
        shareTitle = [NSString stringWithFormat:@"%@",self.shareTitle];
        
    }
    if (self.isBeginTest) {
        shareURL = [NSString stringWithFormat:@"%@/App/TemplateShare/%ld?%@",APP_WEB_DOMAIN_URL,(long)self.assessmentID,[self.currentURL componentsSeparatedByString:@"?"].lastObject];
    }
    else {
        shareURL = [NSString stringWithFormat:@"%@&%@",self.url,@"share=1"];
    }

    DDLogDebug(@"shareURL === %@",shareURL);
    
    //先构造分享参数：
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title = shareTitle;
    msg.desc = shareText;
    msg.image = shareImage;
    msg.link = shareURL;
    msg.multimediaType = OSMultimediaTypeNews;

    if (indexPath.section == 0) {
        // 点击分享到
    }else{
        //点击取消和按钮上
        self.bigMaskBGView.hidden = YES;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //微信分享
                
                [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];

                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];

                }];
            }else if(indexPath.row == 1){
                //朋友圈分享
                [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];

                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];

                }];
            }else if(indexPath.row == 2){
                //QQ分享
                [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];

                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];

                }];
            }else if(indexPath.row == 3){
                //QQ空间分享
                [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                    [self showSuccessWithText:@"分享成功"];

                } Fail:^(OSMessage *message, NSError *error) {
                    [self showErrorWithText:@"分享失败"];

                }];

            }else if(indexPath.row == 4){
                //微博分享
                [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
                    
                    [self showSuccessWithText:@"分享成功"];
                } Fail:^(OSMessage *message, NSError *error) {
                    
                    [self showErrorWithText:@"分享失败"];
                }];
            }
        }
    }
}
//隐藏分享界面
- (void)hideShareAllView{
    self.bigMaskBGView.hidden = YES;
}


#pragma mark - net
- (void)personInfoListRequest {
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        self.personModel = [BATPerson mj_objectWithKeyValues:responseObject];
        if (self.personModel.ResultCode == 0) {
            
            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:self.personModel toFile:file];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - layout
- (void)layoutPages {
    WEAK_SELF(self);
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigMaskBGView];
    [self.bigMaskBGView addSubview:self.clearMaskView];
    [self.bigMaskBGView addSubview:self.tvCollectionView];
    self.bigMaskBGView.hidden = YES;

    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(@-20);
    }];
}

#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIView *)bigMaskBGView{
    if (!_bigMaskBGView) {
        _bigMaskBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bigMaskBGView.backgroundColor = UIColorFromRGB(0, 0, 0, 0.5);
    }
    return _bigMaskBGView;
}

- (UIView *)clearMaskView{
    if (!_clearMaskView) {
        _clearMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _clearMaskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareAllView)];
        [self.clearMaskView addGestureRecognizer:tap];
        
    }
    return _clearMaskView;
}

- (UICollectionView *)tvCollectionView{
    if (!_tvCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _tvCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - ((SCREEN_WIDTH-20-0.75)/4.0 + 35)*2 - 100, SCREEN_WIDTH, ((SCREEN_WIDTH-20-0.75)/4.0 + 35)*2+0.25+100) collectionViewLayout:layout];
        _tvCollectionView.delegate = self;
        _tvCollectionView.dataSource = self;
        _tvCollectionView.bounces = NO;
        _tvCollectionView.backgroundColor = BASE_LINECOLOR;
        [_tvCollectionView registerClass:[BATShareCommentCollectionViewCell class] forCellWithReuseIdentifier:@"ShareCell"];
        [_tvCollectionView registerClass:[BATHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCell"];
    }
    return _tvCollectionView;
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
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
            if(LOGIN_STATION){
                [self personInfoListRequest];
            }
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
