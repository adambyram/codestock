//
//  CODataManager.m
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CODataManager.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@implementation CODataManager

@synthesize sessionList;
@synthesize speakerList;
@synthesize roomList;

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static CODataManager *sharedDataManager;
    dispatch_once(&once, ^ { 
        sharedDataManager = [[self alloc] init]; 
    });
    return sharedDataManager;
}

- (void)startup
{
    [SVProgressHUD showWithStatus:@"Loading"];
    [self loadSpeakerList];
}

- (void)loadSessionList
{
    NSURL *url = [NSURL URLWithString:@"http://codestock.org/api/v2.0.svc/AllSessionsJson"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *sessionArray = [JSON valueForKeyPath:@"d"];
        self.sessionList = [[NSMutableArray alloc] init];
        
        for(id session in sessionArray)
        {
            NSMutableDictionary *mutableSession = [session mutableCopy];
            [mutableSession setObject:[self speakerForId:[session objectForKey:@"SpeakerID"]] forKey:@"Speaker"];
            [mutableSession setObject:[self getDateFromJSON:[mutableSession objectForKey:@"StartTime"]] forKey:@"StartTime"];
            [mutableSession setObject:[self getDateFromJSON:[mutableSession objectForKey:@"EndTime"]] forKey:@"EndTime"];
            [self.sessionList addObject:mutableSession];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionListLoaded];
            [self finishedLoading];
        });
        
    } failure:nil];
    [operation start];
}

- (id)speakerForId:(NSNumber*)speakerId
{
    for(id speaker in self.speakerList)
    {
        if([[speaker objectForKey:@"SpeakerID"] compare:speakerId] == NSOrderedSame)
            return speaker;
    }
    return nil;
}

- (void)loadSpeakerList
{
    NSURL *url = [NSURL URLWithString:@"http://codestock.org/api/v2.0.svc/AllSpeakersJson"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *speakerArray = [JSON valueForKeyPath:@"d"];
        self.speakerList = [speakerArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self speakerListLoaded];
            [self loadRoomList];
        });
        
    } failure:nil];
    [operation start];
}

- (void)loadRoomList
{
    NSURL *url = [NSURL URLWithString:@"http://codestock.org/api/v2.0.svc/AllRoomsJson"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *roomArray = [JSON valueForKeyPath:@"d"];
        self.roomList = [roomArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self roomListLoaded];
            [self loadSessionList];
        });
        
    } failure:nil];
    [operation start];
}

- (void)sessionListLoaded
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kCodeStockDataManagerSessionListUpdated object:nil]];
}

- (void)speakerListLoaded
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kCodeStockDataManagerSpeakerListUpdated object:nil]];
}

- (void)roomListLoaded
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kCodeStockDataManagerRoomListUpdated object:nil]];
}

- (void)finishedLoading
{
    [SVProgressHUD dismissWithSuccess:@"Done"];
    //[self buildRoomSessions];
}

- (void)buildRoomSessions
{
    NSMutableDictionary* roomDictionary = [[NSMutableDictionary alloc] init];
    for(id session in self.sessionList)
    {
        NSString* roomName = [session valueForKey:@"Room"];
        NSMutableArray* roomSessionList = [roomDictionary valueForKey:roomName];
        if( roomSessionList == nil)
        {
            roomSessionList = [[NSMutableArray alloc] init];
            [roomDictionary setValue:roomSessionList forKey:roomName];
        }
        [roomSessionList addObject:session];
    }
    
    for(id roomKey in [[roomDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSLog(@"Room %@",roomKey);
        NSSortDescriptor *sessionTimeSort = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:YES];

        for(id session in [[roomDictionary valueForKey:roomKey] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sessionTimeSort]])
        {
            NSLog(@"\tSession %@",[session valueForKey:@"Title"]);
            NSLog(@"\t%@",[session valueForKey:@"StartTime"]);
            NSLog(@"\t%@\n",[session valueForKey:@"EndTime"]);
        }
    }
}

- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@"-"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
    //return [[NSDate dateWithTimeIntervalSince1970:interval] dateByAddingTimeInterval:-60*60*4];
}

@end
