//
//  ChatTableViewCell.h
//  ChatWithAttachment
//
//  Created by vibha on 7/6/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblReceiverMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblSenderMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPlaySender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPlayReceiver;

@property (weak, nonatomic) IBOutlet UIImageView *imgSender;
@property (weak, nonatomic) IBOutlet UIImageView *imgReceiver;

@property (weak, nonatomic) IBOutlet UIView *viewSender;
@property (weak, nonatomic) IBOutlet UIView *viewReceiver;

@property (weak, nonatomic) IBOutlet UILabel *lblSenderName;
@property (weak, nonatomic) IBOutlet UILabel *lblSenderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblReceivedName;
@property (weak, nonatomic) IBOutlet UILabel *lblReceivedNumber;



@end
