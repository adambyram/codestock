//
//  COSpeakerDetailViewController.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSpeakerDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *speakerDetail;
@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UITextView *bio;
@property (strong, nonatomic) IBOutlet UIImageView *photo;

@end
