//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "OtherBall.h"
#import "GIInjector.h"

@implementation OtherBall

injection_defaultInitializer(@selector(initAlternative))

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