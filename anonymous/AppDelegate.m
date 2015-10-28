//
//  AppDelegate.m
//  anonymous
//
//  Created by Zhongcai Ng on 28/10/15.
//  Copyright © 2015 Cloudilly Private Limited. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor= [UIColor clearColor];
    self.viewController= [[ViewController alloc] init];
    self.window.rootViewController= self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application { }
-(void)applicationDidEnterBackground:(UIApplication *)application { }
-(void)applicationWillEnterForeground:(UIApplication *)application { }
-(void)applicationDidBecomeActive:(UIApplication *)application { }
-(void)applicationWillTerminate:(UIApplication *)application { }

@end