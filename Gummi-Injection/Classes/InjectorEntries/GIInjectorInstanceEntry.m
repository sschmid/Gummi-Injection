//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorInstanceEntry.h"
#import "GIInjector.h"


@implementation GIInjectorInstanceEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        [_injector injectIntoObject:_object];
    }

    return self;
}

@end