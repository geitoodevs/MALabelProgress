# MALabelProgress
UILabel subclass simple circular progress for iOS - Objective C.

![MALabelProgress](https://github.com/miguelappsonline/MALabelProgress/blob/master/Examples/example_one.gif)
![MALabelProgress](https://github.com/miguelappsonline/MALabelProgress/blob/master/Examples/example_two.gif)
![MALabelProgress](https://github.com/miguelappsonline/MALabelProgress/blob/master/Examples/example_three.gif)

## Usage

### Style

```objective-c
// You can customize the lines width, lines color, fill color and label’s font.

-(void) setStyleWithLineWidth:(CGFloat) lineWidth
                progressWidth:(CGFloat) progressWidth
                    lineColor:(UIColor*) lineColor
                progressColor:(UIColor*) progressColor
                    fillColor:(UIColor*) fillColor
                    labelFont:(UIFont*) font;
```

### Update progress value

```objective-c

// Set a percentage of the progress. Values between 0-100.
// The label’s text shows the number of percent 0-100.
-(void) setProgressPercent:(CGFloat) percent
                  animated:(BOOL) animated;

// Set a progress between two dates related to the current date.
// The label’s text shows the number of days left to the end date.
-(void) setProgressWithStartDate:(NSDate*) start
                      andEndDate:(NSDate*) endDate
                   andUnfillMode:(BOOL) unFillMode
                        animated:(BOOL) animated;

```
