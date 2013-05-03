//
//  BLSegmentedControl.m
//  BLCinema
//
//  Created by yhw on 13-4-26.
//
//

#import "BLSegmentedControl.h"

@interface BLSegmentedControl ()
@property (retain, nonatomic) NSMutableArray *buttons;// storing UIButton
@property (retain, nonatomic) NSMutableArray *dividingLines;// storing dividing Lines
@property (assign, nonatomic) CGFloat segmentWidth;// default is 0
@property (assign, nonatomic) CGFloat segmentHeight;// default is 32
@end

@implementation BLSegmentedControl

- (void)dealloc {
    [_segmentTitles release];
    [_backgroundImage release];
    [_selectedBackgroundImage release];
    [_dividingLineImage release];
    [_selectedDividingLineImage release];
    [_segmentColor release];
    [_font release];
    [_textColor release];
    [_selectedTextColor release];
    Block_release(_indexChangeBlock);
    //
    [_buttons release];
    [_dividingLines release];
    [super dealloc];
}
#pragma mark - Init
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage dividingLineImage:(UIImage *)dividingLineImage {
    if (self = [super init]) {
        // set default values
        _selectedSegmentIndex = 0;
        _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentTitles = [titles retain];
        _backgroundImage = [backgroundImage retain];
        _selectedBackgroundImage = [selectedBackgroundImage retain];
        _dividingLineImage = [dividingLineImage retain];
        _segmentColor = [[UIColor clearColor] retain];
        _font = [[UIFont systemFontOfSize:15.0f] retain];
        _textColor = [[UIColor blackColor] retain];
        _selectedTextColor = [[UIColor blackColor] retain];
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
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.adjustsImageWhenHighlighted = NO;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
            [_buttons addObject:button];
            [self addSubview:button];
        }
        NSUInteger dividingLineNumber = count - 1;
        [_buttons enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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

- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    return [self initWithTitles:titles backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage dividingLineImage:nil];
}
- (id)initWithTitles:(NSArray *)titles {
    return [self initWithTitles:titles backgroundImage:nil selectedBackgroundImage:nil];
}
#pragma mark - Setters
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    if (self.indexChangeBlock) {
        self.indexChangeBlock(self.selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self updateButtons];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        [_backgroundImage release];
        _backgroundImage = [backgroundImage retain];
    }
    [self updateButtons];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    if (_selectedBackgroundImage != selectedBackgroundImage) {
        [_selectedBackgroundImage release];
        _selectedBackgroundImage = [selectedBackgroundImage retain];
    }
    [self updateButtons];
}

- (void)setDividingLineImage:(UIImage *)dividingLineImage {
    if (_dividingLineImage != dividingLineImage) {
        [_dividingLineImage release];
        _dividingLineImage = [dividingLineImage retain];
    }
    [self updateDividingLines];
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        [_font release];
        _font = [font retain];
    }
    [self updateButtons];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        [_textColor release];
        _textColor = [textColor retain];
    }
    [self updateButtons];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    if (_selectedTextColor != selectedTextColor) {
        [_selectedTextColor release];
        _selectedTextColor = [selectedTextColor retain];
    }
    [self updateButtons];
}

- (void)setSegmentColor:(UIColor *)segmentColor {
    if (_segmentColor != segmentColor) {
        [_segmentColor release];
        _segmentColor = [segmentColor retain];
    }
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
