//
//  COScheduleViewControllerViewController.m
//  CodeStock for iOS
//
//  Created by Adam Byram on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "COScheduleViewControllerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CODataManager.h"

@interface COScheduleViewControllerViewController ()

@end

@implementation COScheduleViewControllerViewController

@synthesize scrollView;
@synthesize roomScrollView;
@synthesize timeScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //float height = 288 * 20;
    /*for(int block = 0; block < 288; block++)
    {
        if(block % 2 == 0) continue;
        UIView* blockView = [[UIView alloc] initWithFrame:CGRectMake(30, block*20, 200, 20)];
        blockView.backgroundColor = [UIColor orangeColor];
        blockView.layer.cornerRadius = 5;
        [self.scrollView addSubview:blockView];
        
        UIView* blockView2 = [[UIView alloc] initWithFrame:CGRectMake(240, block*20, 200, 20)];
        blockView2.backgroundColor = [UIColor blueColor];
        blockView2.layer.cornerRadius = 5;
        [self.scrollView addSubview:blockView2];
    }*/
    
    [self.scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
    
    //[self.roomScrollView addObserver:self
    //              forKeyPath:@"zoomScale"
    //                 options:NSKeyValueObservingOptionNew
    //                 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionListUpdated) name:kCodeStockDataManagerSessionListUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
        [self.timeScrollView setContentOffset:CGPointMake(self.timeScrollView.contentOffset.x,self.scrollView.contentOffset.y)];
        [self.roomScrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,self.roomScrollView.contentOffset.y)];
}

- (void)sessionListUpdated
{
    NSMutableDictionary* roomDictionary = [[NSMutableDictionary alloc] init];
    for(id session in [[CODataManager sharedInstance] sessionList])
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
    int timeBlockSize = 20;
    int roomSpacer = 15;
    int roomPosition = 15;
    int roomWidth = 300;
    //float height = 288 * 20;
    float height = 11*12*timeBlockSize;
    float offset = 8*12*timeBlockSize;
    //int offset = 0;
    
    // 8am -> 6pm
    
    CGSize sessionContentSize = CGSizeMake(((roomWidth+roomSpacer)*[[roomDictionary allKeys] count])+roomSpacer, height);
    self.scrollView.contentSize = sessionContentSize;
    
    CGSize roomContentSize = CGSizeMake(([[roomDictionary allKeys] count]*(roomWidth+roomSpacer))+roomSpacer, self.roomScrollView.frame.size.height);
    self.roomScrollView.contentSize = roomContentSize;
    
    CGSize timeContentSize = CGSizeMake(self.timeScrollView.frame.size.width, 11*12*timeBlockSize);
    self.timeScrollView.contentSize = timeContentSize;
    
    for(int tick = 0; tick < 11*12; tick++)
    {
        UIView* tickView = [[UIView alloc] initWithFrame:CGRectMake(self.timeScrollView.frame.size.width/2, (tick*timeBlockSize), self.timeScrollView.frame.size.width/2, (tick%12==0)?2:1)];
        tickView.backgroundColor = (tick%12==0)?[UIColor blackColor]:[UIColor grayColor];
        [self.timeScrollView addSubview:tickView];
        
        if(tick%12==0)
        {
            UILabel* hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (tick*timeBlockSize)-(timeBlockSize/2), self.timeScrollView.frame.size.width/2, timeBlockSize)];
            int hour = tick/12+8;
            hourLabel.text = [NSString stringWithFormat:@"%i",(hour > 12)?hour - 12:hour];
            hourLabel.textAlignment = UITextAlignmentCenter;
            [self.timeScrollView addSubview:hourLabel];
        }
    }
    
    for(id roomKey in [[roomDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSLog(@"Room %@",roomKey);
        NSSortDescriptor *sessionTimeSort = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:YES];
        
        UILabel* roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(roomPosition, 0, roomWidth, self.roomScrollView.frame.size.height)];
        roomLabel.textAlignment = UITextAlignmentCenter;
        roomLabel.text = roomKey;
        [self.roomScrollView addSubview:roomLabel];

        for(id session in [[roomDictionary valueForKey:roomKey] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sessionTimeSort]])
        {
            NSLog(@"\tSession %@",[session valueForKey:@"Title"]);
            NSLog(@"\t%@",[session valueForKey:@"StartTime"]);
            NSLog(@"\t%@\n",[session valueForKey:@"EndTime"]);
            NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[session valueForKey:@"StartTime"]];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *differenceComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit
                                                       fromDate:[session valueForKey:@"StartTime"]
                                                         toDate:[session valueForKey:@"EndTime"]
                                                        options:0];
           
            int startY = (startComponents.hour*12*timeBlockSize)+(startComponents.minute/5*timeBlockSize)-offset;
            int heightY = (differenceComponents.hour*12*timeBlockSize)+(differenceComponents.minute/5*timeBlockSize);
            if(startComponents.day == 15)
            {
                UIView* blockView = [[UIView alloc] initWithFrame:CGRectMake(roomPosition, startY, roomWidth, heightY)];
                blockView.backgroundColor = [UIColor orangeColor];
                blockView.layer.cornerRadius = 5;
                [self.scrollView addSubview:blockView];
            }
        }
        roomPosition += roomWidth + roomSpacer;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
