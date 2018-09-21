//
//  ApplicationData.m
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import "ApplicationData.h"
#import "AppDelegate.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "UIView+Toast.h"

@implementation ApplicationData
+ (id)sharedInstance {
    static ApplicationData *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    if (self = [super init]) {
        _SocialLoggedIn = true;
        _isAbout = true;
        _chatIdNotification = -1;

        
    }
    return self;
}
- (void)showLoader {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
}
- (void)hideLoader{
    if([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [hud removeFromSuperview];
}
- (void)showLoaderIn:(UIView *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
}
//- (void)showLoader {
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    if(!hud) {
//        //[SlideNavigationController sharedInstance].enableSwipeGesture=NO;
//        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    }
//    else {
//        [[UIApplication sharedApplication].keyWindow addSubview:hud];
//    }
//    hud.mode = MBProgressHUDModeIndeterminate;
//    
//    
//    
//}
//
//- (void)hideLoader {
//    if([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    }
//    [hud removeFromSuperview];
//}
//
+ (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
    if (!isconnected) {
        [[(AppDelegate*) [UIApplication sharedApplication].delegate window] makeToast:@"Check Your Internet Connection"];
        [[self sharedInstance]hideLoader];
    }
    return isconnected;
}
//+(UIAlertController *)takeAndChoosePhoto:(UIViewController *)objViewController
//{
//    
//    UIAlertController* alert = [UIAlertController
//                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
//                                message:nil
//                                preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction* button0 = [UIAlertAction
//                              actionWithTitle:@"Cancel"
//                              style:UIAlertActionStyleCancel
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  UIAlertController will automatically dismiss the view
//                              }];
//    
//    UIAlertAction* button1 = [UIAlertAction
//                              actionWithTitle:@"Take photo"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                                      
//                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
//                                                                                      message:@"Device has no camera"
//                                                                                     delegate:self
//                                                                            cancelButtonTitle:@"OK"
//                                                                            otherButtonTitles:nil];
//                                      [alert show];
//                                      
//                                      
//                                  }
//                                  else{
//                                      
//                                      UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                      imagePickerController.allowsEditing = YES;
//                                      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//                                      imagePickerController.delegate = objViewController;
//                                      
//                                      [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                                  }
//                                  
//                              }];
//    
//    UIAlertAction* button2 = [UIAlertAction
//                              actionWithTitle:@"Choose Existing"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  The user tapped on "Choose existing"
//                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                  imagePickerController.allowsEditing = YES;
//                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                  imagePickerController.delegate = objViewController;
//                                  
//                                  [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                              }];
//    
//    [alert addAction:button0];
//    [alert addAction:button1];
//    [alert addAction:button2];
//    
//    return alert;
//}
//+(UIAlertController *)ChooseMedia:(UIViewController *)objViewController
//{
//    NSString *strSelectedLibrary;
//    UIAlertController* alert = [UIAlertController
//                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
//                                message:nil
//                                preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction* btnCancel = [UIAlertAction
//                              actionWithTitle:@"Cancel"
//                              style:UIAlertActionStyleCancel
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  UIAlertController will automatically dismiss the view
//                              }];
//    
//    UIAlertAction* btnCamera = [UIAlertAction
//                              actionWithTitle:@"Camera"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
//                                                                                      message:@"Device has no camera"
//                                                                                     delegate:self
//                                                                            cancelButtonTitle:@"OK"
//                                                                            otherButtonTitles:nil];
//                                      [alert show];
//                                      
//                                      
//                                  }
//                                  else{
//                                      
//                                      UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                      imagePickerController.allowsEditing = YES;
//                                      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//                                      imagePickerController.delegate = objViewController;
//                                      
//                                      [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                                  }
//                                  
//                              }];
//    
//    UIAlertAction* btnGalary = [UIAlertAction
//                              actionWithTitle:@"Photo Library"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  The user tapped on "Choose existing"
//                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                  imagePickerController.allowsEditing = YES;
//                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                  imagePickerController.delegate = objViewController;
//                                  
//                                  [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                              }];
//    UIAlertAction* btnLocation = [UIAlertAction
//                              actionWithTitle:@"Location"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  The user tapped on "Choose existing"
//                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                  imagePickerController.allowsEditing = YES;
//                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                  imagePickerController.delegate = objViewController;
//                                  
//                                  [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                              }];
//
//    UIAlertAction* btnAudio = [UIAlertAction
//                              actionWithTitle:@"Audio"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  The user tapped on "Choose existing"
//                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                  imagePickerController.allowsEditing = YES;
//                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                  imagePickerController.delegate = objViewController;
//                                  
//                                  [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                              }];
//
//    UIAlertAction* btnVideo = [UIAlertAction
//                              actionWithTitle:@"Video"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  //  The user tapped on "Choose existing"
//                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
//                                  imagePickerController.allowsEditing = YES;
//                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                  imagePickerController.delegate = objViewController;
//                                  
//                                  [objViewController presentViewController:imagePickerController animated:YES completion:^{}];
//                              }];
//    [alert addAction:btnCancel];
//    [alert addAction:btnCamera];
//    [alert addAction:btnGalary];
//    [alert addAction:btnAudio];
//    [alert addAction:btnVideo];
//    [alert addAction:btnLocation];
//    
//    return alert;
//}
//+ (BOOL)connectedToNetwork {
//    // Create zero addy
//    struct sockaddr_in zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sin_len = sizeof(zeroAddress);
//    zeroAddress.sin_family = AF_INET;
//
//    // Recover reachability flags
//    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
//    SCNetworkReachabilityFlags flags;
//
//    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
//    CFRelease(defaultRouteReachability);
//
//    if (!didRetrieveFlags)
//    {
//        printf("Error. Could not recover network reachability flags\n");
//        return 0;
//    }
//
//    BOOL isReachable = flags & kSCNetworkFlagsReachable;
//    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
//
//    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
//    if (!isconnected) {
//         [(AppDelegate*)[UIApplication sharedApplication].delegate window];
//
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//        {
//
//            [alert dismissViewControllerAnimated:YES completion:nil];
//
//        }];
//        [alert addAction:defaultAction];
//
//        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert;
//        [alertWindow makeKeyAndVisible];
//        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }
//    return isconnected;
//}
@end
