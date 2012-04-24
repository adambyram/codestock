//
//  COSessionListViewController.m
//  CodeStock for iOS
//
//  Created by Adam Byram on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "COSessionListViewController.h"
#import "CODataManager.h"
#import "COSessionCell.h"
#import "COSessionDetailViewController.h"

@interface COSessionListViewController ()

@end

@implementation COSessionListViewController

@synthesize sessionList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableArray *filteredSearchResults = [[NSMutableArray alloc] init];
    for(id item in [[CODataManager sharedInstance] sessionList])
    {
        NSRange substringLocation = [[[item objectForKey:@"Title"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]];
        if(substringLocation.location != NSNotFound)
        {
            [filteredSearchResults addObject:[item copy]];
        }
    }
    self.sessionList = filteredSearchResults;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        self.sessionList = [[[CODataManager sharedInstance] sessionList] copy];
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.sessionList = [[[CODataManager sharedInstance] sessionList] copy];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Sessions";
    self.sessionList = [[[CODataManager sharedInstance] sessionList] copy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionListUpdated) name:kCodeStockDataManagerSessionListUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sessionListUpdated
{
    self.sessionList = [[[CODataManager sharedInstance] sessionList] copy];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sessionList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    COSessionCell *cell = (COSessionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = (COSessionCell*)[[[NSBundle mainBundle] loadNibNamed:@"COSessionCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.title.text = [[self.sessionList objectAtIndex:[indexPath row]] objectForKey:@"Title"];
    cell.speaker.text = [[[self.sessionList objectAtIndex:[indexPath row]] objectForKey:@"Speaker"] objectForKey:@"Name"];
    cell.level.text = [[self.sessionList objectAtIndex:[indexPath row]] objectForKey:@"LevelGeneral"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    COSessionDetailViewController* detailController = [[COSessionDetailViewController alloc] initWithNibName:@"COSessionDetailViewController" bundle:nil];
    detailController.sessionDetail = [self.sessionList objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
