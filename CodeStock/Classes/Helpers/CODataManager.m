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
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self loadSessionList];
}

- (void)loadSessionList
{
    NSURL *url = [NSURL URLWithString:@"http://codestock.org/api/v2.0.svc/AllSessionsJson"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *sessionArray = [JSON valueForKeyPath:@"d"];
        self.sessionList = [sessionArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionListLoaded];
            [self loadSpeakerList];
        });
        
    } failure:nil];
    [operation start];
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
            [self finishedLoading];
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
    [SVProgressHUD dismissWithSuccess:@"Loaded."];
}

@end
