//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorClassEntry.h"
#import "GIInjector.h"
#import "GRReflection.h"

@implementation GIInjectorClassEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        if ([GRReflection isProtocol:keyObject] && ![object conformsToProtocol:keyObject])
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
                                           reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(keyObject)]
                                         userInfo:nil];
    }

    return self;
}

- (id)extractObject {
    if (self.asSingleton) {
        if (!_singletonCache) {
            _singletonCache = [_injector instantiateClass:_object];
            [_injector injectIntoObject:_singletonCache];
        }

        return _singletonCache;
    }

    id instance = [_injector instantiateClass:_object];
    [_injector injectIntoObject:instance];
    return instance;
}

@end