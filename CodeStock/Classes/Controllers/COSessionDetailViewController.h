//
//  COSessionDetailViewController.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSessionDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *sessionTitle;
@property (strong, nonatomic) IBOutlet UILabel *speaker;
@property (strong, nonatomic) IBOutlet UITextView *abstract;
@property (strong, nonatomic) NSDictionary *sessionDetail;

@end
