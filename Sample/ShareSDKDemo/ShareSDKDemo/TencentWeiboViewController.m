//
//  TencentWeiboViewController.m
//  ShareSDKDemo
//
//  Created by wukx on 2018/7/16.
//  Copyright © 2018年 Max. All rights reserved.
//

#import "TencentWeiboViewController.h"

@interface TencentWeiboViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TencentWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            cell.textLabel.text = @"获取用户信息";
        }
        else if (indexPath.row == 0)
        {
            cell.textLabel.text = @"授权";
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"取消授权";
        }
        else
        {
            cell.textLabel.text = @"";
        }
    }
    else if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"文字";
                break;
            case 1:
                cell.textLabel.text = @"图片";
                break;
            default:
                break;
        }
    }
    else
    {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"授权";
    }
    else if (section == 0)
    {
        return @"分享";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section)
    {
        if (indexPath.row == 1)
        {
            [self _getUserInfo];
        }
        else if (indexPath.row == 0)
        {
            [self _auth];
        }
        else if (indexPath.row == 2)
        {
            [self _cancelAuth];
        }
        return;
    }
    
    switch (indexPath.row)
    {
        case 0:
            [self _shareText];
            break;
        case 1:
            [self _shareImage];
            break;
        default:
            break;
    }
}

- (void)_shareText
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    [parameters SSDKSetupShareParamsByText:@"Share SDK"
                                    images:nil
                                       url:nil
                                     title:nil
                                      type:SSDKContentTypeText];
    //平台定制
//        [parameters SSDKSetupTencentWeiboShareParamsByText:@"Share SDK"
//                                                    images:nil
//                                                  latitude:0
//                                                  longitude:0
//                                                      type:SSDKContentTypeText];
    [self _shareParams:parameters];
}

- (void)_shareImage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    [parameters SSDKSetupShareParamsByText:@"Share SDK"
                                    images:[[NSBundle mainBundle] pathForResource:@"D45" ofType:@"jpg"]
                                       url:nil
                                     title:nil
                                      type:SSDKContentTypeImage];
    
    
    //平台定制
//        [parameters SSDKSetupTencentWeiboShareParamsByText:@"Share SDK"
//                                                    images:[[NSBundle mainBundle] pathForResource:@"D45" ofType:@"jpg"]
//                                                  latitude:0
//                                                 longitude:0
//                                                      type:SSDKContentTypeText];
    [self _shareParams:parameters];
}

- (void)_shareParams:(NSMutableDictionary *)params
{
    [ShareSDK shareWithParameters:params platformType:SSDKPlatformTypeTencentWeibo stateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state)
        {
            case SSDKResponseStateSuccess:
                NSLog(@"TencentWeibo Share-------------------------->Success!:\n userData:%@ \n contentEntity:%@",userData,contentEntity);
                break;
            case SSDKResponseStateCancel:
                NSLog(@"TencentWeibo Share-------------------------->Cancel!");
                break;
            case SSDKResponseStateFail:
                NSLog(@"TencentWeibo Share-------------------------->Failed:%@",error);
                break;
                
            default:
                break;
        }
    }];
}

- (void)_getUserInfo
{
    [ShareSDK getUserInfo:SSDKPlatformTypeTencentWeibo condition:nil stateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        switch (state)
        {
            case SSDKResponseStateSuccess:
                NSLog(@"TencentWeibo getUserInfo-------------------------->Success! %@",user.dictionaryValue);
                break;
            case SSDKResponseStateCancel:
                NSLog(@"TencentWeibo getUserInfo-------------------------->Cancel!");
                break;
            case SSDKResponseStateFail:
                NSLog(@"TencentWeibo getUserInfo-------------------------->Failed:%@",error);
                break;
                
            default:
                break;
        }
    }];
}

- (void)_auth
{
    [ShareSDK authorize:SSDKPlatformTypeTencentWeibo settings:nil stateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        switch (state)
        {
            case SSDKResponseStateSuccess:
                NSLog(@"TencentWeibo auth-------------------------->Success! User:%@",user.dictionaryValue);
                break;
            case SSDKResponseStateCancel:
                NSLog(@"TencentWeibo auth-------------------------->Cancel!");
                break;
            case SSDKResponseStateFail:
                NSLog(@"TencentWeibo auth-------------------------->Failed:%@",error);
                break;
                
            default:
                break;
        }
    }];
}

- (void)_cancelAuth
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeTencentWeibo result:^(NSError *error) {
        
    }];
}

@end
