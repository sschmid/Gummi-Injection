//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SingletonFoo.h"
#import "GIInjector.h"

static BOOL sToggle;

@implementation SingletonFoo
inject(@"bar")

+ (BOOL)isInitialized {
    return sToggle;
}

- (id)init {
    self = [super init];
    if (self) {
        sToggle = !sToggle;
    }

    return self;
}

@end