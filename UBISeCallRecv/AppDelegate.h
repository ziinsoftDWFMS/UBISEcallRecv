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
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *DEVICE_TOK;
@end

