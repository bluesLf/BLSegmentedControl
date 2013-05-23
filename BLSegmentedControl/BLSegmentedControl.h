//
//  BLSegmentedControl.h
//  BLCinema
//
//  Created by yhw on 13-4-26.
//
//

#import <UIKit/UIKit.h>

typedef void (^ChangeBlock)(NSInteger index);

/*
 SegmentedControl using UIButton. Supported dividing line.
 */
@interface BLSegmentedControl : UIControl
@property (assign, nonatomic) NSInteger selectedSegmentIndex;// default is 0
@property (assign, nonatomic) UIEdgeInsets contentEdgeInsets;// default is UIEdgeInsetsMake(0, 10, 0, 10), for titles edge inset
@property (nonatomic, strong) NSArray *segmentTitles;// segment titles
@property (strong, nonatomic) UIImage *backgroundImage;// button background image
@property (strong, nonatomic) UIImage *selectedBackgroundImage;// button selected background image
@property (strong, nonatomic) UIImage *dividingLineImage;// dividing line image
@property (strong, nonatomic) UIImage *selectedDividingLineImage;// selected dividing line image
@property (strong, nonatomic) UIColor *segmentColor;// default is [UIColor clearColor]
@property (strong, nonatomic) UIFont *font;// default is [UIFont systemFontOfSize:15.0f]
@property (strong, nonatomic) UIColor *textColor;// default is [UIColor blackColor]
@property (strong, nonatomic) UIColor *selectedTextColor;// default is [UIColor blackColor]
@property (copy, nonatomic) ChangeBlock changeBlock;// you can also use addTarget:action:forControlEvents:
- (id)initWithTitles:(NSArray *)titles;
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage;
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage dividingLineImage:(UIImage *)dividingLineImage;

@end