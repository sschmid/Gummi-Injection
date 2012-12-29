//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "GIInjectorInstanceEntry.h"
#import "GIInjector.h"


@implementation GIInjectorInstanceEntry

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(GIInjector *)injector {
    self = [super initWithObject:whenAskedFor mappedTo:use injector:injector];
    if (self) {
        [_injector injectIntoObject:_use];
    }

    return self;
}

@end