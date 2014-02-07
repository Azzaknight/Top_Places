//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Pamamarch on 28/01/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"

@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController

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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIActivityIndicatorView * indicator_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator_view startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator_view];
    
    dispatch_queue_t fetchData = dispatch_queue_create("Fetching Top Places", NULL);
    dispatch_async(fetchData, ^{
    
    NSArray *flickrFetch = [FlickrFetcher topPlaces];
    NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortdescriptor = @[titleSortDescriptor];
    flickrFetch = [flickrFetch sortedArrayUsingDescriptors:sortdescriptor];
    self.data = flickrFetch;
    
        //NSLog(@"The results is %@",self.data);
        dispatch_async(dispatch_get_main_queue(), ^{
            
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

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top_Places" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"top_Places"];
    }
    
    // Configure the cell...
    NSDictionary* place = self.data[indexPath.row];
    NSString *place_description = place[FLICKR_PLACE_NAME];
    NSRange commaSeparator = [place_description rangeOfString:@","];
    
    
    cell.textLabel.text = [place_description substringToIndex:commaSeparator.location];
    cell.detailTextLabel.text = [place_description substringFromIndex:(commaSeparator.location+commaSeparator.length)+1];
    
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
    if ([segue.identifier isEqualToString: @"List_Photos"])
    {
        PhotosTableViewController *dest = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [dest setPlace:self.data[indexPath.row]];
        
    }
}


@end
