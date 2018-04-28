//
//  ChooseCityViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATChooseCityViewController.h"

#import "BATHospitalRegisterTool.h"

@interface BATChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView         *cityTableView;
@property (nonatomic,strong) BATCityListModel    *cityList;
@property (nonatomic,strong) NSMutableDictionary *cityDicNameForLetter;

@end

@implementation BATChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
    [self pagesLayout];
    self.cityDicNameForLetter = [NSMutableDictionary dictionary];
    [self areaListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+[self.cityDicNameForLetter allKeys].count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else {
        NSArray *sortedKeys = [[self.cityDicNameForLetter allKeys] sortedArrayUsingSelector:@selector(compare:)];

        NSString * key = sortedKeys[section-1];

        NSArray * array = [self.cityDicNameForLetter objectForKey:key];

        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.textLabel.text = self.currentCity;
    }
    else {
        NSString * key = [[self.cityDicNameForLetter allKeys] sortedArrayUsingSelector:@selector(compare:)][indexPath.section-1];
        NSDictionary * dic = self.cityDicNameForLetter[key];
        NSArray * sortedKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        BATCityData * city = dic[sortedKeys[indexPath.row]];
        cell.textLabel.text = city.CITY_NAME;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    headView.backgroundColor = [UIColor lightGrayColor];
    headView.backgroundColor = UIColorFromHEX(0xededed, 1);

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    if (section == 0) {
        titleLabel.text = @"当前定位城市";
    }else{
        NSArray *sortedKeys = [[self.cityDicNameForLetter allKeys] sortedArrayUsingSelector:@selector(compare:)];
        titleLabel.text = sortedKeys[section-1];
    }
    [headView addSubview:titleLabel];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//设置索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *sortedKeys = [[self.cityDicNameForLetter allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortedKeys];
    [array insertObject:@" " atIndex:0];
    return array;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        NSString * key = [[self.cityDicNameForLetter allKeys] sortedArrayUsingSelector:@selector(compare:)][indexPath.section-1];
        NSDictionary * dic = self.cityDicNameForLetter[key];
        NSArray * sortedKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        BATCityData * city = dic[sortedKeys[indexPath.row]];
        if (self.cityChanged) {
            self.cityChanged(city.CITY_NAME);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NET
- (void)areaListRequest {
    WEAK_SELF(self);
    //获取所有支持的城市
    [BATHospitalRegisterTool getCityListWithSuccess:^(BATCityListModel *cityList) {
        STRONG_SELF(self);
        self.cityList = cityList;

        for (BATCityData * city in cityList.Data) {
            CFStringRef aCFString = (__bridge CFStringRef)city.CITY_NAME;
            //copy 一下，另外改为可变的
            CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, aCFString);
            //翻译一下，改为拼音（带音调的）：shí jiā zhuāng shì
            CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
            //去声调！！！：shi jia zhuang shi
            CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);

            //转化为oc：NSString
            NSString * cityLetter = (__bridge NSString *)string;
            CFRelease(string);

            NSString * indexStr = [cityLetter substringToIndex:1];

            if (self.cityDicNameForLetter[indexStr]) {

                NSMutableDictionary * dic = _cityDicNameForLetter[indexStr];
                [dic setObject:city forKey:cityLetter];
                [self.cityDicNameForLetter setObject:dic forKey:indexStr];

            }
            else {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:city forKey:cityLetter];
                [self.cityDicNameForLetter setObject:dic forKey:indexStr];
            }
        }
        [self.cityTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.cityTableView];
}

#pragma mark - setter && getter
- (UITableView *)cityTableView {
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;

        [_cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _cityTableView;
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
