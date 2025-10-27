//
//  ViewController.m
//  GravityEngineiOSDemo
//
//  Created by leo on 2025/10/22.
//

#import "ViewController.h"
#import <GravityEngineSDK/GravitySDK.h>
#import "NetWorkCheckTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GEConfig *config = [GEConfig new];
    config.appid = @"27086495";
    config.accessToken = @"C7GkLEgnRqiMnpvguAsoYemxkKoea3wt";
    config.debugMode = GravityEngineDebugOn;
    [GravityEngineSDK startWithConfig:config];
    
    [self checkNetWorkBeforeInitSDk];
//    [self initializeGravityEngine];
}

-(void)checkNetWorkBeforeInitSDk{
    if([NetWorkCheckTool hasConnectedToNetwork]){//检查是否有网络(没有网络时，可能是网络授权弹窗还在展示请求网络授权，会与接下来的归因弹窗冲突)
        [self performSelector:@selector(initializeGravityEngine) withObject:nil afterDelay:0.5f];//一定要延时0.5+s，不然第一个网络授权弹窗还没消失，归因授权弹窗会弹出失败，直接导致授权失败
    }else{
        [self performSelector:@selector(checkNetWorkBeforeInitSDk) withObject:nil afterDelay:0.2f];
    }
}


-(void)initializeGravityEngine{
    GravityEngineSDK *instance = [GravityEngineSDK sharedInstanceWithAppid:@"27086495"];
    // 开启自动采集
    [instance enableAutoTrack:GravityEngineEventTypeAll];
    //初始化
    NSLog(@"归因授权弹窗开始");
    [instance initializeGravityEngineWithAsaEnable:YES withClientId:@"" withCaid1:@"" withCaid2:@"" withSyncAttribution:NO withChannel:@"appstore" withSuccessCallback:^(NSDictionary * _Nonnull response) {
       NSLog(@"gravity engine initialize success, response is %@", response);
    } withErrorCallback:^(NSError * _Nonnull error) {
       NSLog(@"gravity engine initialize failed, and error is %@", error);
    }];
}

@end
