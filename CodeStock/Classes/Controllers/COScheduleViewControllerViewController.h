//
//  COScheduleViewControllerViewController.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COScheduleViewControllerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIScrollView* roomScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView* timeScrollView;

@end
