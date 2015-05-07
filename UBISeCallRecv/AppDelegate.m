//
//  AppDelegate.m
//  UBISeCallRecv
//
//  Created by youngseok Kim on 2015. 5. 3..
//  Copyright (c) 2015년 youngseok Kim. All rights reserved.
//
#import "CAllServer.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"%@",@"등록완료");
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        NSLog(@"%@",@"등록완료");
    }
    
    if(launchOptions)
    {
        application.applicationIconBadgeNumber = 0;
        
        NSDictionary *launchDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey ];
        NSDictionary *apsDictionary = [launchDictionary valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        
        NSInteger applicationIconBadgeNumber = [application applicationIconBadgeNumber];
        
        [application setApplicationIconBadgeNumber:applicationIconBadgeNumber];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:message delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:@"전화걸기", nil];
        [alert show];
        
        
        
       
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"My token is: %@", deviceToken);
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    
    NSLog(@"APNS Device Token: %@", deviceId);
   // deviceTok = deviceId;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.DEVICE_TOK = deviceId;

    NSLog(@"APNS Device Tok: %@", app.DEVICE_TOK);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    application.applicationIconBadgeNumber = 0;
    NSDictionary *apsDictionary = [userInfo valueForKey:@"aps"];
    NSString *GRP_CD            = [userInfo valueForKey:@"GRP_CD"];
    NSString *EMC_ID            = [userInfo valueForKey:@"EMC_ID"];
    NSString *EMC_MSG           = [userInfo valueForKey:@"EMC_MSG"];
    NSString *CODE              = [userInfo valueForKey:@"CODE"];
    NSString *message           = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
    NSLog(@"GRP_CD: %@",    GRP_CD);
    NSLog(@"EMC_ID: %@",    EMC_ID);
    NSLog(@"EMC_MSG: %@",   EMC_MSG);
    NSLog(@"CODE: %@",      CODE);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                          message:EMC_MSG delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:@"전화걸기", nil];
    [alert show];

    /*
    if(application.applicationState == UIApplicationStateActive){
        NSDictionary *apsDictionary = [userInfo valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        NSLog(@"message: %@", message);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:@"전화걸기", nil];
        
        [alert show];
        
    }else if(application.applicationState == UIApplicationStateInactive){
        
        NSDictionary *apsDictionary = [userInfo valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        NSLog(@"message: %@", message);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                              message:message delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"전화걸기", nil];
        [alert show];
        //전화걸기
        
    }else{
        
        NSDictionary *apsDictionary = [userInfo valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        NSLog(@"message: %@", message);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"전화걸기", nil];
        [alert show];

        NSLog(@"message: %@", @"fail state");
        
    }*/
    NSInteger applicationIconBadgeNumber = [application applicationIconBadgeNumber];

    [application setApplicationIconBadgeNumber:applicationIconBadgeNumber];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    /*
    if(application.applicationState == UIApplicationStateActive){
        
        // Foreground에서 알림 수신
        NSDictionary *userinf = notification.userInfo;
        // NSString *tel = [userinf dictionaryWithValuesForKeys:];
        
        
        
        NSString *tel = [userinf objectForKey:@"tel"];
        
        
        NSDictionary *apsDictionary = [userinf valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        NSLog(@"message: %@", message);
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:@"전화걸기", nil];
        //NSLog(@"A4PNS Device Token: %@", notification.);
        
        [alert show];
        
     
        NSLog(@"keys cont %@",tel);
        NSString *string = [NSString stringWithFormat:@"tel://%@",tel];
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        UIDevice *device = [UIDevice currentDevice];
        NSString* idForVendor = [device.identifierForVendor UUIDString];
        
        CAllServer* res = [CAllServer alloc];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:@"EV01" forKey:@"code"];
        [param setObject:idForVendor forKey:@"deviceId"];
     
        
        //[param setValue:self.locationTxt.text forKey:@"location"];
        
        // NSString* str = [res stringWithUrl:@"emcInfoPush.do" VAL:param];
        
    }
    
    if(application.applicationState == UIApplicationStateInactive){
        
        // Background에서 알림 액션에 의한 수신
        // notification.userInfo 이용하여 처리
        NSLog(@"A3PNS Device Token: %@", @"test1");
        
        
        NSDictionary *userinf = notification.userInfo;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"발신자에게 전화거는중...." delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"전화걸기", nil];
        
        [alert show];
        

        // NSString *tel = [userinf dictionaryWithValuesForKeys:];
        // NSLog(@"key count %d", userinf.allKeys.count);
        NSString *tel = [userinf objectForKey:@"tel"];
        
        NSDictionary *apsDictionary = [userinf valueForKey:@"aps"];
        NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        NSLog(@"message: %@", message);
        
        
        NSString *string = [NSString stringWithFormat:@"tel://%@",@"01032198418"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        
        
        
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
        //                                      message:notification.alertBody delegate:nil
        //                                      cancelButtonTitle:@"OK"
        //                                      otherButtonTitles:nil];
        //        NSLog(@"A4PNS Device Token: %@", tel);
        
       
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        UIDevice *device = [UIDevice currentDevice];
        NSString* idForVendor = [device.identifierForVendor UUIDString];
        
        CAllServer* res = [CAllServer alloc];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:@"EV01" forKey:@"code"];
        [param setObject:idForVendor forKey:@"deviceId"];
        
         //[param setValue:self.locationTxt.text forKey:@"location"];
        
        // NSString* str = [res stringWithUrl:@"emcInfoPush.do" VAL:param];
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    */
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    // OK 버튼을 눌렀을 때 버튼Index가 1로 들어감
    if (buttonIndex == 1) {
        NSLog(@"Clicked YES");
        //NSString *string = [NSString stringWithFormat:@"tel://%@",@"01032198418"];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        
        CAllServer* res = [CAllServer alloc];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:@""            forKey:@"emc_id"];
        [param setObject:@"EV01"        forKey:@"code"];
        [param setValue:@""             forKey:@"hp"];
        [param setValue:@"C"            forKey:@"status"];
        
        //param.put("emc_id", emcid);
        //param.put("code", code);
        //param.put("hp", mobileNo);
        //param.put("status", "C");
        
        NSString* str = [res stringWithUrl:@"emcConfirm.do" VAL:param];
        
        NSLog(@" %@",str);
        /*
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* keys = jsonInfo.allKeys;
        
        NSLog(@"keys cont %d",keys.count);
        
        for (int i=0; i<keys.count; i++) {
            
            
            if([@"RESULT" isEqual:[keys objectAtIndex:i]])
            {
                if([@"SUCCESS" isEqual:[jsonInfo objectForKey:[keys objectAtIndex:i]]])
                {
                    NSLog(@"key %@  value %@",[keys objectAtIndex:i],[jsonInfo objectForKey:[keys objectAtIndex:i]] );
                    
                    
                }
            }
           
            
            
            if([@"ERR_MSG" isEqual:[keys objectAtIndex:i]])
            {
                
            }
        }
        
        */
        
        
        CAllServer* res2 = [CAllServer alloc];
        NSMutableDictionary* param2 = [[NSMutableDictionary alloc] init];
        [param2 setObject:@""            forKey:@"emc_id"];
       
        //param.put("emc_id", emcid);
      
        NSString* str2 = [res2 stringWithUrl:@"emcSenderInfo.do" VAL:param2];
        
        NSLog(@" %@",str2);
        
        NSData *jsonData2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error2;
        NSDictionary *jsonInfo2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:kNilOptions error:&error2];
        NSArray* keys2 = jsonInfo2.allKeys;
        
        NSLog(@"keys cont %d",keys2.count);
        
        for (int i=0; i<keys2.count; i++) {
            
            
            if([@"RESULT" isEqual:[keys2 objectAtIndex:i]])
            {
                if([@"SUCCESS" isEqual:[jsonInfo2 objectForKey:[keys2 objectAtIndex:i]]])
                {
                    NSLog(@"key %@  value %@",[keys2 objectAtIndex:i],[jsonInfo2 objectForKey:[keys2 objectAtIndex:i]] );
                    
                    
                    
                }
            }
            
            if([@"HP" isEqual:[keys2 objectAtIndex:i]])
            {
                NSString *string = [NSString stringWithFormat:@"tel://%@",[keys2 objectAtIndex:i]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            }
            
            if([@"ERR_MSG" isEqual:[keys2 objectAtIndex:i]])
            {
                
            }
        }
        
    }
    else {
        NSLog(@"Clicked NO");
        
        CAllServer* res = [CAllServer alloc];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:@""            forKey:@"emc_id"];
        [param setObject:@"EV01"        forKey:@"code"];
        [param setValue:@""             forKey:@"hp"];
        [param setValue:@"C"            forKey:@"status"];
        
        //param.put("emc_id", emcid);
        //param.put("code", code);
        //param.put("hp", mobileNo);
        //param.put("status", "C");
        
        NSString* str = [res stringWithUrl:@"emcConfirm.do" VAL:param];
        
        NSLog(@" %@",str);
        
        
        
    }
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
