//
//  CODataManager.h
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const kCodeStockDataManagerSessionListUpdated = @"kCodeStockDataManagerSessionListUpdated";

static NSString* const kCodeStockDataManagerSpeakerListUpdated = @"kCodeStockDataManagerSpeakerListUpdated";

static NSString* const kCodeStockDataManagerRoomListUpdated = @"kCodeStockDataManagerRoomListUpdated";

@interface CODataManager : NSObject

+ (id)sharedInstance;
- (void)startup;
- (void)finishedLoading;

@property (strong, nonatomic) NSMutableArray* sessionList;
@property (strong, nonatomic) NSMutableArray* speakerList;
@property (strong, nonatomic) NSMutableArray* roomList;

@end
