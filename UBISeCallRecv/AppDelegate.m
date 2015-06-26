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
        //NSString *sndPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav" inDirectory:@"/"];
        //CFURLRef sndURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
        //AudioServicesCreateSystemSoundID(sndURL, &ssid);
        
        //AudioServicesPlaySystemSound(ssid);
        
     //   application.applicationIconBadgeNumber = 0;
        
        NSDictionary *launchDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey ];
        NSDictionary *apsDictionary = [launchDictionary valueForKey:@"aps"];
        //NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        
       // NSInteger applicationIconBadgeNumber = [application applicationIconBadgeNumber];
        
       // [application setApplicationIconBadgeNumber:applicationIconBadgeNumber];
        //[application setApplicationIconBadgeNumber:0];
   ///     [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
   //     [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
       // [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        
        //NSString *grpCd            = [launchDictionary valueForKey:@"GRP_CD"];
        NSString *emcId            = [launchDictionary valueForKey:@"EMC_ID"];
        NSString *emcMsg           = [launchDictionary valueForKey:@"EMC_MSG"];
        NSString *code              = [launchDictionary valueForKey:@"CODE"];
        
        
        
        
        //NSLog(@"GRP_CD: %@",    grpCd);
        NSLog(@"EMC_ID: %@",    emcId);
        NSLog(@"EMC_MSG: %@",   emcMsg);
        //NSLog(@"CODE: %@",      code);
        
        //GRP_CD  = grpCd;
        EMC_ID  = emcId;
        EMC_MSG = emcMsg;
        CODE    = code;
        
        
        //메세지 왼쪽 정렬을 위한 코드 삽입
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"\n\n\n\n\n\n" delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:@"전화걸기", nil];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 24.0, 250.0, 80.0)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        //label.textColor = [UIColor whiteColor];
        label.text = emcMsg;
        [alert addSubview:label];
         */
        //----------------------------------------------------------------------------------
        
        UITextView *txtView = nil ;
        //
        txtView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 80.0)];
        [txtView setBackgroundColor:[UIColor clearColor]];
        [txtView setTextAlignment:NSTextAlignmentLeft] ;
        [txtView setEditable:NO];
        [txtView setFont:[UIFont fontWithName:@"Avenir-Black" size:15]];
        [txtView setText:emcMsg];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[재난상황발생]"
                                                        message:@"" delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert setValue:txtView forKey:@"accessoryView"];
        //[alert addSubview:txtView];
        [alert show] ;

        
        
       
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
    
    if(application.applicationState == UIApplicationStateActive){
        NSString *sndPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"wav" inDirectory:@"/"];
        if([@"EM01"isEqualToString:[userInfo valueForKey:@"CODE"]])
        {
            sndPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav" inDirectory:@"/"];
        }
        CFURLRef sndURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
        AudioServicesCreateSystemSoundID(sndURL, &ssid);
        
        AudioServicesPlaySystemSound(ssid);
        
    }
    
    
    //application.applicationIconBadgeNumber = 0;
    //NSDictionary *apsDictionary = [userInfo valueForKey:@"aps"];
    //NSString *grpCd            = [userInfo valueForKey:@"GRP_CD"];
    NSString *emcId            = [userInfo valueForKey:@"EMC_ID"];
    NSString *emcMsg           = [userInfo valueForKey:@"EMC_MSG"];
    NSString *code              = [userInfo valueForKey:@"CODE"];
    //NSString *message           = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
    //NSLog(@"GRP_CD: %@",    grpCd);
    NSLog(@"EMC_ID: %@",    emcId);
    NSLog(@"EMC_MSG: %@",   emcMsg);
    NSLog(@"CODE: %@",      code);
    
    //GRP_CD  = grpCd;
    EMC_ID  = emcId;
    EMC_MSG = emcMsg;
    CODE    = code;
    
    //메세지 왼쪽 정렬을 위한 코드 삽입
    
    
    
    UITextView *txtView = nil ;
    //
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 80.0)];
    [txtView setBackgroundColor:[UIColor clearColor]];
    [txtView setTextAlignment:NSTextAlignmentLeft] ;
    [txtView setEditable:NO];
    [txtView setFont:[UIFont fontWithName:@"Avenir-Black" size:15]];
    [txtView setText:emcMsg];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[재난상황발생]"
                                                    message:@"" delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:@"전화걸기", nil];
    
    [alert setValue:txtView forKey:@"accessoryView"];
    //[alert addSubview:txtView];
    [alert show] ;

    //./UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 24.0, 250.0, 80.0)];
    //label.numberOfLines = 0;
    //label.textAlignment = NSTextAlignmentLeft;
    //label.backgroundColor = [UIColor clearColor];
    //label.textColor = [UIColor whiteColor];
    //label.text = emcMsg;
   // [alert addSubview:label];
    
    
    
    //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"title" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //----------------------------------------------------------------------------------
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
    //                                                message:emcMsg delegate:self
    //                                      cancelButtonTitle:@"확인"
    //                                      otherButtonTitles:@"전화걸기", nil];
    
    
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    // OK 버튼을 눌렀을 때 버튼Index가 1로 들어감
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];

    if (buttonIndex == 1) {
        NSLog(@"Clicked YES");
        //NSString *string = [NSString stringWithFormat:@"tel://%@",@"01032198418"];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        
        CAllServer* res = [CAllServer alloc];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        
        
        
        [param setObject:EMC_ID             forKey:@"emc_id"];
        [param setObject:CODE            forKey:@"code"];
        [param setValue:idForVendor         forKey:@"deviceId"];
        [param setValue:@"C"                forKey:@"status"];
        
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
        [param2 setObject:EMC_ID            forKey:@"emc_id"];
       
        //param.put("emc_id", emcid);
      
        NSString* str2 = [res2 stringWithUrl:@"emcSenderInfo.do" VAL:param2];
        
        NSLog(@" %@",str2);
        
        NSData *jsonData2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error2;
        NSDictionary *jsonInfo2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:kNilOptions error:&error2];
        NSArray* keys2 = jsonInfo2.allKeys;
        
        //NSLog(@"keys cont %d",keys2.count);
        
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
                NSString *oriphone = [jsonInfo2 objectForKey:[keys2 objectAtIndex:i]];
                NSString *replaceString = [oriphone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSLog(@"hp::%@", replaceString);
                
                NSString *string = [NSString stringWithFormat:@"tel://%@",replaceString];
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
        [param setObject:EMC_ID             forKey:@"emc_id"];
        [param setObject:CODE            forKey:@"code"];
        [param setValue:@"S"                forKey:@"status"];
        [param setValue:idForVendor         forKey:@"deviceId"];
        //param.put("emc_id", emcid);
        //param.put("code", code);
        //param.put("hp", mobileNo);
        //param.put("status", "C");
        
        NSString* str = [res stringWithUrl:@"emcConfirm.do" VAL:param];
        
        NSLog(@" %@",str);
        
     //   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
      //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        exit(0);
    }
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
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
