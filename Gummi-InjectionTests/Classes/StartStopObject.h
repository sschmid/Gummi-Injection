//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface StartStopObject : NSObject
@property(nonatomic) BOOL started;

- (void)start;
- (void)stop;
@end