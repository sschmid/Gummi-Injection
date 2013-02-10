//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Ball.h"

@implementation Ball

- (id)initAlternative {
    self = [self initWithColor:@"green"];
    return self;
}

- (id)initWithColor:(NSString *)color {
    self = [super init];
    if (self) {
        self.color = color;
    }

    return self;
}

@end