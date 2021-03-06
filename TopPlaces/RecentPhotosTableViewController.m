//
//  RecentPhotosTableViewController.m
//  TopPlaces
//
//  Created by Pamamarch on 01/02/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoDisplayViewController.h"
#import "SecondPhotoDisplayViewController.h"

@interface RecentPhotosTableViewController ()

@end

@implementation RecentPhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.data = [defaults objectForKey:@"Top_Places_Recents"];
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recents" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary * photoDetails = self.data[indexPath.row];
    NSString* title;
    NSString* detail;
    
    title = photoDetails[FLICKR_PHOTO_TITLE];
    if([title isEqualToString:@""])
    {
        title = photoDetails[FLICKR_PHOTO_DESCRIPTION];
        detail = title;
        if(!title)
        {
            title = @"Unknown";
            detail = title;
        }
        
    }
    
    detail = photoDetails[FLICKR_PHOTO_DESCRIPTION];
    if (!detail)
    {
        detail = @"Unknown";
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.splitViewController)
    {
        id nvc = [self.splitViewController.viewControllers lastObject];
        if(![nvc isKindOfClass:[UINavigationController class]]) nvc = nil;
        
        NSArray *controllers = [nvc viewControllers];
        id hvc = controllers[0];
        if(![hvc isKindOfClass:[PhotoDisplayViewController class]]) hvc = nil;
        
        NSDictionary *photo = self.data[indexPath.row];
        [hvc setPhoto:photo];
    }
    
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SecondPhotoDisplayViewController class]])
    {
        SecondPhotoDisplayViewController *dest = segue.destinationViewController;
        NSDictionary *photo = self.data[self.tableView.indexPathForSelectedRow.row];
        [dest setPhoto:photo];
        
    }
    
 
}


@end
