//
//  PhotoDisplayViewController.m
//  TopPlaces
//
//  Created by Pamamarch on 29/01/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import "PhotoDisplayViewController.h"
#import "FlickrFetcher.h"

@interface PhotoDisplayViewController () <UIScrollViewDelegate>

@end

@implementation PhotoDisplayViewController

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
    self.scrollView.delegate = self;
    // Do any additional setup after loading the view.
    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData * photoData = [NSData dataWithContentsOfURL:url];
    UIImage * photoimage = [UIImage imageWithData:photoData];
    
    self.imageView.image = photoimage;
    self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.contentSize = self.imageView.image.size;
    [self.scrollView zoomToRect:self.imageView.bounds animated:YES];
    
    UIEdgeInsets edgetInsets = UIEdgeInsetsMake(20,20,20,20);
    self.scrollView.scrollIndicatorInsets = edgetInsets;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate 

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
