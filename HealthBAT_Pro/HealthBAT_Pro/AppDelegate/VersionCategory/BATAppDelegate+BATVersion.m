//
//  BATAppDelegate+BATVersion.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATVersion.h"
#import "BATVersionModel.h"

@implementation BATAppDelegate (BATVersion)

- (void)bat_versionEnterprise {

    [HTTPTool requestWithURLString:@"/api/GetAppVersion"
                           parameters:@{
                                        @"accountType":@1,
                                        @"equipment":@"IOS",
                                        @"versionId":[Tools getLocalVersion]
                                        }
                                 type:kGET
                              success:^(id responseObject) {

                                  BATVersionModel *version = [BATVersionModel mj_objectWithKeyValues:responseObject];
                                  if (version.Data.IsUpdate) {
                                      //需要更新

                                      NSString *newVersionMessage = @"";
                                      for (VersionMessage *message in version.Data.UpdateMessageList) {
                                          newVersionMessage = [newVersionMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@",message.Keyword]];
                                      }
                                     UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"有新的版本需要更新" message:newVersionMessage preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                         //版本更新
                                         //跳转到更新地址
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version.Data.UpAddress]];
                                         //退出app
                                         exit(0);
                                     }];
                                     [alert addAction:okAction];;

                                      UIView *subView1 = alert.view.subviews[0];
                                      UIView *subView2 = subView1.subviews[0];
                                      UIView *subView3 = subView2.subviews[0];
                                      UIView *subView4 = subView3.subviews[0];
                                      UIView *subView5 = subView4.subviews[0];
                                      DDLogDebug(@"%@",subView5.subviews);
                                      //取title和message：
//                                      UILabel *title = subView5.subviews[0];
                                      UILabel *message = subView5.subviews[1];
                                      message.textAlignment = NSTextAlignmentLeft;
//                                      title.textAlignment = NSTextAlignmentLeft;

                                     [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
  
                                  }

                              }
                              failure:^(NSError *error) {

                              }];

}

@end
