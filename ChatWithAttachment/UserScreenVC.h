//
//  UserScreenVC.h
//  ChatWithAttachment
//
//  Created by vibha on 7/6/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListTableViewCell.h"
#import <FirebaseCore/FirebaseCore.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "ChatScreenVC.h"
#import "ApplicationData.h"

@interface UserScreenVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    ApplicationData *objAppData;

    NSMutableArray *arrUserList;
    FIRDatabaseReference * ref;
    FIRDatabaseHandle _refHandle;
    NSMutableDictionary *mdata;
    NSString *strSelectedUserName,*strSelectedUserID,*strSelecteduserEmail;
}
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *userList;
@property NSString *strLoginEmail,*strLoginID;
@property (strong, nonatomic) FIRDatabaseReference *storageRef;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;
@property (weak, nonatomic) IBOutlet UITableView *tblUserlist;

@end
