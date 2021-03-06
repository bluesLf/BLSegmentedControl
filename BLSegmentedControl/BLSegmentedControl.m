//
//  BLSegmentedControl.m
//  BLCinema
//
//  Created by yhw on 13-4-26.
//
//

#import "BLSegmentedControl.h"

@interface BLSegmentedControl ()
@property (strong, nonatomic) NSMutableArray *buttons;// storing UIButton
@property (strong, nonatomic) NSMutableArray *dividingLines;// storing dividing Lines
@property (assign, nonatomic) CGFloat segmentWidth;// default is 0
@property (assign, nonatomic) CGFloat segmentHeight;// default is 32
@end

@implementation BLSegmentedControl

#pragma mark - Init
- (id)initWithTitles:(NSArray *)titles {
    return [self initWithTitles:titles backgroundImage:nil selectedBackgroundImage:nil dividingLineImage:nil];
}

- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    return [self initWithTitles:titles backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage dividingLineImage:nil];
}

- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage dividingLineImage:(UIImage *)dividingLineImage {
    if (self = [super init]) {
        // set default values
        _selectedSegmentIndex = 0;
        _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentTitles = titles;
        _backgroundImage = backgroundImage;
        _selectedBackgroundImage = selectedBackgroundImage;
        _dividingLineImage = dividingLineImage;
        _segmentColor = [UIColor clearColor];
        _font = [UIFont systemFontOfSize:15.0f];
        _textColor = [UIColor blackColor];
        _selectedTextColor = [UIColor blackColor];
        _segmentWidth = 0;
        _segmentHeight = 32;
        // calculate segment size
        [self calculateSegmentSize];
        // set bounds and frame
        int count = titles.count;
        self.bounds = CGRectMake(0, 0, _segmentWidth * count, _segmentHeight);
        self.frame = self.bounds;
        _buttons = [[NSMutableArray alloc] init];
        _dividingLines = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {// segment item using button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.adjustsImageWhenHighlighted = NO;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
            [self addSubview:button];
        }
        NSUInteger dividingLineNumber = count - 1;
        [_buttons enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {// dividing line using button
            if (idx < dividingLineNumber)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [_dividingLines addObject:button];
                [self addSubview:button];
            }
        }];
        [self updateButtons];
        [self updateDividingLines];
    }
    return self;
}

#pragma mark - Setters
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    if (self.changeBlock) {
        self.changeBlock(self.selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self updateButtons];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self updateButtons];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _selectedBackgroundImage = selectedBackgroundImage;
    [self updateButtons];
}

- (void)setDividingLineImage:(UIImage *)dividingLineImage {
    _dividingLineImage = dividingLineImage;
    [self updateDividingLines];
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self updateButtons];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self updateButtons];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [self updateButtons];
}

- (void)setSegmentColor:(UIColor *)segmentColor {
    _segmentColor = segmentColor;
    [self updateButtons];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.segmentWidth = round(self.frame.size.width / self.segmentTitles.count);
    self.segmentHeight = self.frame.size.height;
    [self setNeedsLayout];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setFrame:bounds];// set frame
}

#pragma mark - Actions
- (void)buttonAction:(UIButton *)button {
    [self setSelectedSegmentIndex:button.tag];
}

#pragma mark - layout
- (void)layoutSubviews {
    CGRect contentRect = self.bounds;
    NSUInteger buttonCount = self.buttons.count;
    NSUInteger dividingLineNumber = buttonCount - 1;
    CGFloat dividingLineWidth = 0;
    if (self.dividingLineImage) {
        dividingLineWidth = self.dividingLineImage.size.width;
    }
    CGFloat buttonWidth = floorf((CGRectGetWidth(contentRect) - (dividingLineNumber * dividingLineWidth)) / buttonCount);
    CGFloat buttonHeight = CGRectGetHeight(contentRect);
    CGFloat dButtonWidth = 0;
    CGFloat spaceLeft = CGRectGetWidth(contentRect) - (buttonCount * buttonWidth) - (dividingLineNumber * dividingLineWidth);
    
    CGFloat offsetX = CGRectGetMinX(contentRect);
    CGFloat offsetY = CGRectGetMinY(contentRect);
    NSUInteger increment = 0;
    for (int i = 0; i < buttonCount; i++) {
        dButtonWidth = buttonWidth;
        if (spaceLeft != 0)
        {
            dButtonWidth++;
            spaceLeft--;
        }
        if (increment != 0) offsetX += dividingLineWidth;
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(offsetX, offsetY, dButtonWidth, buttonHeight);
        if (increment < dividingLineNumber)
        {
            UIImageView *dividingLineImageView = self.dividingLines[increment];
            dividingLineImageView.frame = CGRectMake(CGRectGetMaxX(button.frame), offsetY, dividingLineWidth, buttonHeight);
        }
        increment++;
        offsetX = CGRectGetMaxX(button.frame);
    }
}

#pragma mark - Private methods
- (void)updateButtons {
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = obj;
            button.titleLabel.font = self.font;
            button.backgroundColor = self.segmentColor;
            if (_selectedSegmentIndex != idx) {// not selected
                [button setTitleColor:self.textColor forState:UIControlStateNormal];
                [button setBackgroundImage:self.backgroundImage forState:UIControlStateNormal];
            } else {// selected item
                [button setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
                [button setBackgroundImage:self.selectedBackgroundImage forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)updateDividingLines {
    [self.dividingLines enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        [button setBackgroundImage:self.dividingLineImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.dividingLineImage forState:UIControlStateHighlighted];
    }];
}

- (void)calculateSegmentSize {
    for(NSString *titleString in self.segmentTitles) {
        CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }
    self.segmentWidth = ceil(self.segmentWidth / 2.0) * 2; // make it an even number so we can position with center
}

@end
