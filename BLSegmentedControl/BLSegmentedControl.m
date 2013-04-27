//
//  BLSegmentedControl.m
//  BLCinema
//
//  Created by yhw on 13-4-26.
//
//

#import "BLSegmentedControl.h"

@interface BLSegmentedControl ()
@property (retain, nonatomic) NSArray *buttons;// storing UIButton
@property (assign, nonatomic) CGFloat segmentWidth;// default is 0
@property (assign, nonatomic) CGFloat segmentHeight;// default is 32
@end

@implementation BLSegmentedControl

- (void)dealloc {
    [_segmentTitles release];
    [_backgroundImage release];
    [_selectedBackgroundImage release];
    [_segmentColor release];
    [_font release];
    [_textColor release];
    [_selectedTextColor release];
    Block_release(_indexChangeBlock);
    //
    [_buttons release];
    [super dealloc];
}
#pragma mark - Init
- (id)initWithTitles:(NSArray *)titles backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    if (self = [super init]) {
        // default values
        _selectedSegmentIndex = 0;
        _titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentTitles = [titles retain];
        _backgroundImage = [backgroundImage retain];
        _selectedBackgroundImage = [selectedBackgroundImage retain];
        _segmentColor = [[UIColor clearColor] retain];
        _font = [[UIFont systemFontOfSize:15.0f] retain];
        _textColor = [[UIColor blackColor] retain];
        _selectedTextColor = [[UIColor blackColor] retain];
        // default size
        _segmentWidth = 0;
        _segmentHeight = 32;
        // calculate segment size
        [self segmentSize];
        // set bounds and frame
        int count = titles.count;
        self.bounds = CGRectMake(0, 0, _segmentWidth * count, _segmentHeight);
        self.frame = self.bounds;
        // create items
        CGRect buttonFrame = CGRectMake(0, 0, _segmentWidth, _segmentHeight);
        NSMutableArray *buttons = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.adjustsImageWhenHighlighted = NO;
            buttonFrame.origin.x = buttonFrame.size.width * i;
            button.frame = buttonFrame;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
            [buttons addObject:button];
            [self addSubview:button];
        }
        _buttons = [[NSArray arrayWithArray:buttons] retain];
        [self updateButtons];
    }
    return self;
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
    [self updateButtonFrame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setFrame:bounds];//
}

#pragma mark - Actions
- (void)buttonAction:(UIButton *)button {
    [self setSelectedSegmentIndex:button.tag];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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

- (void)updateButtonFrame {
    int count = self.segmentTitles.count;
    CGRect buttonFrame = CGRectMake(0, 0, self.segmentWidth, self.segmentHeight);
    for (int i = 0; i < count; i++) {
        UIButton *button = self.buttons[i];
        buttonFrame.origin.x = buttonFrame.size.width * i;
        button.frame = buttonFrame;
    }
}

- (CGSize)segmentSize {
    for(NSString *titleString in self.segmentTitles) {
        CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }
    self.segmentWidth = ceil(self.segmentWidth / 2.0) * 2; // make it an even number so we can position with center
    return CGSizeMake(self.segmentWidth, self.segmentHeight);
}

@end
