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
@property (retain, nonatomic) UIImage *backgroundImage;// button background image
@property (retain, nonatomic) UIImage *selectedBackgroundImage;// button selected background image
@property (retain, nonatomic) UIImage *dividingLineImage;// dividing line image
@property (retain, nonatomic) UIImage *selectedDividingLineImage;// selected dividing line image
@property (retain, nonatomic) UIColor *segmentColor;// default is [UIColor clearColor]
@property (retain, nonatomic) UIFont *font;// default is [UIFont systemFontOfSize:15.0f]
@property (retain, nonatomic) UIColor *textColor;// default is [UIColor blackColor]
@property (retain, nonatomic) UIColor *selectedTextColor;// default is [UIColor blackColor]
@property (copy, nonatomic) ChangeBlock changeBlock;// you can also use addTarget:action:forControlEvents:
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage dividingLineImage:(UIImage *)dividingLineImage;
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage;
- (id)initWithTitles:(NSArray *)titles;
@end