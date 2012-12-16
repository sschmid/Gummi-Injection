//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorEntry.h"
#import "SDInjector.h"


@implementation SDInjectorEntry
@synthesize object = _object;

+ (id)entryWithObject:(id)object injector:(SDInjector *)injector {
    return [[self alloc] initWithObject:object injector:injector];
}

- (id)initWithObject:(id)object injector:(SDInjector *)injector {
    self = [super init];
    if (self) {
        self.object = object;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return self.object;
}

@end