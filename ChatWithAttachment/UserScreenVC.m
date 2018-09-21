//
//  UserScreenVC.m
//  ChatWithAttachment
//
//  Created by vibha on 7/6/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import "UserScreenVC.h"

@interface UserScreenVC ()

@end

@implementation UserScreenVC
@synthesize userList;
- (void)viewDidLoad {
    [super viewDidLoad];
    userList =[[NSMutableArray alloc]init];
    objAppData = [ApplicationData sharedInstance];
    [self configureDatabase];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self userlistmethod];
    });
    
}
- (void)userlistmethod{
    //NSLog(@"%@",userList);
    for (int i=0; i < userList.count; i++) {
                    
                    if ([[NSString stringWithFormat:@"%@",[[userList objectAtIndex:i].value valueForKey:@"user_email"]] isEqualToString:_strLoginEmail]) {
                        [userList removeObjectAtIndex:i];
                    }
                    else{
                       
                    }
      //  NSLog(@"%@",userList);
                }
    _tblUserlist.delegate = self;
    _tblUserlist.dataSource = self;
    [_tblUserlist reloadData];
}
- (void)dealloc {
    [[ref child:@"users"] removeObserverWithHandle:_refHandle];
}
- (void)configureRemoteConfig {
    _remoteConfig = [FIRRemoteConfig remoteConfig];
    
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
    self.remoteConfig.configSettings = remoteConfigSettings;
}
- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}
- (void)configureDatabase {
    ref = [[FIRDatabase database] reference];
    [objAppData showLoader];

    _refHandle = [[ref child:@"users"]  observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [userList addObject:snapshot];
        [objAppData hideLoader];

      //  [_tblUserlist reloadData];
        
//        for (int i=0; i < userList.count; i++) {
//            //NSMutableArray *temparr = [[NSMutableArray alloc]init];
//            if ([[snapshot.value valueForKey:@"user_email"] isEqualToString:_strLoginEmail]) {
//                [userList removeObjectAtIndex:i];
//            }
//            else{
//                //[temparr addObject:userList[i]];
//            }
//            
//        }
//        if([[snapshot.value valueForKey:@"user_email"] isEqualToString:_strLoginEmail])
//        {
//            [userList removeObject:[snapshot.value valueForKey:@"user_email"]];
//        }
    
    }];
    
    
    
}
#pragma mark - UITableView Datasource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserListTableViewCell"];
    if (cell == nil) {
        cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserListTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if([[NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_email"]] isEqualToString:_strLoginEmail])
//    {
//        [userList removeObjectAtIndex:indexPath.row];
//        cell.hidden = TRUE;
//    }
//    else{
       // cell.hidden = false;
        cell.lblEmail.text = [NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_email"]];
        cell.lblUsername.text = [NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_name"]];
        
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    strSelectedUserName = [NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_name"]];
    strSelectedUserID = [NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_id"]];
    
    strSelecteduserEmail = [NSString stringWithFormat:@"%@",[[userList objectAtIndex:indexPath.row ].value valueForKey:@"user_email"]];
    ChatScreenVC *objChatScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreenVC"];
    objChatScreenVC.strChatUser = strSelectedUserName;
    objChatScreenVC.strSelectedID = strSelectedUserID;
    objChatScreenVC.strLoginID = _strLoginID;
    objChatScreenVC.strLoginEmail = _strLoginEmail;

    objChatScreenVC.strSelectedEmail = strSelecteduserEmail;
    [self.navigationController pushViewController:objChatScreenVC animated:YES];
    
    
}





@end
