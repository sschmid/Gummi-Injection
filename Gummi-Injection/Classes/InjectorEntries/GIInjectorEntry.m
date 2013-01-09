//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorEntry.h"
#import "GIInjector.h"


@implementation GIInjectorEntry
@synthesize object = _object;
@synthesize keyObject = _keyObject;

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        _object = object;
        _keyObject = keyObject;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return _object;
}

@end