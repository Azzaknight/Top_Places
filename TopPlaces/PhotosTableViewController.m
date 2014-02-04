//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Pamamarch on 29/01/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoDisplayViewController.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

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
    
    UIActivityIndicatorView * indicator_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator_view startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator_view];

    
    dispatch_queue_t download_queue = dispatch_queue_create("Flickr Fetching Photos", NULL);
    
    dispatch_async(download_queue, ^{
        
        self.data = [FlickrFetcher photosInPlace:self.place maxResults:50];
        //NSLog(@"The results if %@",self.data);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //if([self.view window])
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = nil;
            
        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods


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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photos" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Photos"];
    }
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
    PhotoDisplayViewController *dest = segue.destinationViewController;
    NSDictionary *photo = self.data[self.tableView.indexPathForSelectedRow.row];
    [dest setPhoto:photo];
    
    // also can I do the NSUserDefaults here instead?
    // get the User Defaults
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recent = [[defaults objectForKey:@"Top_Places_Recents" ] mutableCopy];
    if(!recent) recent = [NSMutableArray array];
    
    
    for (int i = 0; i < [recent count]; i++) {
        NSDictionary * recentPhoto = recent[i];
        if([recentPhoto[@"id"] isEqualToString:photo[@"id"]])
        {
            [recent removeObjectAtIndex:i];
            break;
        }
    }
    
    if (recent.count == 20) [recent removeLastObject];
    [recent insertObject:photo atIndex:0];
    [defaults setObject:recent forKey:@"Top_Places_Recents"];
    [defaults synchronize];
    
    
}


@end
