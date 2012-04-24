//
//  COSessionCell.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSessionCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UILabel* title;
@property (strong,nonatomic) IBOutlet UILabel* speaker;
@property (strong,nonatomic) IBOutlet UILabel* level;

@end
