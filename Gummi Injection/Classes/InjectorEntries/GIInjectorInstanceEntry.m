//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorInstanceEntry.h"
#import "GIInjector.h"


@implementation GIInjectorInstanceEntry

- (id)initWithObject:(id)object mappedTo:(id)whenAskedFor injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:whenAskedFor injector:injector];
    if (self) {
        [_injector injectIntoObject:_object];
    }

    return self;
}

@end