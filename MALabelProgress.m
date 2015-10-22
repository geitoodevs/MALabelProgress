//
//  MALabelProgress.m
//  Example
//
//  Created by Miguel Developing on 22/10/15.
//  Copyright © 2015 Miguel Developing. All rights reserved.
//

#import "MALabelProgress.h"

#define kDegreesToRadians(degrees) ((degrees)/180.0*M_PI)
#define kRadiansToDegrees(radians) ((radians)*180.0/M_PI)

@interface MALabelProgress ()

@property (nonatomic) CGFloat daysToGoValue;

@end

@implementation MALabelProgress

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize progress = _progress;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

-(void) commonInit{
    
    // Resize and center the view
    if(self.frame.size.width != self.frame.size.height){
        CGRect frame = self.frame;
        float delta = ABS(self.frame.size.width-self.frame.size.height)/2;
        if(self.frame.size.width > self.frame.size.height){
            frame.origin.x += delta;
            frame.size.width = self.frame.size.height;
            self.frame = frame;
        }else{
            frame.origin.y += delta;
            frame.size.height = self.frame.size.width;
            self.frame = frame;
        }
    }
    
    self.lineWidth = 1.0;
    self.progressWidth = 4.0;
    self.fillColor = [UIColor clearColor];
    self.lineColor = [UIColor whiteColor];
    self.progressColor = [UIColor whiteColor];
    
    self.startPoint = 0.f;
    self.endPoint = 0.f;
    self.progress = 0.f;
    
    self.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark - Public

-(void) setStyleWithLineWidth:(CGFloat) lineWidth
                progressWidth:(CGFloat) progressWidth
                    lineColor:(UIColor*) lineColor
                progressColor:(UIColor*) progressColor
                    fillColor:(UIColor*) fillColor
                    labelFont:(UIFont*) font{

    self.lineWidth = lineWidth;
    self.progressWidth = progressWidth;
    self.fillColor = fillColor;
    self.lineColor = lineColor;
    self.progressColor = progressColor;
    self.font = font;
    self.textColor = progressColor;
    
    [self setNeedsDisplay];
}

-(void) setProgressWithStartDate:(NSDate*) start
                      andEndDate:(NSDate*) endDate
                   andUnfillMode:(BOOL) unFillMode
                        animated:(BOOL) animated{
    
    NSTimeInterval totalDaysInSeconds = [endDate timeIntervalSinceDate:start];
    double secondsInAnHour = 3600;
    NSInteger totalDays = (totalDaysInSeconds / secondsInAnHour) / 24;
    
    NSTimeInterval currentDaysInSeconds = [[NSDate date] timeIntervalSinceDate:start];
    NSInteger currentDays = (currentDaysInSeconds / secondsInAnHour) / 24;
    
    CGFloat percentage =(((currentDays*360) / totalDays) * 100) / 360;
    CGFloat totalProgress = 360 * (percentage/100);

    self.unFillMode = unFillMode;
    self.daysToGoValue = totalDays-currentDays;
    [self setProgress:totalProgress animated:animated andDateMode:YES];
 
}

#pragma mark - Getters

- (float) radius
{
    return MIN(self.frame.size.width,self.frame.size.height)/2;
}

-(CGFloat)progress{
    return self.endPoint/360;
}

#pragma mark - Setters

-(void)setProgress:(CGFloat)aProgress
          animated:(BOOL) animated
       andDateMode:(BOOL) dateMode{
   
    if (self.startPoint!=0){
        [self setStartPoint:0.f];
    }
    
    if (animated){
        [self updateProgressWithValue:aProgress andCurrentValue:self.endPoint andDateMode:dateMode];
    }else{
        if (dateMode){
            self.text = [NSString stringWithFormat:@"%.0f",self.daysToGoValue];
        }else{
            
            self.text = [NSString stringWithFormat:@"%.0f",(aProgress*100)/360];
        }
        [self setEndPoint:aProgress];
    }
}

-(void) setProgressPercent:(CGFloat) percent animated:(BOOL) animated{
    
    [self setProgress:(percent/100)*360 animated:animated];
}

-(void)setProgress:(CGFloat)aProgress{
    
    [self setProgress:aProgress animated:NO];
}


-(void)setProgress:(CGFloat)aProgress animated:(BOOL) animated{
    
    [self setProgress:aProgress animated:animated andDateMode:NO];
}

-(void) updateProgressWithValue:(CGFloat) value andCurrentValue:(CGFloat) current andDateMode:(BOOL) dateMode{
    
    if (dateMode && ([[NSNumber numberWithFloat:current] integerValue] % 33 == 0)){
        int rndValue = 0 + arc4random() % (9);
        self.text = [NSString stringWithFormat:@"%.0d",rndValue];
    }else{
        self.text = [NSString stringWithFormat:@"%.0f",(current*100)/360];
    }
    current++;
    [self setEndPoint:current];
    
    if (self.endPoint <= value){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
            [self updateProgressWithValue:value andCurrentValue:current andDateMode:dateMode];
        });
    }else{
        if (dateMode)
            self.text = [NSString stringWithFormat:@"%.0f",self.daysToGoValue];
    }
}


#pragma mark - Drawing

-(void)drawRect:(CGRect)rect
{
    [self drawProgressLabelCircleInRect:rect];
    [super drawTextInRect:rect];
}

-(void)drawProgressLabelCircleInRect:(CGRect)rect
{
    CGRect circleRect= [self rectForCircle:rect];
    CGFloat archXPos = rect.size.width/2 + rect.origin.x;
    CGFloat archYPos = rect.size.height/2 + rect.origin.y;
    CGFloat archRadius = (circleRect.size.width) / 2.0;
    
    CGFloat trackStartAngle = kDegreesToRadians(0);
    CGFloat trackEndAngle = kDegreesToRadians(360);
    
    CGFloat progressStartAngle;
    CGFloat progressEndAngle;
    
    if(self.unFillMode){
        progressStartAngle=kDegreesToRadians(self.startPoint)-kDegreesToRadians(90);
        progressEndAngle=kDegreesToRadians(self.endPoint)-kDegreesToRadians(90);
        
        CGFloat aux = progressEndAngle;
        progressEndAngle =progressStartAngle;
        progressStartAngle = aux;
        
    }else{
        progressStartAngle= kDegreesToRadians(self.startPoint)-kDegreesToRadians(90);
        progressEndAngle= kDegreesToRadians(self.endPoint)-kDegreesToRadians(90);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Circle
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2));
    CGContextStrokePath(context);
    

    // Line
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, trackStartAngle, trackEndAngle, 1);
    CGContextStrokePath(context);
    
    // Progress
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextSetLineWidth(context, self.progressWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, progressStartAngle, progressEndAngle, 0);
    CGContextStrokePath(context);
    
}

#pragma mark - Helpers

- (float) xPosRoundForAngle:(float) degree andRect:(CGRect) rect
{
    return cosf(kDegreesToRadians(degree))* [self radius]
    - cosf(kDegreesToRadians(degree)) * [self borderDelta]
    + rect.size.width/2;
}

- (float) yPosRoundForAngle:(float) degree andRect:(CGRect) rect
{
    return sinf(kDegreesToRadians(degree))* [self radius]
    - sinf(kDegreesToRadians(degree)) * [self borderDelta]
    + rect.size.height/2;
}

- (float) borderDelta
{
    return MAX(self.lineWidth,self.progressWidth);
}

-(CGRect)rectForCircle:(CGRect)rect
{
    CGFloat minDim = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat circleRadius = (minDim / 2) - [self borderDelta];
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return CGRectMake(circleCenter.x - circleRadius, circleCenter.y - circleRadius, 2 * circleRadius, 2 * circleRadius);
}

@end

