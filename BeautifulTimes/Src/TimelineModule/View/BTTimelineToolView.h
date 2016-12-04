//
//  BTTimelineToolView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/3.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTTimelineToolViewDelegate <NSObject>

@optional

- (void)timelineToolViewDidSelectAtSelectPhotos;
- (void)timelineToolViewDidSelectAtCurrentSite;
- (void)timelineToolViewDidSelectAtAddressBook;

@end

@interface BTTimelineToolView : UIView

@property (nonatomic, weak) id <BTTimelineToolViewDelegate> delegate;

@end
