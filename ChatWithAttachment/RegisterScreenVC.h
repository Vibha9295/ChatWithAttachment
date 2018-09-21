//
//  RegisterVC.h
//  ChatWithAttachment
//
//  Created by vibha on 7/5/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginScreenVC.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <Firebase.h>
#import <FirebaseCore/FirebaseCore.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface RegisterScreenVC : UIViewController
{
    
    FIRDatabaseReference * ref;
    FIRDatabaseHandle _refHandle;
    NSMutableDictionary *mdata;
    NSString *userIDAuth,*emailAuth;
}
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *user;

@property (strong, nonatomic) FIRDatabaseReference *storageRef;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnRegister:(id)sender;
- (IBAction)btnSignIn:(id)sender;

@end
