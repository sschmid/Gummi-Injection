//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorClassEntry.h"
#import "SDInjector.h"


@implementation SDInjectorClassEntry
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