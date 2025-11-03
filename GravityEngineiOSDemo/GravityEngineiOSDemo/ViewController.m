//
//  ViewController.m
//  GravityEngineiOSDemo
//
//  Created by leo on 2025/10/27.
//

#import "ViewController.h"
#import <GravityEngineSDK/GravitySDK.h>
#import "NetWorkCheckTool.h"

#define FUNCTION_INITIALIZE @"Initialize"//init
#define FUNCTION_TRACK_PAY_EVENT @"Track pay event"
#define FUNCTION_TRACK_AD_EVENT @"Track ad event"//track
#define FUNCTION_USER_SET @"User Set"
#define FUNCTION_USER_SET_ONCE @"User Set Once"
#define FUNCTION_USER_INCREMENT @"User Increment"
#define FUNCTION_USER_NUMBER_MAX @"User Number Max"
#define FUNCTION_USER_NUMBER_MIN @"User Number Min"
#define FUNCTION_USER_APPEND @"User Append"
#define FUNCTION_USER_UNIQ_APPEND @"User Uniq Append"
#define FUNCTION_USER_UNSET @"User Unset"
#define FUNCTION_USER_DELETE @"User Delete"//user
#define FUNCTION_SET_SUPER_PROPERTIES @"Set Super Properties"
#define FUNCTION_SET_AUTO_EVENT_PROP @"Set Auto Event Prop"
#define FUNCTION_UNSET_ALL @"Unset All"
#define FUNCTION_UNSET_CHANNEL @"Unset Channel"//set properties
#define FUNCTION_FLUSH @"Flush"//flush

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,GEScreenAutoTracker>

@property (weak, nonatomic) IBOutlet UITableView * functionTableView;
@property(nonatomic,strong)NSArray<NSString*> * functionTitles;
@property(nonatomic,strong)NSArray<NSArray<NSString*>*> * functionDatas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.functionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"function_cell"];
    self.functionTitles = @[@"init",@"track",@"user",@"properties",@"flush"];
    self.functionDatas = @[
        @[FUNCTION_INITIALIZE],//init
        @[FUNCTION_TRACK_PAY_EVENT,
          FUNCTION_TRACK_AD_EVENT],//track
        @[FUNCTION_USER_SET,
          FUNCTION_USER_SET_ONCE,
          FUNCTION_USER_INCREMENT,
          FUNCTION_USER_NUMBER_MAX,
          FUNCTION_USER_NUMBER_MIN,
          FUNCTION_USER_APPEND,
          FUNCTION_USER_UNIQ_APPEND,
          FUNCTION_USER_UNSET,
          FUNCTION_USER_DELETE],//user
        @[FUNCTION_SET_SUPER_PROPERTIES,
          FUNCTION_SET_AUTO_EVENT_PROP,
          FUNCTION_UNSET_ALL,
          FUNCTION_UNSET_CHANNEL],//set properties
        @[FUNCTION_FLUSH],//flush
    ];
    // Do any additional setup after loading the view.
    GEConfig *config = [GEConfig new];
    config.appid = @"27086495";
    config.accessToken = @"C7GkLEgnRqiMnpvguAsoYemxkKoea3wt";
    config.debugMode = GravityEngineDebugOn;
    [GravityEngineSDK startWithConfig:config];
    GravityEngineSDK *instance = [GravityEngineSDK sharedInstanceWithAppid:@"27086495"];
    // 开启自动采集
    [instance enableAutoTrack:GravityEngineEventTypeAll];
    
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
    //初始化
    [instance initializeGravityEngineWithAsaEnable:YES withClientId:@"" withCaid1:@"" withCaid2:@"" withSyncAttribution:NO withChannel:@"appstore" withSuccessCallback:^(NSDictionary * _Nonnull response) {
       NSLog(@"gravity engine initialize success, response is %@", response);
    } withErrorCallback:^(NSError * _Nonnull error) {
       NSLog(@"gravity engine initialize failed, and error is %@", error);
    }];
}


#pragma mark - Function Map

-(void)doFunctionForName:(NSString *)functionName{
    GravityEngineSDK *instance = [GravityEngineSDK sharedInstanceWithAppid:@"27086495"];
    if([functionName isEqualToString:FUNCTION_INITIALIZE]){
        //注册turbo平台账号，只调用一次即可
        [instance initializeGravityEngineWithAsaEnable:YES withClientId:@"" withCaid1:@"" withCaid2:@"" withSyncAttribution:NO withChannel:@"appstore" withSuccessCallback:^(NSDictionary * _Nonnull response) {
           NSLog(@"gravity engine initialize success, response is %@", response);
        } withErrorCallback:^(NSError * _Nonnull error) {
           NSLog(@"gravity engine initialize failed, and error is %@", error);
        }];
    }else if([functionName isEqualToString:FUNCTION_TRACK_PAY_EVENT]){
        //上报付费事件
        [instance trackPayEventWithAmount:300 withPayType:@"CNY" withOrderId:[NSString stringWithFormat:@"order_id_%@",@([[NSDate date] timeIntervalSince1970])] withPayReason:@"月卡" withPayMethod:@"支付宝"];
    }else if([functionName isEqualToString:FUNCTION_TRACK_AD_EVENT]){
        //上报广告相关事件
        [instance trackAdLoadEventWithUninType:@"topon" withPlacementId:@"placement_id" withSourceId:@"ad_source_id" withAdType:@"reward" withAdnType:@"csj"];
        [instance trackAdShowEventWithUninType:@"topon" withPlacementId:@"placement_id" withSourceId:@"ad_source_id" withAdType:@"reward" withAdnType:@"csj" withEcpm:@(1)];
        [instance trackAdClickEventWithUninType:@"topon" withPlacementId:@"placement_id" withSourceId:@"ad_source_id" withAdType:@"reward" withAdnType:@"csj" withEcpm:@(1)];
        [instance trackAdPlayStartEventWithUninType:@"topon" withPlacementId:@"placement_id" withSourceId:@"ad_source_id" withAdType:@"reward" withAdnType:@"csj" withEcpm:@(1)];
        [instance trackAdPlayEndEventWithUninType:@"topon" withPlacementId:@"placement_id" withSourceId:@"ad_source_id" withAdType:@"reward" withAdnType:@"csj" withEcpm:@(1) withDruation:@(50) withIsPlayOver:NO];
    }else if([functionName isEqualToString:FUNCTION_USER_SET]){
        //设置用户属性信息
        [instance user_set:@{@"$name":@"turboUserName",@"$gender":@"男"}];
    }else if([functionName isEqualToString:FUNCTION_USER_SET_ONCE]){
        //记录初次设定的用户属性，比如记录用户性别
        [instance user_set_once:@{@"$gender":@"male"}];
    }else if([functionName isEqualToString:FUNCTION_USER_INCREMENT]){
        //数值类型的属性直接进行累加
        [instance user_increment:@{@"$age":@(27)}];
    }else if([functionName isEqualToString:FUNCTION_USER_NUMBER_MAX]){
        //数值类型的属性取最大值
        [instance user_number_max:@{@"ad_ecpm_max":@(300)}];
    }else if([functionName isEqualToString:FUNCTION_USER_NUMBER_MIN]){
        //数值类型的属性取最小值
        [instance user_number_min:@{@"ad_ecpm_min":@(100)}];
    }else if([functionName isEqualToString:FUNCTION_USER_APPEND]){
        //列表类型的属性，可以直接append
        [instance user_append:@{@"Movies":@[@"Interstellar",@"The Negro Motorist Green Book"]}];
    }else if([functionName isEqualToString:FUNCTION_USER_UNIQ_APPEND]){
        //列表类型的属性，可以去重append
        [instance user_uniqAppend:@{@"Movies":@[@"Interstellar",@"The Negro Motorist Green Book"]}];
    }else if([functionName isEqualToString:FUNCTION_USER_UNSET]){
        //属性取消
        [instance user_unset:@"$age"];
    }else if([functionName isEqualToString:FUNCTION_USER_DELETE]){
        //清空用户属性信息
        [instance user_delete];
    }else if([functionName isEqualToString:FUNCTION_SET_SUPER_PROPERTIES]){
        //设置公共事件属性
        [instance setSuperProperties:@{@"age":@(2),@"channel":@"xiaomi"}];
    }else if([functionName isEqualToString:FUNCTION_SET_AUTO_EVENT_PROP]){
        //设置自动采集事件自定义属性
        [instance setAutoTrackProperties:GravityEngineEventTypeAppInstall|GravityEngineEventTypeAppEnd properties:@{@"key1":@(2)}];
    }else if([functionName isEqualToString:FUNCTION_UNSET_ALL]){
        //清空所有公共事件属性
        [instance clearSuperProperties];
    }else if([functionName isEqualToString:FUNCTION_UNSET_CHANNEL]){
        //清除公共事件属性 Channel
        [instance unsetSuperProperty:@"SUPER_PROPERTY_CHANNEL"];
    }else if([functionName isEqualToString:FUNCTION_FLUSH]){
        //立即执行上报
        [instance flush];
    }
}


#pragma mark - GEScreenAutoTracker

- (NSDictionary *)getTrackProperties {
    return @{@"PageName" : @"测试demo主页", @"ProductId" : @12345};
}

- (NSString *)getScreenUrl {
    return @"APP://main_view";
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.functionDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.functionDatas[section].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.functionTitles[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"function_cell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.functionDatas[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doFunctionForName:self.functionDatas[indexPath.section][indexPath.row]];
}


@end
