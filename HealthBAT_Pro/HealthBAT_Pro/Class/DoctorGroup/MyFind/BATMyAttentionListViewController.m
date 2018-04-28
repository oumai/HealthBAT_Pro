//
//  BATMyAttentionListViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/9/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyAttentionListViewController.h"

#import "BATAttendListCell.h"
#import "BATFindHotCell.h"

#import "BATTopicListModel.h"

#import "EqualSpaceFlowLayoutEvolve.h"

@interface BATMyAttentionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *listArr;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray *selectArr;

@property (nonatomic,strong) UITableView *topicTab;

@end

@implementation BATMyAttentionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
    
    [self TopiceRequest];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATAttendListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATAttendListCell" forIndexPath:indexPath];
    
    if (self.listArr.count > 0) {
        
        HotTopicListData *data = self.listArr[indexPath.row];
        
        [cell.keyLabel setTitle:data.Topic forState:UIControlStateNormal];
        
        if (data.isSelect) {
            [cell.keyLabel setGradientColors:@[START_COLOR,END_COLOR]];
            cell.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img-qryy"]].CGColor;
        }else {
            [cell.keyLabel setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
            cell.layer.borderColor = BASE_LINECOLOR.CGColor;
        }
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotTopicListData *data = self.listArr[indexPath.row];
    data.isSelect = !data.isSelect;
    [self.collectionView reloadData];
}

////上下间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//
////行间距 每个section items 左右行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    return 20;
//}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArr.count > 0) {
        HotTopicListData *data = self.listArr[indexPath.row];
        
        CGSize textSize = [data.Topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return CGSizeMake(textSize.width+20, 30);
    }
    return CGSizeZero;
}

#pragma mark - 获取列表
#pragma mark - NET
-(void)TopiceRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"CategoryID"];
    [dict setObject:@(self.currentPage) forKey:@"pageIndex"];
    [dict setObject:@"30" forKey:@"pageSize"];
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetTopicList" parameters:dict type:kGET success:^(id responseObject) {
        
        self.collectionView.mj_footer.hidden = NO;
        
        BATHotTopicListModel *tempModel = [BATHotTopicListModel mj_objectWithKeyValues:responseObject];
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (tempModel.ResultCode == 0) {
            if (self.currentPage == 0) {
                self.listArr = [NSMutableArray array];
            }
            
            [self.listArr addObjectsFromArray:tempModel.Data];
            
            if (self.listArr.count == tempModel.RecordsCount) {
                self.collectionView.mj_footer.hidden = YES;
            }
            [self.collectionView reloadData];
            

        }

        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)postTopicRequestWithJson:(NSString *)jsonString {
    NSDictionary *dict = @{@"Data":jsonString};
    [HTTPTool requestWithURLString:@"/api/dynamic/BatchFocus" parameters:dict type:kPOST success:^(id responseObject) {
        
        if (self.successBlock) {
            self.successBlock();
        }
        [self showText:@"关注成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }];

    
}


#pragma makr - Layout
- (void)pageLayout
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.listArr = [NSMutableArray array];
    self.selectArr = [NSMutableArray array];
    
    WEAK_SELF(self);
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [self.view addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"icon-gbb"] forState:UIControlStateNormal];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [closeBtn bk_whenTapped:^{
        STRONG_SELF(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    
    UILabel *titleLB = [[UILabel alloc]init];
    [self.view addSubview:titleLB];
    titleLB.text = @"选择喜欢的话题";
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.font = [UIFont systemFontOfSize:20];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(closeBtn.mas_bottom).offset(10);
        make.right.left.equalTo(self.view).offset(0);
    }];

    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(titleLB.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-90);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"意见反馈提交按钮_color"] forState:UIControlStateNormal];
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        NSMutableArray *dictArr = [NSMutableArray array];
        for (HotTopicListData *data in self.listArr) {
            if (data.isSelect) {
                NSDictionary *dict = @{@"RelationID":data.ID};
                [dictArr addObject:dict];
            }
        }
        if (dictArr.count !=0) {
//            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictArr options:0 error:nil];
//            NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",myString);
//            [self postTopicRequestWithJson:myString];
            
//            NSDictionary *tmpDic = @{@"Data":dictArr};
            [self postTopicRequestWithJson:[Tools dataTojsonString:dictArr]];

           
        }else {
        
            [self showText:@"请选择一个话题"];
            
        }
       
    }];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
        
    }];
}


#pragma mark - get&set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        EqualSpaceFlowLayoutEvolve * flowLayout = [[EqualSpaceFlowLayoutEvolve alloc]initWthType:AlignWithCenter];
        //flowLayout.betweenOfCell = 15;
       // flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerClass:[BATAttendListCell class] forCellWithReuseIdentifier:@"BATAttendListCell"];
        
        WEAK_SELF(self);
        _collectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self TopiceRequest];
        }];
        
        _collectionView.mj_footer.hidden = YES;
    }
    return _collectionView;
}

@end
