//
//  MALabelProgress.h
//  Example
//
//  Created by Miguel Developing on 22/10/15.
//  Copyright © 2015 Miguel Developing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MALabelProgress : UILabel

@property(nonatomic) CGFloat lineWidth;
@property(nonatomic) CGFloat progressWidth;
@property(nonatomic) CGFloat startPoint;
@property(nonatomic) CGFloat endPoint;
@property(nonatomic) CGFloat progress;

@property(nonatomic, strong) UIColor* fillColor;
@property(nonatomic, strong) UIColor* lineColor;
@property(nonatomic, strong) UIColor* progressColor;

@property(nonatomic) BOOL unFillMode;


-(void) setProgressPercent:(CGFloat) percent
             andUnfillMode:(BOOL) unFillMode
                  animated:(BOOL) animated;

-(void) setProgressWithStartDate:(NSDate*) start
                      andEndDate:(NSDate*) endDate
                   andUnfillMode:(BOOL) unFillMode
                        animated:(BOOL) animated;

-(void) setStyleWithLineWidth:(CGFloat) lineWidth
                progressWidth:(CGFloat) progressWidth
                    lineColor:(UIColor*) lineColor
                progressColor:(UIColor*) progressColor
                    fillColor:(UIColor*) fillColor
                    labelFont:(UIFont*) font;



@end
