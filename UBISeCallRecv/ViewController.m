//
//  ViewController.m
//  UBISeCallRecv
//
//  Created by youngseok Kim on 2015. 5. 3..
//  Copyright (c) 2015년 youngseok Kim. All rights reserved.
//

#import "ViewController.h"
#import "CAllServer.h"
#import "authViewController.h"
#import "GlobalData.h"
#import "GlobalDataManager.h"
#import "Commonutil.h"
#import "AppDelegate.h"
#import "ToastAlertView.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface ViewController ()

@end

@implementation ViewController

BOOL navigateYN;
NSString* idForVendor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //network check
    
    NSLog(@"Connection ststus : %@", [self connectedToNetwork] ? @"YES" : @"NO");
    
    //나중에 적용하자..Message Box
    //---------------------------------------------------------
    //_locationTxt.delegate = self;
    [self.webView setDelegate:self];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.main = self;
    
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    [param setValue:@"RV01" forKey:@"code"];
    [param setValue:@"R" forKey:@"gubun"];
    
    [param setObject:idForVendor forKey:@"deviceId"];
    
    //deviceId
    
    //R 수신
    
    NSString* str = [res stringWithUrl:@"getEmcUserInfo.do" VAL:param];
    
    //regEmcAppInstInfo.do
    
    //
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    //NSArray* keys = jsonInfo.allKeys;
    
    //NSLog(@"keys cont %d",keys.count);
    
    NSLog(@" ,login?? %@",str);
    
    NSString *urlParam=@"";
    NSString *server = [GlobalData getServerIp];
    NSString *pageUrl = [NSString stringWithFormat:@"/emcRecvList.do"];
    NSString *callUrl = @"";
    
    if([str  isEqual: @"{}"]){
        
        NSLog(@">>>>>%@",idForVendor);
        
        navigateYN = YES;
        
    }else{
        [GlobalDataManager initgData:(jsonInfo)];
        navigateYN = NO;
        
        callUrl = [NSString stringWithFormat:@"%@%@?COMP_CD=%@&EMPNO=%@",server,pageUrl,[[GlobalDataManager getgData] compCd],[[GlobalDataManager getgData] empNo]];
        //callUrl = [NSString stringWithFormat:@"http://www.naver.com"];
        //callUrl = [NSString stringWithFormat:@"%@/emcSendDetail.do?actio=황창순", server];
        //NSLog(@"@@@@@@ callUrl : %@ ",callUrl);
        
        
        //callUrl = [callUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //NSURL *url=[NSURL URLWithString:[callUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSMutableURLRequest *requestURL=[[NSMutableURLRequest alloc]initWithURL:url];
        //[requestURL setHTTPMethod:@"GET"];
        
        //[requestURL setHTTPBody:[urlParam dataUsingEncoding:NSUTF8StringEncoding]];
        //[self.webView loadRequest:requestURL];
        NSLog(@"??????? urlParam %@",urlParam);
        
        
        
        
        
        
        NSString* param = [callUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* webUrl = [NSString stringWithFormat:@"%@", param];
        
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: webUrl]]];
        
    }

    
  //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
  //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
  //  [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"@@@@@@@@@@@@@@  call viewDidAppear");
    if (navigateYN) {
        navigateYN = NO;
        [self performSegueWithIdentifier:@"authviewTrans" sender:self];
    } else {
        
        NSLog(@">>4566>>>1234%@",idForVendor);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"@@@@@@@@@@@@@@  call viewWillAppear");
}


- (void)viewDidUnload {
    NSLog(@"@@@@@@@@@@@@@@  call viewDidunload");
    
    if (navigateYN) {
        NSLog(@"@@@@@@@@@@@@@@  load authViewController ~~~~~~~");
    } else {
        exit(0);
    }
}
- (void) setimage:(NSString*) path num:(NSString*)num{
    //       NSString * searchWord = @"/";
    //    NSString * replaceWord = @"\\\\";
    //    path =  [path stringByReplacingOccurrencesOfString:searchWord withString:replaceWord];
    NSLog(@"ddd path %@ num %@",path,num);
    
    NSString *scriptString = [NSString stringWithFormat:@"setimge('%@','%@');",path,num];
    NSLog(@"scriptString => %@", scriptString);
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
}

- (BOOL) connectedToNetwork {
    // 0.0.0.0 주소를 만든다.
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Reachability 플래그를 설정한다.
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        
        NSLog(@" Error. Could not recover network reachability flags");
        return 0;
    }
    
    // 플래그를 이용하여 각각의 네트워크 커넥션의 상태를 체크한다.
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    return ((isReachable && !needsConnection) || nonWiFi) ? YES : NO;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    // OK 버튼을 눌렀을 때 버튼Index가 1로 들어감
    
    if (buttonIndex == 1) {
        NSLog(@"Clicked YES");
        exit(0);
        
    }
}
//Error시 실행
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"IDI FAIL : %@, error UserINFO : %@",error, [error userInfo]);
}

//WebView 시작시 실행
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"START LOAD");
    
    
}

//WebView 종료 시행
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"FNISH LOAD");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //javascript => document.location = "somelink://yourApp/form_Submitted:param1:param2:param3";
    //scheme : somelink
    //absoluteString : somelink://yourApp/form_Submitted:param1:param2:param3
    
    NSString *requesturl1 = [[request URL] scheme];
    if([@"toapp" isEqual:requesturl1])
    {
        NSString *requesturl2 = [[request URL] absoluteString];
        NSString *decoded = [requesturl2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray* list = [decoded componentsSeparatedByString:@":"];
        NSString *type  = [list objectAtIndex:1];
        NSLog(@"?? %@",type);
        
        //Webview : web call case
        
        if([@"callImge" isEqual:type]){
            [self callImge:[decoded substringFromIndex:([type length]+7)]];
        }
    }
    
    
    return YES;
}


static BOOL diagStat = NO;
static NSInteger bIdx = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인", nil];
    
    [confirmDiag show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){
        diagStat = NO;
    }
    else if (bIdx == 1) {
        diagStat = YES;
    }
    return diagStat;
}


-(void) callImge:(NSString*) data{
    NSLog(@"callimge??");
    NSArray* list = [data componentsSeparatedByString:@"&"];
    
    
    NSMutableDictionary * temp =[[NSMutableDictionary alloc] init];
    
    for(int i =0;i<[list count];i++){
        NSArray* listTemp =   [[list objectAtIndex:i] componentsSeparatedByString:@"="];
        [temp setValue:[listTemp objectAtIndex:1] forKey:[listTemp objectAtIndex:0]];
        
        NSLog(@" key %@  value %@ ",[listTemp objectAtIndex:0],[listTemp objectAtIndex:1]);
    }
    [[GlobalDataManager getgData]setCameraData:temp];
    
    [self performSegueWithIdentifier:@"CameraCall" sender:self];
}


- (void) rcvAspn:(NSString*) jsonstring {
    /****************************************************************/
    if (![@"" isEqualToString:[GlobalData getEmcId]]) {
        NSString* callListDetail = @"";
        
        
        NSMutableDictionary *sessiondata =[GlobalDataManager getAllData];
        
        callListDetail = [NSString stringWithFormat:@"%@/emcRecvList.do?COMP_CD=%@&EMPNO=%@&EMC_ID=%@", [GlobalData getServerIp], [sessiondata valueForKey:@"session_COMP_CD"], [sessiondata valueForKey:@"session_EMPNO"], [GlobalData getEmcId]];
        
        NSString* param = [callListDetail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* webUrl = [NSString stringWithFormat:@"%@", param];
        
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: webUrl]]];
        
        
        
        
        //NSString *urlParam=@"";
        //NSURL *url=[NSURL URLWithString:callListDetail];
        //NSMutableURLRequest *requestURL=[[NSMutableURLRequest alloc]initWithURL:url];
        //[requestURL setHTTPMethod:@"POST"];
        //[requestURL setHTTPBody:[urlParam dataUsingEncoding:NSUTF8StringEncoding]];
        //[self.webView loadRequest:requestURL];
        
        NSLog(@"??????? urlParam %@",callListDetail);
        
        
        [GlobalData setEmcId:@""];
    }
    /****************************************************************/
    
}


@end
