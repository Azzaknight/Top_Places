//
//  SecondPhotoDisplayViewController.m
//  TopPlaces
//
//  Created by Pamamarch on 07/02/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import "SecondPhotoDisplayViewController.h"
#import "FlickrFetcher.h"

@interface SecondPhotoDisplayViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation SecondPhotoDisplayViewController

@synthesize imageView = _imageView;

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
    // Do any additional setup after loading the view
    
    [self loadPhoto];
}

/*
-(void) viewWillAppear:(BOOL)animated
{
    [self loadPhoto];
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setPhoto:(NSDictionary *)photo
{
    if(photo != _photo)
    {
        _photo = photo;
        
    }
}

-(void) setImageView:(UIImageView *)imageView
{
    if(_imageView != imageView)
    {
        _imageView = imageView;
        [self.imageView sizeToFit];
    }
    
}

-(UIImageView *) imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
        
}

-(void) setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    [self.scrollView addSubview:self.imageView];
    scrollView.contentSize = self.imageView.image ? self.imageView.image.size : CGSizeZero;
    self.scrollView.delegate = self;
}


-(void)loadPhoto
{
    
    
    UIActivityIndicatorView * indicator_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator_view startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator_view];
    
    
    dispatch_queue_t download_queue = dispatch_queue_create("Download Photo", NULL);
    dispatch_async(download_queue, ^{
        
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData * photoData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIImage * photoimage = [UIImage imageWithData:photoData];
            //UIImageView *iv = [[UIImageView alloc] initWithImage:photoimage];
            self.imageView.image = photoimage;
            //self.imageView.image = photoimage;
            self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height);
            [self.scrollView addSubview:self.imageView];
            self.scrollView.contentSize = self.imageView.image.size;
            
            self.title = self.photo[FLICKR_PHOTO_TITLE];
            if ([self.title isEqualToString:@""] ) self.title = @"Unknown";
            
            //if(!self.splitViewController)
            //{
            self.navigationItem.rightBarButtonItem = nil;
            //}
            
        });
        
    });
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
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
