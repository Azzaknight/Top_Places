//
//  PhotoDisplayViewController.h
//  TopPlaces
//
//  Created by Pamamarch on 29/01/2014.
//  Copyright (c) 2014 Finger Flick Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDisplayViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property  (nonatomic, weak) IBOutlet UIImageView *imageView;
@property  (nonatomic, strong) NSDictionary * photo;

@end
