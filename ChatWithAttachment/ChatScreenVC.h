//
//  ChatScreenVC.h
//  ChatWithAttachment
//
//  Created by vibha on 7/6/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager.h>
#import "ApplicationData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Toast.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <Contacts/Contacts.h>
#import <AVKit/AVKit.h>

#import <FirebaseCore/FirebaseCore.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "ChatTableViewCell.h"
#import "MapPoint.h"
#import "UIImageView+WebCache.h"
#import "ContactTableViewCell.h"
#import "ContactList.h"
@interface ChatScreenVC : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,MPMediaPickerControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate
,UIDocumentInteractionControllerDelegate,AVAudioSessionDelegate>
{
    FIRDatabaseReference * ref;
    FIRDatabaseHandle _refHandle;
    NSString *resultMsg,*strSelectLibrary,*strProfileImageURL,*strLat,*strLong,*strVideoPath,*strAudioPath,*strPhoneName,*strPhoneNum,*strMapLat,*strMapLong;
    NSMutableDictionary *dicSender,*dicReceiver;
    CGRect msgViewFrame,tmpFrame,tmpScrollFrame;
    UIImage *profileImage;
    NSURL *url,*imgGetUrl,*videoGetUrl;
    UIImagePickerController *objImagePicker;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *myCurrentLocation;
    double latitude_UserLocation, longitude_UserLocation;
    NSData *dataMap;
    NSURL *videoUrl,*audioUrl;
    NSMutableArray *arrContacts;
    NSArray *arrPhone;
    NSDictionary *dictSnap;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    BOOL isAudioRecord,isSelectMap;
}


@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;

@property NSString *strLoginEmail,*strLoginID,*strSelectedID,*strSelectedEmail;

@property NSString *strChatUser;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;

@property (weak, nonatomic) IBOutlet UIView *viewMessage;

@property (weak, nonatomic) IBOutlet UITextView *txtViewMsg;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tblViewChat;
@property (weak, nonatomic) IBOutlet UITableView *tblViewContact;

@property (weak, nonatomic) IBOutlet UIButton *btnAudioOut;
@property (weak, nonatomic) IBOutlet UIButton *btnSendLocationOut;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment;

@property (nonatomic) AVPlayer *avPlayer;

- (IBAction)btnSendLocationAct:(id)sender;
- (IBAction)btnAttachmentAct:(id)sender;
- (IBAction)btnAudioAct:(id)sender;
- (IBAction)btnSendMsgAct:(id)sender;
@end
