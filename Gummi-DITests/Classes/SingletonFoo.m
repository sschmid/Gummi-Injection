//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "SDInjector.h"


static BOOL sToggle;

@implementation SingletonFoo
inject(@"bar")
@synthesize bar = _bar;

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