//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorBlockEntry.h"
#import "GIInjector.h"
#import "GRReflection.h"

@interface GIInjectorBlockEntry ()
@property(nonatomic) BOOL asSingleton;
@property(nonatomic) id singletonCache;
@end

@implementation GIInjectorBlockEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject asSingleton:(BOOL)singleton injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        self.asSingleton = singleton;
    }

    return self;
}

- (id)extractObjectWithArgs:(NSArray *)args {
    if (self.asSingleton) {
        if (!self.singletonCache) {
            GIFactoryBlock(factoryBlock) = _object;
            self.singletonCache = factoryBlock(_injector, args);
            [_injector injectIntoObject:self.singletonCache];
        }

        return self.singletonCache;
    }

    GIFactoryBlock(factoryBlock) = _object;
    id instance = factoryBlock(_injector, args);
    [_injector injectIntoObject:instance];
    return instance;
}

@end