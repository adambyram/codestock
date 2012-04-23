//
//  COSessionListViewController.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSessionListViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *sessionList;

@end
