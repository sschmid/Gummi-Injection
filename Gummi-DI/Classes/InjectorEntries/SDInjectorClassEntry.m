//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorClassEntry.h"
#import "SDInjector.h"


@interface SDInjectorClassEntry ()
@property(nonatomic) BOOL asSingleton;
@property(nonatomic, strong) id singletonCache;

@end

@implementation SDInjectorClassEntry
@synthesize asSingleton = _asSingleton;
@synthesize singletonCache = _singletonCache;

+ (id)entryWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton {
    return [[self alloc] initWithObject:object injector:injector asSingleton:asSingleton];
}

- (id)initWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton {
    self = [super initWithObject:object injector:injector];
    if (self) {
        self.asSingleton = asSingleton;
    }

    return self;
}

- (id)extractObject {
    if (self.asSingleton) {
        if (!self.singletonCache) {
            self.singletonCache = [[self.object alloc] init];
            [_injector injectIntoObject:self.singletonCache];
        }

        return self.singletonCache;
    }

    id instance = [[self.object alloc] init];
    [_injector injectIntoObject:instance];
    return instance;
}

@end