//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorEntry.h"
#import "GIInjector.h"

@implementation GIInjectorEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        _object = object;
        _keyObject = keyObject;
        _injector = injector;
    }

    return self;
}

- (id)extractObjectWithArgs:(NSArray *)args {
    return _object;
}

@end