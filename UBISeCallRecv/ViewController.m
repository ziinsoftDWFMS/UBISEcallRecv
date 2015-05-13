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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    [param setValue:@"RV01" forKey:@"code"];
    [param setValue:@"S" forKey:@"gubun"];
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
        // [tempViewCon.view setBackgroundColor:[UIColor whiteColor]];
        // [[self navigationController] pushViewController:tempViewCon animated: YES];
        
        NSLog(@">>31231>>>1234%@",idForVendor);
        
        
        
        // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:[NSBundle mainBundle]];
        
        
        
        //IdentViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        
        // [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"IdentView"] animated:YES];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *authViewController = [storyboard instantiateViewControllerWithIdentifier:@"authViewController"];
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        authViewController.view.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            authViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [self presentModalViewController:authViewController animated:NO];
        }];
        
        
    }else{
        
        
        NSLog(@">>4566>>>1234%@",idForVendor);
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
