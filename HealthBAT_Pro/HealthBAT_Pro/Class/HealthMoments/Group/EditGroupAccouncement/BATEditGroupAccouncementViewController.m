//
//  BATEditGroupAccouncementViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATEditGroupAccouncementViewController.h"

@interface BATEditGroupAccouncementViewController () <YYTextViewDelegate>

@end

@implementation BATEditGroupAccouncementViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _editGroupAccouncementView.textView.delegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_editGroupAccouncementView == nil) {
        _editGroupAccouncementView = [[BATEditGroupAccouncementView alloc] init];
        _editGroupAccouncementView.textView.delegate = self;
        [self.view addSubview:_editGroupAccouncementView];
        
        WEAK_SELF(self);
        [_editGroupAccouncementView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    WEAK_SELF(self);
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_right_save"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        STRONG_SELF(self);
        [self requestSendAccountcement];
    }];
    
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"写一写";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    if (textView.text.length > 200) {
        [self showText:@"最多输入200个字"];
        textView.text = [textView.text substringToIndex:200];
    }
    _editGroupAccouncementView.textView.text = textView.text;
    _editGroupAccouncementView.wordCountLabel.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)_editGroupAccouncementView.textView.text.length];
    
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - NET

#pragma mark - 发布群公告
-(void)requestSendAccountcement
{
    [self.view endEditing:YES];
    if (_editGroupAccouncementView.textView.text.length <= 0) {
        [self showText:@"请输入公告内容！"];
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/Group/AddGroupNoticeInfo" parameters:@{@"groupId":@(_groupID),@"noticeContent":_editGroupAccouncementView.textView.text} type:kPOST success:^(id responseObject) {
        
        [self showText:@"发布成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupAccouncementNotification object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
    //    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Group/AddGroupNoticeInfo?GroupId=%ld&NoticeContent=%@",(long)_groupID,_editGroupAccouncementView.textView.text] parameters:nil type:kPOST success:^(id responseObject) {
    //
    //        [self showText:@"发布成功"];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:BATRefreshGroupAccouncementNotification object:nil];
    //
    //        [self.navigationController popViewControllerAnimated:YES];
    //
    //    } failure:^(NSError *error) {
    //        
    //    }];
}


@end
