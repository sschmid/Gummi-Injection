//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorInstanceEntry.h"
#import "SDInjector.h"


@implementation SDInjectorInstanceEntry

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(SDInjector *)injector {
    self = [super initWithObject:whenAskedFor mappedTo:use injector:injector];
    if (self) {
        [_injector injectIntoObject:_use];
    }

    return self;
}

@end