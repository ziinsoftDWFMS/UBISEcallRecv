//
//  authViewController.m
//  TEST_DWFMS_EMG
//
//  Created by youngseok Kim on 2015. 4. 29..
//  Copyright (c) 2015년 kimhyang. All rights reserved.
//

#import "authViewController.h"
#import "CAllServer.h"
#import "AppDelegate.h"
@interface authViewController ()

@end

@implementation authViewController
@synthesize phoneText;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendEvent:(id)sender {
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"device Token is<<<>>>%@", app.DEVICE_TOK);
    
    
    NSString *phone = self.phoneText.text;
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    
    CAllServer* res = [CAllServer alloc];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:@"hp"];
    [param setObject:idForVendor forKey:@"deviceId"];
    [param setValue:@"R" forKey:@"gubun"];
    [param setValue:@"RV01" forKey:@"code"];
    [param setValue:app.DEVICE_TOK forKey:@"gcm_id"];
    NSString* str = [res stringWithUrl:@"regEmcAppInstInfo.do" VAL:param];
    
    NSLog(@" %@",str);
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSArray* keys = jsonInfo.allKeys;
    
    NSLog(@"keys cont %d",keys.count);
    
    NSString * urlParam =@"";
    for (int i=0; i<keys.count; i++) {
       
        
        if([@"RESULT" isEqual:[keys objectAtIndex:i]])
        {
            if([@"SUCCESS" isEqual:[jsonInfo objectForKey:[keys objectAtIndex:i]]])
            {
                NSLog(@"key %@  value %@",[keys objectAtIndex:i],[jsonInfo objectForKey:[keys objectAtIndex:i]] );

                [self performSegueWithIdentifier:@"webviewTrans" sender:self];
                //[UIView animateWithDuration:0.0 animations:^{
                //    self.view.alpha = 0;
                //} completion:^(BOOL b){
                //    [self.presentingViewController dismissModalViewControllerAnimated:NO];
                //    self.view.alpha = 1;
                //}];

            }
        }
        
        if([@"ERR_MSG" isEqual:[keys objectAtIndex:i]])
        {
            self.infoText.text =  [jsonInfo objectForKey:[keys objectAtIndex:i]];
            
        }
    }
    
    
    //[res test:@"callTest.do"]
    
}
- (IBAction)cancelEvent:(id)sender {
    
    exit(0);
    /*
    [UIView animateWithDuration:0.0 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL b){
        [self.presentingViewController dismissModalViewControllerAnimated:NO];
        self.view.alpha = 1;
    }];*/
    
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
