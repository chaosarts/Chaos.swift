//
//  UITimelineView.h
//  ChaosUi
//
//  Created by Fu Lam Diep on 28.10.20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UITimelineView, UITimelineMilestone;
@protocol UITimelineViewDelegate, UITimelineViewDataSource;

@interface UITimelineView : UIScrollView <NSCoding>

/// Provides an object to tell about several events of the timeline view
@property (nonatomic, weak, nullable) id <UITimelineViewDelegate> delegate;

/// Provides the object that serves as the data source to build the view with
/// milestones.
@property (nonatomic, weak, nullable) id <UITimelineViewDataSource> dataSource;

/// Initializes the timeline view with given coder.
- (instancetype)initWithCoder:(NSCoder *)coder;

/// Initializes the timeline view with given frame.
- (instancetype)initWithFrame:(CGRect)frame;

/// Initializes the timeline view with zero rect.
- (instancetype)init;

- (void)insertMilestonesAtIndeces:(NSInteger[])indices;

- (void)deleteMilestonesAtIndices:(NSInteger[])indices;

- (void)updateMilestonesAtIndices:(NSInteger[])indices;

- (void)reloadData;
@end


// MARK: -

@protocol UITimelineViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (Boolean)timelineView:(UITimelineView*)timelineView;
@end


// MARK: -

@protocol UITimelineViewDataSource <NSObject>
@required
- (NSInteger)numberOfMilestonesInTimelineView:(UITimelineView*)timelineView;
- (UITimelineMilestone*)timelineView:(UITimelineView*)timelineView milestoneAtIndex:(NSInteger)index;
@optional
- (Boolean)timelineView:(UITimelineView*)timelineView canEditMilestoneAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
