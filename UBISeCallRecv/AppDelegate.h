//
//  AppDelegate.h
//  UBISeCallRecv
//
//  Created by youngseok Kim on 2015. 5. 3..
//  Copyright (c) 2015년 youngseok Kim. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *DEVICE_TOK;
    NSString *GRP_CD;
    NSString *EMC_ID;
    NSString *EMC_MSG;
    NSString *CODE;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *DEVICE_TOK;
@property (strong, nonatomic) NSString *GRP_CD;
@property (strong, nonatomic) NSString *EMC_ID;
@property (strong, nonatomic) NSString *EMC_MSG;
@property (strong, nonatomic) NSString *CODE;

@end

