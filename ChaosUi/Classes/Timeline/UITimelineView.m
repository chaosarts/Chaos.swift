//
//  UITimelineView.m
//  ChaosUi
//
//  Created by Fu Lam Diep on 28.10.20.
//

#import "UITimelineView.h"
#import "UITimelineMilestone.h"

@implementation UITimelineView {
    UIStackView* stackView;
}

@synthesize delegate;

@synthesize dataSource;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self prepare];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self prepare];
    return self;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    [self prepare];
    return self;
}

- (void)prepare {
    stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:stackView];
    [self addConstraints: [NSArray arrayWithObjects:
                           [self.topAnchor constraintEqualToAnchor:stackView.topAnchor],
                           [self.rightAnchor constraintEqualToAnchor:stackView.rightAnchor],
                           [self.bottomAnchor constraintEqualToAnchor:stackView.bottomAnchor],
                           [self.leftAnchor constraintEqualToAnchor:stackView.leftAnchor],
                           nil]];
}

- (void)reloadData {
    
}
@end
