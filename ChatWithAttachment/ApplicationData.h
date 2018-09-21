//
//  ApplicationData.h
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#ifdef DEBUG
#define DebugLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define DebugLog(s, ...)
#endif
@interface ApplicationData : UIViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *hud;
    AppDelegate *objAppDel;
    

}
@property NSString *strSelectedLibrary;
@property BOOL SocialLoggedIn;
@property BOOL isAbout,isLoadedChatMenu,isNotification,isActive;
@property int chatIdNotification;
+ (id)sharedInstance;
- (void)showLoader;
- (void)hideLoader;
+ (BOOL)connectedToNetwork;
- (void)showLoaderIn:(UIView *)view;

//+(UIAlertController *)takeAndChoosePhoto:(UIViewController *)objViewController;
//+(UIAlertController *)ChooseMedia:(UIViewController *)objViewController;

@end
