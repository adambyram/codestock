//
//  COSpeakerDetailViewController.m
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "COSpeakerDetailViewController.h"

@interface COSpeakerDetailViewController ()

@end

@implementation COSpeakerDetailViewController

@synthesize speakerDetail;
@synthesize fullName;
@synthesize bio;
@synthesize photo;

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
    self.fullName.text = [self.speakerDetail objectForKey:@"Name"];
    if([self.speakerDetail objectForKey:@"Bio"] != [NSNull null])
    {
        self.bio.text = [self.speakerDetail objectForKey:@"Bio"];
    }
    if([self.speakerDetail objectForKey:@"PhotoUrl"] != [NSNull null])
    {
        self.photo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [self.speakerDetail objectForKey:@"PhotoUrl"]]]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
