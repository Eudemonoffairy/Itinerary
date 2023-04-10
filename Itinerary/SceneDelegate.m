//
//  SceneDelegate.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import "SceneDelegate.h"
#import "ZHTabbarViewController.h"
#import "ZHMapUtil.h"
#import "ZHPlace.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    //  初始化
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults valueForKey:FIRST_LOAD]){
        //  标记已经启动了 APP
        [defaults setValue:@"YES" forKey:FIRST_LOAD];
    }
    
//    ZHMapUtil *maputils = [ZHMapUtil sharedInstance];
//    [maputils searchPlace:@"B00140WBI1"];
    
    
    ZHTabbarViewController *defaultTabbar = ZHTabbarViewController.new;
    self.window.rootViewController = defaultTabbar;
    [self.window makeKeyAndVisible];
 
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
