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
    self.view.backgroundColor = [UIColor darkGrayColor];
     // default
     BLSegmentedControl *defaultSegmentedControl = [[BLSegmentedControl alloc] initWithTitles:@[@"Segment1", @"Segment2", @"Segment3"]];
    defaultSegmentedControl.center = self.view.center;// using center
    defaultSegmentedControl.segmentColor = [UIColor grayColor];
    defaultSegmentedControl.selectedTextColor = [UIColor whiteColor];
     [defaultSegmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
     defaultSegmentedControl.changeBlock = ^(NSInteger index) {
         NSLog(@"%i", index);
     };
     [self.view addSubview:defaultSegmentedControl];
    // customize
    BLSegmentedControl *customizeSegmentedControl = [[BLSegmentedControl alloc] initWithTitles:@[@"Segment1", @"Segment2", @"Segment3"] backgroundImage:[self imageWithColor:[UIColor yellowColor]] selectedBackgroundImage:[self imageWithColor:[UIColor orangeColor]]];
    customizeSegmentedControl.frame = CGRectMake(5, 80, 310, 40);
    customizeSegmentedControl.textColor = [UIColor blackColor];
    customizeSegmentedControl.selectedTextColor = [UIColor whiteColor];
    customizeSegmentedControl.selectedSegmentIndex = 1;
    [customizeSegmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    customizeSegmentedControl.changeBlock = ^(NSInteger index) {
        NSLog(@"%i", index);
    };
    UIImage *image = [UIImage imageNamed:@"segmented_dividing_line"];
    customizeSegmentedControl.dividingLineImage = image;
    [self.view addSubview:customizeSegmentedControl];
    // customize
    BLSegmentedControl *customizeSegmentedControl2 = [[BLSegmentedControl alloc] initWithTitles:@[@"Segment1", @"Segment2", @"Segment3"] backgroundImage:[UIImage imageNamed:@"segmented"] selectedBackgroundImage:[UIImage imageNamed:@"segmented_selected"] dividingLineImage:[UIImage imageNamed:@"segmented_dividing_line"]];
    customizeSegmentedControl2.frame = CGRectMake(15, 160, 290, 40);
    customizeSegmentedControl2.textColor = [UIColor whiteColor];
    customizeSegmentedControl2.selectedTextColor = [UIColor whiteColor];
    customizeSegmentedControl2.selectedSegmentIndex = 0;
    [customizeSegmentedControl2 addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    customizeSegmentedControl2.changeBlock = ^(NSInteger index) {
        NSLog(@"%i", index);
    };
    [self.view addSubview:customizeSegmentedControl2];
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
