//
//  ViewController.m
//  BLSegmentedControlTest
//
//  Created by yhw on 13-4-27.
//  Copyright (c) 2013年 YHW. All rights reserved.
//

#import "ViewController.h"
#import "BLSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
     // default
     BLSegmentedControl *defaultSegmentedControl = [[[BLSegmentedControl alloc] initWithTitles:@[@"Segment1", @"Segment2", @"Segment3"]] autorelease];
    defaultSegmentedControl.center = self.view.center;
    defaultSegmentedControl.segmentColor = [UIColor grayColor];
    defaultSegmentedControl.selectedTextColor = [UIColor whiteColor];
     [defaultSegmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
     defaultSegmentedControl.indexChangeBlock = ^(NSInteger index) {
         NSLog(@"%i", index);
     };
     [self.view addSubview:defaultSegmentedControl];
    // customize
    BLSegmentedControl *customizeSegmentedControl = [[[BLSegmentedControl alloc] initWithTitles:@[@"Segment1", @"Segment2", @"Segment3"] backgroundImage:[self imageWithColor:[UIColor yellowColor]] selectedBackgroundImage:[self imageWithColor:[UIColor orangeColor]]] autorelease];
    customizeSegmentedControl.frame = CGRectMake(10, 60, 300, 40);
    customizeSegmentedControl.textColor = [UIColor blackColor];
    customizeSegmentedControl.selectedTextColor = [UIColor whiteColor];
    customizeSegmentedControl.selectedSegmentIndex = 1;
    [customizeSegmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    customizeSegmentedControl.indexChangeBlock = ^(NSInteger index) {
        NSLog(@"%i", index);
    };
    [self.view addSubview:customizeSegmentedControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create UIImage from UIColor
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Actions
- (void)segmentedControlAction:(BLSegmentedControl *)segmentedControl {
    NSLog(@"%i", segmentedControl.selectedSegmentIndex);
}

@end
