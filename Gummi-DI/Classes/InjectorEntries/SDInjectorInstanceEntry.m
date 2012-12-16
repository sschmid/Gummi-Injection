//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorInstanceEntry.h"
#import "SDInjector.h"


@implementation SDInjectorInstanceEntry

- (id)initWithObject:(id)object injector:(SDInjector *)injector {
    self = [super init];
    if (self) {
        self.object = object;
        _injector = injector;
        [_injector injectIntoObject:self.object];
    }

    return self;
}

@end