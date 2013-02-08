//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorClassEntry.h"
#import "GIInjector.h"
#import "GRReflection.h"

@interface GIInjectorClassEntry ()
@property(nonatomic) BOOL asSingleton;
@property(nonatomic) id singletonCache;
@end

@implementation GIInjectorClassEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject asSingleton:(BOOL)singleton injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        if ([GRReflection isProtocol:keyObject] && ![object conformsToProtocol:keyObject])
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
                                           reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(keyObject)]
                                         userInfo:nil];

        self.asSingleton = singleton;
    }

    return self;
}

- (id)extractObject {
    if (self.asSingleton) {
        if (!self.singletonCache) {
            self.singletonCache = [_injector instantiateClass:_object];
            [_injector injectIntoObject:self.singletonCache];
        }

        return self.singletonCache;
    }

    id instance = [_injector instantiateClass:_object];
    [_injector injectIntoObject:instance];
    return instance;
}

@end