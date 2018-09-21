//
//  ChatScreenVC.m
//  ChatWithAttachment
//
//  Created by vibha on 7/6/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import "ChatScreenVC.h"



@interface ChatScreenVC ()

@end

@implementation ChatScreenVC
@synthesize txtViewMsg,storageRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",_strChatUser];
    //[txtViewMsg scrollRangeToVisible:NSMakeRange(0, 4)];
    NSNotificationCenter   *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    txtViewMsg.delegate = self;
    // [txtViewMsg scrollRangeToVisible:NSMakeRange(0, 4)];
    [self configureStorage];
    arrContacts = [[NSMutableArray alloc]init];
    _tblViewChat.estimatedRowHeight = 280.0;
    _tblViewChat.rowHeight = UITableViewAutomaticDimension;
    _tblViewChat.contentInset = UIEdgeInsetsZero;
    
    
    _messages = [[NSMutableArray alloc] init];
    [_tblViewChat reloadData];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    ref = [[FIRDatabase database] reference];
    [self configureDatabase];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    msgViewFrame=_viewMessage.frame;
//    tmpFrame =txtViewMsg.frame;
//    tmpScrollFrame = _scrlView.frame;
//}

#pragma mark - Firebase Methods

- (void)dealloc {
    [[ref child:@"chat_data"] removeObserverWithHandle:_refHandle];
    //[[ref child:@"pictures"] removeObserverWithHandle:_refHandle];
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
    
    _refHandle = [[[[ref child:@"chat_data"] child:_strLoginID] child:[NSString stringWithFormat:@"%@",_strSelectedID]]  observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_messages addObject:snapshot];
        
        // [_tblViewChat insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
        
        [_tblViewChat reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count-1 inSection:0];
        [_tblViewChat scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
        
    }];
    
    
}

#pragma mark - Message Methods

//-(void)reloadChatData:(NSNotification *) notification
//{
//    //NSDictionary *userInfo = notification.userInfo;
//    //strID = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
//    //self.navigationItem.title = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"userName"]];
//    _messages = [[NSMutableArray alloc] init];
//    [_tblViewChat reloadData];
//    [self configureDatabase];
//}

- (void)sendMessage{
    ref = [[FIRDatabase database] reference];
    
    dicSender = [[NSMutableDictionary alloc]init];
    dicReceiver = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *myTime = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
    NSString *TimeString = [dateFormatter stringFromDate: myTime];
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
    //NSDate *myDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ddMMyyHHmmss"];
    //NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    //NSDate *startdates = [dateFormat dateFromString:prettyVersion];
    //NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"ddMMyyyy";
    
    
    [formatter setDateFormat:formatString];
    NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
    ;
    NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
    
    //sender dic
    [dicSender setValue:@"iOS" forKey:@"device_type"];
    [dicSender setValue:@"false" forKey:@"duplicate"];
    //    [dicSender setValue:_strLoginEmail forKey:@"sender_email"];
    //    [dicSender setValue:_strSelectedEmail forKey:@"receiver_email"];
    
    [dicSender setValue:@"" forKey:@"latitude"];
    [dicSender setValue:@"" forKey:@"longitude"];
    [dicSender setValue:@"" forKey:@"location"];
    
    [dicSender setValue:@"" forKey:@"contact_name"];
    [dicSender setValue:@"" forKey:@"contact_number"];
    
    [dicSender setValue:@"" forKey:@"file_path"];
    [dicSender setValue:@"" forKey:@"local_file_path"];
    [dicSender setValue:resultMsg forKey:@"msg"];
    [dicSender setValue:@"text" forKey:@"msg_type"];
    //[dicSender setValue:@"text" forKey:@"content_type"];
    
    [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
    [dicSender setValue:_strLoginID forKey:@"sender_id"];
    [dicSender setValue:@"send" forKey:@"type"];
    
    
    //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
    //NSString *dateString = [dateFormatter stringFromDate: myDate];
    //[dicSender setValue:dateString forKey:@"date"];
    [dicSender setValue:TimeString forKey:@"time"];
    [dicSender setValue:@"" forKey:@"token"];
    
    /// NSString *strSenderID = [NSString stringWithFormat:@"%@%@%@",_strLoginID,@"_",_strSelectedID];
    NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
    
    [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
    
    //receiver
    [dicReceiver setValue:@"iOS" forKey:@"device_type"];
    [dicReceiver setValue:@"false" forKey:@"duplicate"];
    //    [dicReceiver setValue:_strLoginEmail forKey:@"sender_email"];
    //
    //    [dicReceiver setValue:_strSelectedEmail forKey:@"receiver_email"];
    [dicReceiver setValue:@"" forKey:@"file_path"];
    [dicReceiver setValue:@"" forKey:@"local_file_path"];
    [dicReceiver setValue:@"" forKey:@"latitude"];
    [dicReceiver setValue:@"" forKey:@"longitude"];
    [dicReceiver setValue:@"" forKey:@"location"];
    [dicReceiver setValue:@"" forKey:@"contact_name"];
    [dicReceiver setValue:@"" forKey:@"contact_number"];
    [dicReceiver setValue:resultMsg forKey:@"msg"];
    [dicReceiver setValue:@"text" forKey:@"msg_type"];
    //[dicReceiver setValue:@"text" forKey:@"content_type"];
    
    [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
    [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
    [dicReceiver setValue:TimeString forKey:@"time"];
    [dicReceiver setValue:@"" forKey:@"token"];
    [dicReceiver setValue:@"receive" forKey:@"type"];
    
    // NSString *strReceiverID = [NSString stringWithFormat:@"%@%@%@",_strSelectedID,@"_",_strLoginID];
    [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
    
    
    
    txtViewMsg.text =@"";
    
}
- (void)sendImage

{
    ref = [[FIRDatabase database] reference];
    
    //    if (profileImage != nil)
    //    {
    NSString *imageID = [[NSUUID UUID] UUIDString];
    // NSString *imageName = [NSString stringWithFormat:@"photos/%@.jpg",imageID];
    NSString *imageName = [NSString stringWithFormat:@"photos/"];
    
    FIRStorageReference *profilePicRef = [[[[storageRef child:imageName]child:_strLoginID] child:_strSelectedID]child:[NSString stringWithFormat:@"%@.jpg",imageID]];
    
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
    
    [profilePicRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     {
         if (!error)
         {
             strProfileImageURL = metadata.downloadURL.absoluteString;
             NSMutableDictionary *dictimg = [NSMutableDictionary dictionary];
             
             [dictimg setObject:strProfileImageURL forKey:@"Name"];
             
             //[[[[ref child:@"pictures"] child: _strLoginID]child:_strSelectedID]updateChildValues:dictimg];
             
             
             dicSender = [[NSMutableDictionary alloc]init];
             dicReceiver = [[NSMutableDictionary alloc]init];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             NSDate *myTime = [[NSDate alloc] init];
             [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
             NSString *TimeString = [dateFormatter stringFromDate: myTime];
             
             double timestamp = [[NSDate date] timeIntervalSince1970];
             int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
             //NSDate *myDate = [[NSDate alloc] init];
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"ddMMyyHHmmss"];
             // NSString *prettyVersion = [dateFormat stringFromDate:myDate];
             //NSDate *startdates = [dateFormat dateFromString:prettyVersion];
             //NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
             NSDate* now = [NSDate date];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             NSString *formatString = @"ddMMyyyy";
             
             
             [formatter setDateFormat:formatString];
             NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
             ;
             NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
             
             //sender dic
             [dicSender setValue:@"iOS" forKey:@"device_type"];
             [dicSender setValue:false forKey:@"duplicate"];
             [dicSender setValue:@"" forKey:@"file_path"];
             [dicSender setValue:@"" forKey:@"local_file_path"];
             [dicSender setValue:@"" forKey:@"latitude"];
             [dicSender setValue:@"" forKey:@"longitude"];
             [dicSender setValue:@"" forKey:@"location"];
             [dicSender setValue:@"" forKey:@"contact_name"];
             [dicSender setValue:@"" forKey:@"contact_number"];
             
             [dicSender setValue:strProfileImageURL forKey:@"msg"];
             [dicSender setValue:@"image" forKey:@"msg_type"];
             //[dicSender setValue:@"image" forKey:@"content_type"];
             [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
             [dicSender setValue:_strLoginID forKey:@"sender_id"];
             [dicSender setValue:@"send" forKey:@"type"];
             
             
             //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
             //NSString *dateString = [dateFormatter stringFromDate: myDate];
             //[dicSender setValue:dateString forKey:@"date"];
             [dicSender setValue:TimeString forKey:@"time"];
             [dicSender setValue:@"" forKey:@"token"];
             
             NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
             
             [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
             
             //receiver
             [dicReceiver setValue:@"iOS" forKey:@"device_type"];
             [dicReceiver setValue:false forKey:@"duplicate"];
             [dicReceiver setValue:@"" forKey:@"file_path"];
             [dicReceiver setValue:@"" forKey:@"local_file_path"];
             [dicReceiver setValue:@"" forKey:@"latitude"];
             [dicReceiver setValue:@"" forKey:@"longitude"];
             [dicReceiver setValue:@"" forKey:@"location"];
             [dicReceiver setValue:@"" forKey:@"contact_name"];
             [dicReceiver setValue:@"" forKey:@"contact_number"];
             [dicReceiver setValue:strProfileImageURL forKey:@"msg"];
             [dicReceiver setValue:@"image" forKey:@"msg_type"];
             //[dicReceiver setValue:@"image" forKey:@"content_type"];
             
             [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
             [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
             [dicReceiver setValue:TimeString forKey:@"time"];
             [dicReceiver setValue:@"" forKey:@"token"];
             [dicReceiver setValue:@"receive" forKey:@"type"];
             
             //NSString *strReceiverID = [NSString stringWithFormat:@"%@%@%@",_strSelectedID,@"_",_strLoginID];
             [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
             
             
             
             txtViewMsg.text =@"";
             
         }
         else if (error)
         {
             //NSLog(@"Fail");
         }
     }];
    
    
}
-(void)sendVideo{
    
    
    
    
    ref = [[FIRDatabase database] reference];
    
    NSString *videoId = [[NSUUID UUID] UUIDString];
    // NSString *videoName = [NSString stringWithFormat:@"video/%@.mp4",videoId];
    NSString *videoName = [NSString stringWithFormat:@"videos/"];
    
    FIRStorageReference *videoRef = [[[[storageRef child:videoName]child:_strLoginID] child:_strSelectedID]child:[NSString stringWithFormat:@"%@.jpg",videoId]];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"video/mp4";
    
    
    [videoRef putFile:videoUrl metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     {
         if (!error)
         {
             strVideoPath = metadata.downloadURL.absoluteString;
             
             NSMutableDictionary *dictimg = [NSMutableDictionary dictionary];
             
             [dictimg setObject:strVideoPath forKey:@"Name"];
             
             
             //[[[[ref child:@"videos"]child: _strLoginID]child:_strSelectedID]updateChildValues:dictimg];
             
             
             
             dicSender = [[NSMutableDictionary alloc]init];
             dicReceiver = [[NSMutableDictionary alloc]init];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             NSDate *myTime = [[NSDate alloc] init];
             [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
             NSString *TimeString = [dateFormatter stringFromDate: myTime];
             
             double timestamp = [[NSDate date] timeIntervalSince1970];
             int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
             //  NSDate *myDate = [[NSDate alloc] init];
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"ddMMyyHHmmss"];
             //NSString *prettyVersion = [dateFormat stringFromDate:myDate];
             // NSDate *startdates = [dateFormat dateFromString:prettyVersion];
             // NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
             NSDate* now = [NSDate date];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             NSString *formatString = @"ddMMyyyy";
             
             
             [formatter setDateFormat:formatString];
             NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
             ;
             NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
             
             //sender dic
             [dicSender setValue:@"iOS" forKey:@"device_type"];
             [dicSender setValue:false forKey:@"duplicate"];
             [dicSender setValue:@"" forKey:@"file_path"];
             [dicSender setValue:@"" forKey:@"local_file_path"];
             [dicSender setValue:@"" forKey:@"latitude"];
             [dicSender setValue:@"" forKey:@"longitude"];
             [dicSender setValue:@"" forKey:@"location"];
             [dicSender setValue:@"" forKey:@"contact_name"];
             [dicSender setValue:@"" forKey:@"contact_number"];
             [dicSender setValue:strVideoPath forKey:@"msg"];
             [dicSender setValue:@"video" forKey:@"msg_type"];
             //[dicSender setValue:@"video" forKey:@"content_type"];
             
             [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
             [dicSender setValue:_strLoginID forKey:@"sender_id"];
             [dicSender setValue:@"send" forKey:@"type"];
             
             
             //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
             //NSString *dateString = [dateFormatter stringFromDate: myDate];
             //[dicSender setValue:dateString forKey:@"date"];
             [dicSender setValue:TimeString forKey:@"time"];
             [dicSender setValue:@"" forKey:@"token"];
             
             NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
             
             [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
             
             //receiver
             [dicReceiver setValue:@"iOS" forKey:@"device_type"];
             [dicReceiver setValue:false forKey:@"duplicate"];
             [dicReceiver setValue:@"" forKey:@"file_path"];
             [dicReceiver setValue:@"" forKey:@"local_file_path"];
             [dicReceiver setValue:@"" forKey:@"latitude"];
             [dicReceiver setValue:@"" forKey:@"longitude"];
             [dicReceiver setValue:@"" forKey:@"location"];
             [dicReceiver setValue:@"" forKey:@"contact_name"];
             [dicReceiver setValue:@"" forKey:@"contact_number"];
             [dicReceiver setValue:strVideoPath forKey:@"msg"];
             [dicReceiver setValue:@"video" forKey:@"msg_type"];
             //[dicReceiver setValue:@"video" forKey:@"content_type"];
             
             [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
             [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
             [dicReceiver setValue:TimeString forKey:@"time"];
             [dicReceiver setValue:@"" forKey:@"token"];
             [dicReceiver setValue:@"receive" forKey:@"type"];
             
             //NSString *strReceiverID = [NSString stringWithFormat:@"%@%@%@",_strSelectedID,@"_",_strLoginID];
             [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
             
             
             
             txtViewMsg.text =@"";
             
         }
         else if (error)
         {
             // NSLog(@"Fail");
         }
     }];
}
-(void)sendContact{
    ref = [[FIRDatabase database] reference];
    
    dicSender = [[NSMutableDictionary alloc]init];
    dicReceiver = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *myTime = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
    NSString *TimeString = [dateFormatter stringFromDate: myTime];
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
    //NSDate *myDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ddMMyyHHmmss"];
    //NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    //NSDate *startdates = [dateFormat dateFromString:prettyVersion];
    //NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"ddMMyyyy";
    
    
    [formatter setDateFormat:formatString];
    NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
    ;
    NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
    
    //sender dic
    
    [dicSender setValue:@"iOS" forKey:@"device_type"];
    [dicSender setValue:false forKey:@"duplicate"];
    [dicSender setValue:@"" forKey:@"file_path"];
    [dicSender setValue:@"" forKey:@"local_file_path"];    [dicSender setValue:@"" forKey:@"latitude"];
    [dicSender setValue:@"" forKey:@"longitude"];
    [dicSender setValue:@"" forKey:@"location"];
    [dicSender setValue:strPhoneName forKey:@"contact_name"];
    [dicSender setValue:arrPhone forKey:@"contact_number"];
    
    //[dicSender setValue:@"" forKey:@"contact_number"];
    [dicSender setValue:@"" forKey:@"msg"];
    [dicSender setValue:@"contact" forKey:@"msg_type"];
    //[dicSender setValue:@"text" forKey:@"content_type"];
    
    [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
    [dicSender setValue:_strLoginID forKey:@"sender_id"];
    [dicSender setValue:@"send" forKey:@"type"];
    
    
    //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
    //NSString *dateString = [dateFormatter stringFromDate: myDate];
    //[dicSender setValue:dateString forKey:@"date"];
    [dicSender setValue:TimeString forKey:@"time"];
    [dicSender setValue:@"" forKey:@"token"];
    
    /// NSString *strSenderID = [NSString stringWithFormat:@"%@%@%@",_strLoginID,@"_",_strSelectedID];
    NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
    
    [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
    
    //receiver
    
    
    [dicReceiver setValue:@"iOS" forKey:@"device_type"];
    [dicReceiver setValue:false forKey:@"duplicate"];
    [dicReceiver setValue:@"" forKey:@"file_path"];
    [dicReceiver setValue:@"" forKey:@"local_file_path"];
    [dicReceiver setValue:@"" forKey:@"latitude"];
    [dicReceiver setValue:@"" forKey:@"longitude"];
    [dicReceiver setValue:@"" forKey:@"location"];
    [dicReceiver setValue:strPhoneName forKey:@"contact_name"];
    [dicReceiver setValue:arrPhone forKey:@"contact_number"];
    [dicReceiver setValue:@"" forKey:@"msg"];
    [dicReceiver setValue:@"contact" forKey:@"msg_type"];
    //[dicReceiver setValue:@"text" forKey:@"content_type"];
    
    [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
    [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
    [dicReceiver setValue:TimeString forKey:@"time"];
    [dicReceiver setValue:@"" forKey:@"token"];
    [dicReceiver setValue:@"receive" forKey:@"type"];
    
    // NSString *strReceiverID = [NSString stringWithFormat:@"%@%@%@",_strSelectedID,@"_",_strLoginID];
    [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
    _tblViewContact.hidden = true;
    //_tblViewChat.hidden = false;
}
-(void)sendLocation{
    ref = [[FIRDatabase database] reference];
    
    dicSender = [[NSMutableDictionary alloc]init];
    dicReceiver = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *myTime = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
    NSString *TimeString = [dateFormatter stringFromDate: myTime];
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
    //NSDate *myDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ddMMyyHHmmss"];
    // NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    // NSDate *startdates = [dateFormat dateFromString:prettyVersion];
    //NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"ddMMyyyy";
    
    
    [formatter setDateFormat:formatString];
    NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
    ;
    NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
    
    //sender dic
    
    [dicSender setValue:@"iOS" forKey:@"device_type"];
    [dicSender setValue:false forKey:@"duplicate"];
    [dicSender setValue:@"" forKey:@"file_path"];
    [dicSender setValue:@"" forKey:@"local_file_path"];
    [dicSender setValue:strLat forKey:@"latitude"];
    [dicSender setValue:strLong forKey:@"longitude"];
    [dicSender setValue:@"" forKey:@"location"];
    [dicSender setValue:@"" forKey:@"contact_name"];
    [dicSender setValue:@"" forKey:@"contact_number"];
    [dicSender setValue:@"" forKey:@"msg"];
    [dicSender setValue:@"location" forKey:@"msg_type"];
    //[dicSender setValue:@"location" forKey:@"content_type"];
    
    [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
    [dicSender setValue:_strLoginID forKey:@"sender_id"];
    [dicSender setValue:@"send" forKey:@"type"];
    
    
    //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
    //NSString *dateString = [dateFormatter stringFromDate: myDate];
    //[dicSender setValue:dateString forKey:@"date"];
    [dicSender setValue:TimeString forKey:@"time"];
    [dicSender setValue:@"" forKey:@"token"];
    
    //NSString *strSenderID = [NSString stringWithFormat:@"%@%@%@",_strLoginID,@"_",_strSelectedID];
    NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
    
    [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
    
    //receiver
    [dicReceiver setValue:@"iOS" forKey:@"device_type"];
    [dicReceiver setValue:false forKey:@"duplicate"];
    [dicReceiver setValue:@"" forKey:@"file_path"];
    [dicReceiver setValue:@"" forKey:@"local_file_path"];
    [dicReceiver setValue:strLat forKey:@"latitude"];
    [dicReceiver setValue:strLong forKey:@"longitude"];
    [dicReceiver setValue:@"" forKey:@"location"];
    [dicReceiver setValue:@"" forKey:@"contact_name"];
    [dicReceiver setValue:@"" forKey:@"contact_number"];
    [dicReceiver setValue:@"" forKey:@"msg"];
    [dicReceiver setValue:@"location" forKey:@"msg_type"];
    //[dicSender setValue:@"location" forKey:@"content_type"];
    
    [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
    [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
    [dicReceiver setValue:TimeString forKey:@"time"];
    [dicReceiver setValue:@"" forKey:@"token"];
    [dicReceiver setValue:@"receive" forKey:@"type"];
    
    
    [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
    
    // _imgview.image = [UIImage imageWithData:dataMap];
    
    //    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    //    options.region = self.mapView.region;
    //    options.scale = [UIScreen mainScreen].scale;
    //    options.size = self.mapView.frame.size;
    //
    //    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    //    [snapshotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
    //
    //        // get the image associated with the snapshot
    //
    //        UIImage *image = snapshot.image;
    //
    //
    //        // Get the size of the final image
    //
    //        CGRect finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    //
    //        // Get a standard annotation view pin. Clearly, Apple assumes that we'll only want to draw standard annotation pins!
    //
    //        MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
    //        UIImage *pinImage = pin.image;
    //
    //        // ok, let's start to create our final image
    //
    //        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    //
    //        // first, draw the image from the snapshotter
    //
    //        [image drawAtPoint:CGPointMake(0, 0)];
    //
    //        // now, let's iterate through the annotations and draw them, too
    //
    //        for (id<MKAnnotation>annotation in self.mapView.annotations)
    //        {
    //            CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
    //            if (CGRectContainsPoint(finalImageRect, point)) // this is too conservative, but you get the idea
    //            {
    //                CGPoint pinCenterOffset = pin.centerOffset;
    //                point.x -= pin.bounds.size.width / 2.0;
    //                point.y -= pin.bounds.size.height / 2.0;
    //                point.x += pinCenterOffset.x;
    //                point.y += pinCenterOffset.y;
    //
    //                [pinImage drawAtPoint:point];
    //            }
    //        }
    //
    //        // grab the final image
    //
    //        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //
    //        // and save it
    //
    //        dataMap = UIImagePNGRepresentation(finalImage);
    //
    //        //[data writeToFile:[self snapshotFilename] atomically:YES];
    //    }];
    
}
-(void)sendAudio{
    
    
    ref = [[FIRDatabase database] reference];
    NSString *audioId = [[NSUUID UUID] UUIDString];
    NSString *audioName = [NSString stringWithFormat:@"audios/"];
    FIRStorageReference *audioRef = [[[[storageRef child:audioName]child:_strLoginID] child:_strSelectedID]child:[NSString stringWithFormat:@"%@.WAV",audioId]];
    
    //FIRStorageReference *audioRef = [storageRef child:audioName];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"audio/WAV";
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:audioRecorder.url
                   error:&error];
    //NSLog(@"%@",audioPlayer.url);
    strAudioPath = [audioPlayer.url path];
    
    [audioRef putFile:audioPlayer.url metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     
     
     //[videoRef putFile:videoUrl metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     {
         if (!error)
         {
             
             
             //[dictimg setObject:audioPath forKey:@"Name"];
             
             
             //[[ref child:@"audio"]updateChildValues:dictimg];
             
             strAudioPath = metadata.downloadURL.absoluteString;
             
             NSMutableDictionary *dictimg = [NSMutableDictionary dictionary];
             
             [dictimg setObject:strAudioPath forKey:@"Name"];
             
             
             //[[[[ref child:@"audio"]child: _strLoginID]child:_strSelectedID]updateChildValues:dictimg];
             
             
             
             dicSender = [[NSMutableDictionary alloc]init];
             dicReceiver = [[NSMutableDictionary alloc]init];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             NSDate *myTime = [[NSDate alloc] init];
             [dateFormatter setDateFormat:@"HH:mm:ss"];  //20160217 13:14:22
             NSString *TimeString = [dateFormatter stringFromDate: myTime];
             
             double timestamp = [[NSDate date] timeIntervalSince1970];
             int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
             //  NSDate *myDate = [[NSDate alloc] init];
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"ddMMyyHHmmss"];
             //NSString *prettyVersion = [dateFormat stringFromDate:myDate];
             // NSDate *startdates = [dateFormat dateFromString:prettyVersion];
             // NSString *timeUser = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startdates]];
             NSDate* now = [NSDate date];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             NSString *formatString = @"ddMMyyyy";
             
             
             [formatter setDateFormat:formatString];
             NSString *date =[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]]
             ;
             NSString *strTime = [NSString stringWithFormat:@"%lld",timeInMilisInt64];
             
             //sender dic
             [dicSender setValue:@"iOS" forKey:@"device_type"];
             [dicSender setValue:false forKey:@"duplicate"];
             [dicSender setValue:@"" forKey:@"file_path"];
             [dicSender setValue:@"" forKey:@"local_file_path"];
             [dicSender setValue:@"" forKey:@"latitude"];
             [dicSender setValue:@"" forKey:@"longitude"];
             [dicSender setValue:@"" forKey:@"location"];
             [dicSender setValue:@"" forKey:@"contact_name"];
             [dicSender setValue:@"" forKey:@"contact_number"];
             [dicSender setValue:strAudioPath forKey:@"msg"];
             [dicSender setValue:@"audio" forKey:@"msg_type"];
             //[dicSender setValue:@"audio" forKey:@"content_type"];
             
             [dicSender setValue:_strSelectedID forKey:@"receiver_id"];
             [dicSender setValue:_strLoginID forKey:@"sender_id"];
             [dicSender setValue:@"send" forKey:@"type"];
             
             
             //[dateFormatter setDateFormat:@"dd/mm/yyyy"];  //20160217 13:14:22
             //NSString *dateString = [dateFormatter stringFromDate: myDate];
             //[dicSender setValue:dateString forKey:@"date"];
             [dicSender setValue:TimeString forKey:@"time"];
             [dicSender setValue:@"" forKey:@"token"];
             
             NSString *strSendingTime =[NSString stringWithFormat:@"%@%@",date,strTime];
             
             [[[[[ref child:@"chat_data"] child: _strLoginID]child:_strSelectedID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicSender];
             
             //receiver
             [dicReceiver setValue:@"iOS" forKey:@"device_type"];
             [dicReceiver setValue:false forKey:@"duplicate"];
             [dicReceiver setValue:@"" forKey:@"file_path"];
             [dicReceiver setValue:@"" forKey:@"local_file_path"];
             [dicReceiver setValue:@"" forKey:@"latitude"];
             [dicReceiver setValue:@"" forKey:@"longitude"];
             [dicReceiver setValue:@"" forKey:@"location"];
             [dicReceiver setValue:@"" forKey:@"contact_name"];
             [dicReceiver setValue:@"" forKey:@"contact_number"];
             [dicReceiver setValue:strAudioPath forKey:@"msg"];
             [dicReceiver setValue:@"audio" forKey:@"msg_type"];
             //[dicReceiver setValue:@"audio" forKey:@"content_type"];
             
             [dicReceiver setValue:_strSelectedID forKey:@"receiver_id"];
             [dicReceiver setValue:_strLoginID forKey:@"sender_id"];
             [dicReceiver setValue:TimeString forKey:@"time"];
             [dicReceiver setValue:@"" forKey:@"token"];
             [dicReceiver setValue:@"receive" forKey:@"type"];
             
             //NSString *strReceiverID = [NSString stringWithFormat:@"%@%@%@",_strSelectedID,@"_",_strLoginID];
             [[[[[ref child:@"chat_data"] child: _strSelectedID]child:_strLoginID] child:[NSString stringWithFormat:@"%@",strSendingTime]] updateChildValues:dicReceiver];
             
             
             
             txtViewMsg.text =@"";
             
         }
         else if (error)
         {
             NSLog(@"Fail");
         }
     }];
    
}

#pragma mark - Location methods
//-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
//    _tblViewChat.hidden = true;
//    _viewMessage.hidden = true;
//
//
//
//    NSString *strLatMap = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath123.row].value valueForKey:@"longitude"]];
//
//                           //[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"latitude"]]
//    _mapView.hidden = false;
//    //[self loadMapView];
//
//}
- (void) loadUserLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [locationManager stopUpdatingLocation];
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    // NSLog(@"Error: %@",error.description);
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations  {
    CLLocation *newLocation = [locations objectAtIndex:0];
    latitude_UserLocation = newLocation.coordinate.latitude;
    longitude_UserLocation = newLocation.coordinate.longitude;
    strLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    strLong = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [self loadMapView];
    
    
}

- (void) loadMapView
{
    if(isSelectMap){
        
        double Doublelat = [strMapLat doubleValue];
        double Doublelong = [strMapLong doubleValue];
        
        CLLocationCoordinate2D objCoor2D = {.latitude =  Doublelat, .longitude =  Doublelong};
        MKCoordinateSpan objCoorSpan = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
        MKCoordinateRegion objMapRegion = {objCoor2D, objCoorSpan};
        [_mapView setRegion:objMapRegion];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:objCoor2D];
        [annotation setTitle:@"Title"]; //You can set the subtitle too
        [self.mapView addAnnotation:annotation];
        isSelectMap = false;
    }
    else{
        CLLocationCoordinate2D objCoor2D = {.latitude =  latitude_UserLocation, .longitude =  longitude_UserLocation};
        MKCoordinateSpan objCoorSpan = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
        MKCoordinateRegion objMapRegion = {objCoor2D, objCoorSpan};
        [_mapView setRegion:objMapRegion];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:objCoor2D];
        [annotation setTitle:@"Title"]; //You can set the subtitle too
        [self.mapView addAnnotation:annotation];
    }
    
    
    
    
    
    
}
#pragma mark - Share audio delegates

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //_btnRecordOut.enabled = YES;
    //_btnStopOut.enabled = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    //NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    // NSLog(@"Encode Error occurred");
}
- (void)itemDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero];
}

#pragma mark - keyboard methods

-(void)noticeShowKeyboard:(NSNotification *)inNotification {
    NSDictionary* info = [inNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = tmpScrollFrame;
    aRect.size.height -= kbSize.height ;
    _scrlView.frame =aRect;
    
}
-(void)noticeHideKeyboard:(NSNotification *)inNotification {
    NSDictionary* info = [inNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = _scrlView.frame;
    aRect.size.height += kbSize.height;
    
    _scrlView.frame =aRect;
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    if (_messages.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count-1 inSection:0];
        [_tblViewChat scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
    }
    //   });
    
}


- (void)textViewDidChange:(UITextView *)textView {
    // Enable and disable lblPlaceHolderText
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    //    if (txtViewMsg.frame.size.height < 100)
    //    {
    //        [_tblViewChat setFrame:CGRectMake(0, _tblViewChat.frame.origin.y  , _tblViewChat.frame.size.width, _tblViewChat.frame.size.height-(newFrame.size.height - textView.frame.size.height))];
    //        [txtViewMsg setFrame:CGRectMake(_btnAttachment.frame.size.width, txtViewMsg.frame.origin.y - (newFrame.size.height - textView.frame.size.height) , txtViewMsg.frame.size.width, txtViewMsg.frame.size.height+(newFrame.size.height - textView.frame.size.height))];
    //
    //
    //    }
    //    else if (tmpFrame.size.height > newFrame.size.height)
    //    {
    //        [txtViewMsg setFrame:CGRectMake(_btnAttachment.frame.size.width, txtViewMsg.frame.origin.y - (newFrame.size.height - textView.frame.size.height) , txtViewMsg.frame.size.width, txtViewMsg.frame.size.height+(newFrame.size.height - textView.frame.size.height))];
    //        [_tblViewChat setFrame:CGRectMake(0, _tblViewChat.frame.origin.y  , _tblViewChat.frame.size.width, _tblViewChat.frame.size.height-(newFrame.size.height - textView.frame.size.height))];
    //
    //    }
    if (_messages.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count-1 inSection:0];
        [_tblViewChat scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
    }
    // tmpFrame = txtViewMsg.frame;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView Datasource/Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView == _tblViewContact){
        static NSString *cellIdentifier = @"ContactTableViewCell";
        
        ContactTableViewCell *cell = (ContactTableViewCell *)[_tblViewContact dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.lblName.text = [[arrContacts valueForKey:@"name"]objectAtIndex:indexPath.row];
        arrPhone = [[arrContacts valueForKey:@"phone"]objectAtIndex:indexPath.row];
        NSString *strPhone = [NSString stringWithFormat:@"%@",[arrPhone objectAtIndex:0]];
        cell.lblNumber.text = strPhone;
        return cell;
    }
    else{
        
        NSString *cellId;
        
        if ([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"type"]] isEqualToString:@"send"])
        {
            
            if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"text"]){
                
                cellId = @"SenderMsg";
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"audio"]){
                
                cellId = @"SenderMsg";
            }
            else if ([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"contact"])
            {
                cellId = @"SendContact";
            }
            else{
                cellId = @"senderView";
            }
        }
        else{
            if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"text"]){
                
                cellId = @"ReceiverMsg";
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"audio"]){
                
                cellId = @"ReceiverMsg";
            }
            
            else if ([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"contact"])
            {
                cellId = @"ReceivedContact";
            }
            else{
                cellId = @"recieverView";
            }
        }
        
        ChatTableViewCell *cell = (ChatTableViewCell *)[_tblViewChat dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        //        if (cell == nil)
        //        {
        //            cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        //        }
        if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"type"]] isEqualToString:@"send"])
        {
            
            if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"text"]){
                
                cell.lblSenderMsg.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]];
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"audio"]){
                
                cell.lblSenderMsg.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]];
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"contact"])
            {
                
                cell.lblSenderName.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"contact_name"]];
                
                NSMutableArray *arrContact = [[NSMutableArray alloc]init];
                
                
                arrContact = [[_messages objectAtIndex:indexPath.row ].value valueForKey:@"contact_number"];
                // NSLog(@"%@",arrContact);
                
                cell.lblSenderNumber.text = [arrContact objectAtIndex:0];
                
                
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"image"])
            {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    
                    
                    imgGetUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
                    [cell.imgSender sd_setImageWithURL:imgGetUrl placeholderImage:nil];
                    
                });
            }
            
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"video"]){
                
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    videoGetUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
                    //                    AVAsset *asset = [AVAsset assetWithURL:url];
                    //                    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                    //
                    //                    int frameTimeStart = 3;
                    //                    int frameLocation = 1;
                    //
                    //                    CGImageRef frameRef = [generator copyCGImageAtTime:CMTimeMake(frameTimeStart,frameLocation) actualTime:nil error:nil];
                    //                    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:frameRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
                    //                   // return thumbnail;
                    //                    [cell.imgSender sd_setImageWithURL:url placeholderImage:thumbnail];
                    // videoURL = [NSURL fileURLWithPath:moviePath];
                    //attachmentImage = [self generateThumbImage:videoURL];
                    
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoGetUrl options:nil];
                    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    generateImg.appliesPreferredTrackTransform = YES;
                    NSError *error = NULL;
                    CMTime duration = asset.duration;
                    CGFloat durationInSeconds = duration.value / duration.timescale;
                    CMTime time = CMTimeMakeWithSeconds(durationInSeconds * .5 , (int)duration.value);
                    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
                    //   NSLog(@"error==%@, Refimage==%@", error, refImg);
                    
                    UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
                    
                    [cell.imgSender sd_setImageWithURL:videoGetUrl placeholderImage:FrameImage];
                    cell.imgViewPlaySender.hidden = false;
                });
            }
            else{
                
                
                
                // NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current+Location&daddr=%@,%@",strlat, strlong];
                
                NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&markers=size:mid|color:red|label:E|%@,%@&size=300x300&sensor=false",[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"latitude"]], [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"longitude"]],[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"latitude"]], [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"longitude"]]];
                
                
                url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                // url = [NSURL URLWithString:urlString];
                
                
                
                [cell.imgSender sd_setImageWithURL:url placeholderImage:nil];
            }
            
        }
        
        
        else{
            
            
            if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"text"]){
                
                cell.lblReceiverMsg.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]];
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"audio"]){
                
                cell.lblReceiverMsg.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]];
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"contact"])
            {
                
                cell.lblReceivedName.text = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"contact_name"]];
                
                NSMutableArray *arrContact = [[NSMutableArray alloc]init];
                
                
                arrContact = [[_messages objectAtIndex:indexPath.row ].value valueForKey:@"contact_number"];
                //  NSLog(@"%@",arrContact);
                
                cell.lblReceivedNumber.text = [arrContact objectAtIndex:0];
                
            }
            
            
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"image"])
            {
                
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    imgGetUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
                    
                    
                    [cell.imgReceiver sd_setImageWithURL:imgGetUrl placeholderImage:nil];
                });
                
            }
            else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"video"]){
                
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    videoGetUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
                    
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoGetUrl options:nil];
                    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    NSError *err1 = NULL;
                    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
                    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err1];
                    
                    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
                    //NSLog(@"Log Image to get rid of warning. thumbnailImage = %@", thumbnailImage);
                    [cell.imgReceiver sd_setImageWithURL:videoGetUrl placeholderImage:thumbnailImage];
                    cell.imgViewPlayReceiver.hidden = false;
                });
            }
            else{
                NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&markers=size:mid|color:red|label:E|%@,%@&size=300x300&sensor=false",[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"latitude"]], [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"longitude"]],[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"latitude"]], [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"longitude"]]];
                // url = [NSURL URLWithString:urlString];
                
                url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                // url = [NSURL URLWithString:urlString];
                
                
                
                //[cell.imgSender sd_setImageWithURL:url placeholderImage:nil];
                
                //                    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                //  cell.imgReceiver.userInteractionEnabled = true;
                // [cell.imgReceiver addGestureRecognizer:singleTapGestureRecognizer];
                [cell.imgReceiver sd_setImageWithURL:url placeholderImage:nil];
            }
            
            
        }
        return cell;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tblViewContact){
        
        return [arrContacts count];
    }else{
        return [_messages count];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tblViewContact)
        
    {
        strPhoneName = [NSString stringWithFormat:@"%@",[[arrContacts valueForKey:@"name"]objectAtIndex:indexPath.row]];
        arrPhone = [[arrContacts valueForKey:@"phone"]objectAtIndex:indexPath.row];
        
        //NSString *strImage = [NSString stringWithFormat:@"%@",[[arrContacts valueForKey:@"image"]objectAtIndex:indexPath.row]];
        
        [self sendContact];
        
        
        
    }
    else{
        
        if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"audio"])
        {
            NSURL *urlAudio = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
            
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = [AVPlayer playerWithURL:urlAudio];;
            [controller.player play];
            //[[UIApplication sharedApplication]openURL:urlAudio];
            
            
        }
        else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"image"])
        {
            
            NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
            
            
            [[UIApplication sharedApplication]openURL:urlImg];
            
        }
        else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"video"]){
            
            
            NSURL *urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg"]]];
            // [[UIApplication sharedApplication]openURL:urlVideo];
            AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = [AVPlayer playerWithURL:urlVideo];;
            [controller.player play];
        }
        else if([[NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]] isEqualToString:@"location"]){
            
            
            isSelectMap = true;
            // _tblViewChat.hidden = true;
            _viewMessage.hidden = true;
            
            
            strMapLat = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row].value valueForKey:@"latitude"]];
            strMapLong = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row].value valueForKey:@"longitude"]];
            
            
            _mapView.hidden = false;
            
            
            UIBarButtonItem *BackButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"< Back"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(BackAction:)];
            self.navigationItem.leftBarButtonItem = BackButton;
            [self loadMapView];
            
        }
        
        
    }
    
}
-(void)BackAction:(id)sender
{
    _mapView.hidden = true;
    _tblViewChat.hidden = false;
    _viewMessage.hidden = false;
    
    UIBarButtonItem *BackButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"< User"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(UserBackAction:)];
    self.navigationItem.leftBarButtonItem = BackButton;
    
}
-(void)UserBackAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tblViewContact){
        NSString *str = [NSString stringWithFormat:@"%@",[[arrContacts valueForKey:@"name"]objectAtIndex:indexPath.row]];
        CGSize size;
        size = [self getSizeOfString:str];
        return size.height + 70;
    }
    else{
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[[_messages objectAtIndex:indexPath.row ].value valueForKey:@"msg_type"]];
        
        if([str isEqualToString:@"text"]){
            
            return UITableViewAutomaticDimension;
            //            CGSize size;
            //            size = [self getSizeOfString:str];
            //            return size.height + 30;
        }
        else if([str isEqualToString:@"contact"]){
            return 90;
            //return UITableViewAutomaticDimension;
            
            //            CGSize size;
            //            size = [self getSizeOfString:str];
            //            return size.height + 60;
        }
        else if([str isEqualToString:@"audio"]){
            return UITableViewAutomaticDimension;
            
            //            CGSize size;
            //            size = [self getSizeOfString:str];
            //            return size.height + 60;
        }
        
        else{
            return 250;
            
        }
    }
    
}

-(CGSize)getSizeOfString:(NSString *)str
{
    CGSize maximumSize = CGSizeMake(self.view.frame.size.width/1.7, 9999);
    UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:14];
    
    
    
    CGSize myStringSize = [str sizeWithFont:myFont
                          constrainedToSize:maximumSize
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return myStringSize;
    
}

#pragma mark - Image Picker
//-(UIImage *)generateThumbImage : (NSURL *)url
//{
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
//
//    int frameTimeStart = 3;
//    int frameLocation = 1;
//
//    CGImageRef frameRef = [generator copyCGImageAtTime:CMTimeMake(frameTimeStart,frameLocation) actualTime:nil error:nil];
//    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:frameRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
//    return thumbnail;
//}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if([strSelectLibrary isEqualToString:@"videos"]){
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            strVideoPath = [videoUrl path];
            
            //NSURL *fileURL = [NSURL fileURLWithPath:moviePath];
            [self sendVideo];
            
            
            // [self.avPlayer play];
            
            //            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (strVideoPath)) {
            //
            UISaveVideoAtPathToSavedPhotosAlbum (strVideoPath, nil, nil, nil);
            //            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        picker.delegate = self;
        profileImage = info[UIImagePickerControllerEditedImage];
        [self sendImage];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)recordAudio{
    
    //Audio
    //    videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
    //    moviePath = [videoUrl path];
    ref = [[FIRDatabase database] reference];
    
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.WAV"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    
}

#pragma mark - Action sheet actions - Take Photo and Choose Photo Method
-(void)takePhoto{
    
    objImagePicker = [UIImagePickerController new];
    objImagePicker.delegate = self;
    objImagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        objImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:objImagePicker animated:YES completion:nil];
    }
    else{
        [self.view makeToast:@"Camera is not available"];
    }
    
}

-(void)choosePhoto{
    strSelectLibrary = @"images";
    
    objImagePicker = [UIImagePickerController new];
    objImagePicker.delegate = self;
    objImagePicker.allowsEditing = YES;
    objImagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:objImagePicker animated:YES completion:nil];
}
-(void)shareLocation{
    //  _tblViewChat.hidden = true;
    _mapView.hidden = false;
    _btnSendLocationOut.hidden = false;
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    [_mapView setShowsUserLocation:YES];
    [self loadUserLocation];
    
}
-(void)shareVideo{
    
    strSelectLibrary = @"videos";
    
    objImagePicker = [UIImagePickerController new];
    objImagePicker.delegate = self;
    objImagePicker.allowsEditing = YES;
    objImagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    objImagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:objImagePicker animated:YES completion:nil];
    
}
-(void)shareContact{
    
    _tblViewContact.hidden = false;
    // _tblViewChat.hidden = true;
    //_viewMessage.hidden = true;
    _tblViewContact.dataSource = self;
    _tblViewContact.delegate = self;
    //_mapView.hidden = true;
    [[ContactList sharedContacts] fetchAllContacts];
    arrContacts = [[ContactList sharedContacts]totalPhoneNumberArray];
    [_tblViewContact reloadData];
    
}
#pragma mark - Button Actions


- (IBAction)btnAttachmentAct:(id)sender {
    UIButton *button; // the button you want to show the popup sheet from
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertTakePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         [self performSelector:@selector(takePhoto) withObject:nil];
                                     }];
    
    UIAlertAction *alertGallery = [UIAlertAction actionWithTitle:@"Choose from Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       [self performSelector:@selector(choosePhoto) withObject:nil];
                                   }];
    
    UIAlertAction *alertVideo = [UIAlertAction actionWithTitle:@"Share Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self performSelector:@selector(shareVideo) withObject:nil];
                                 }];
    
    
    UIAlertAction *alertLocation = [UIAlertAction actionWithTitle:@"Share Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [self performSelector:@selector(shareLocation) withObject:nil];
                                    }];
    UIAlertAction *alertContact = [UIAlertAction actionWithTitle:@"Share Contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       
                                       
                                       [self performSelector:@selector(shareContact) withObject:nil];
                                   }];
    
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                      [actionSheetController dismissViewControllerAnimated:YES completion:nil];
                                  }];
    
    [actionSheetController addAction:alertTakePhoto];
    [actionSheetController addAction:alertGallery];
    [actionSheetController addAction:alertVideo];
    [actionSheetController addAction:alertContact];
    [actionSheetController addAction:alertLocation];
    
    [actionSheetController addAction:alertCancel];
    
    actionSheetController.view.tintColor = [UIColor blackColor];
    
    actionSheetController.popoverPresentationController.sourceView = self.view;
    actionSheetController.popoverPresentationController.sourceRect = CGRectMake(self.viewMessage.bounds.size.width / 2.0, self.viewMessage.bounds.size.height / 2.0, 1.0, 1.0);
    
    //self.presentedViewController(actionSheetController, animated: true, completion: nil)
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    //[self presentViewController:[ApplicationData ChooseMedia:self] animated:YES completion:nil];
    
}

- (IBAction)btnAudioAct:(id)sender {
    if(isAudioRecord != true){
        [self recordAudio];
        if (!audioRecorder.recording)
        {
            
            [audioRecorder record];
            //[_btnAudioOut setTitle:@"Stop" forState:UIControlStateNormal];
            
        }
        isAudioRecord = true;
    }
    else{
        [_btnAudioOut setTitle:@"Record" forState:UIControlStateNormal];
        isAudioRecord = false;
        [audioRecorder stop];
        [_tblViewChat reloadData];
        [self sendAudio];
        
    }
    
    
}

- (IBAction)btnSendMsgAct:(id)sender {
    
    if(txtViewMsg.text.length > 0){
        resultMsg = [txtViewMsg.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_tblViewChat reloadData];
        [self sendMessage];
        
    }
    //    if ([trimmedString isEqualToString:@""]) {
    //
    //
    //
    //    }
    //
    //    else
    //    {
    //
    //    }
    //    if (txtViewMsg.isFirstResponder)
    //    {
    //        [_tblViewChat setFrame:CGRectMake(0, _tblViewChat.frame.origin.y  , _tblViewChat.frame.size.width, _tblViewChat.frame.size.height+(_viewMessage.frame.size.height - msgViewFrame.size.height))];
    //        [_viewMessage setFrame:CGRectMake(_viewMessage.frame.origin.x, _viewMessage.frame.origin.y+(_viewMessage.frame.size.height - msgViewFrame.size.height), _viewMessage.frame.size.width, msgViewFrame.size.height)];
    //
    //    }
    //    else
    //    {
    //        [_tblViewChat setFrame:CGRectMake(0, _tblViewChat.frame.origin.y  , _tblViewChat.frame.size.width, _tblViewChat.frame.size.height+(_viewMessage.frame.size.height - msgViewFrame.size.height))];
    //        _viewMessage.frame = msgViewFrame;
    //    }
    
    
    
}
- (IBAction)btnSendLocationAct:(id)sender {
    
    
    
    CGPoint cgpoint = CGPointMake(self.view.center.x, self.view.center.y);
    
    CGRect grabRect = CGRectMake(cgpoint.x-100,cgpoint.y-100,200,200);
    
    //for retina displays
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(grabRect.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(grabRect.size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -grabRect.origin.x, -grabRect.origin.y);
    [self.view.layer renderInContext:ctx];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    //  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    dataMap = UIImagePNGRepresentation(viewImage);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _mapView.hidden = true;
        //_tblViewChat.hidden = false;
        _btnSendLocationOut.hidden =  true;
        [self sendLocation];
        
        [_tblViewChat reloadData];
    });
    
    [locationManager stopUpdatingLocation];
    
    
}
@end
