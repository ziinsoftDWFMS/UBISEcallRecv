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


@interface ViewController ()

@end

@implementation ViewController

BOOL navigateYN;
NSString* idForVendor;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    
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
    NSArray* keys = jsonInfo.allKeys;
    
    NSLog(@"keys cont %d",keys.count);
    
    NSLog(@" ,login?? %@",str);
    
    
    if([str  isEqual: @"{}"]){
        
        NSLog(@">>>>>%@",idForVendor);
        
        navigateYN = YES;
        
    }else{
        navigateYN = NO;
        
    }

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    
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


- (IBAction)closeButton:(UIButton *)sender {
    exit(0);
}



@end
