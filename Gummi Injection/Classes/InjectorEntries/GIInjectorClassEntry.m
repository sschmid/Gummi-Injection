//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorClassEntry.h"
#import "GIInjector.h"


@implementation GIInjectorClassEntry
@synthesize asSingleton = _asSingleton;

- (id)extractObject {
    if (self.asSingleton) {
        if (!_singletonCache) {
            _singletonCache = [[_use alloc] init];
            [_injector injectIntoObject:_singletonCache];
        }

        return _singletonCache;
    }

    id instance = [[_use alloc] init];
    [_injector injectIntoObject:instance];
    return instance;
}

@end