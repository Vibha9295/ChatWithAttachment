//
//  ContactTableViewCell.h
//  ChatWithAttachment
//
//  Created by vibha on 7/12/17.
//  Copyright © 2017 vibha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@end
