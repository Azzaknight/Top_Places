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

-(void)setPhoto:(NSDictionary *)photo
{
    if(photo != _photo)
    {
        _photo = photo;
        [self loadPhoto];
    }
}

-(void)loadPhoto
{
    
    //if(!self.splitViewController)
    //{
        UIActivityIndicatorView * indicator_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator_view startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator_view];
    //}
    
    dispatch_queue_t download_queue = dispatch_queue_create("Download Photo", NULL);
    dispatch_async(download_queue, ^{
        
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData * photoData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.scrollView.delegate = self;
            
            UIImage * photoimage = [UIImage imageWithData:photoData];
            self.imageView.image = photoimage;
            self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height);
            self.scrollView.contentSize = self.imageView.image.size;
            
            self.title = self.photo[FLICKR_PHOTO_TITLE];
            if ([self.title isEqualToString:@""] ) self.title = @"Unknown";
            
            //if(!self.splitViewController)
            //{
                self.navigationItem.rightBarButtonItem = nil;
            //}
            
            [self viewWillAppear:YES];
            
        });
        
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self loadPhoto];
    

}

-(void)viewWillLayoutSubviews
{
    NSLog(@"I am called when I rotate");
    CGFloat heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
    CGFloat widthRation = self.view.bounds.size.width / self.imageView.image.size.width;
    self.scrollView.zoomScale = MAX(heightRatio, widthRation);
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //if(!self.splitViewController)
    //{
        CGFloat heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
        CGFloat widthRation = self.view.bounds.size.width / self.imageView.image.size.width;
        self.scrollView.zoomScale = MAX(heightRatio, widthRation);
    //}

    UIEdgeInsets edgetInsets = UIEdgeInsetsMake(20,20,60,20);
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
