//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorClassEntry.h"
#import "SDInjector.h"


@interface SDInjectorClassEntry ()
@property(nonatomic) BOOL asSingleton;
@property(nonatomic, strong) id objectCache;


@end

@implementation SDInjectorClassEntry
@synthesize asSingleton = _asSingleton;
@synthesize objectCache = _objectCache;


+ (id)entryWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton{
    return [[self alloc] initWithObject:object injector:injector asSingleton:asSingleton];
}

- (id)initWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton {
    self = [super initWithObject:object injector:injector];
    if (self) {
        self.asSingleton = asSingleton;
    }

    return self;}

- (id)extractObject {
    if (self.asSingleton) {
        if (!self.objectCache) {
            self.objectCache = [[self.object alloc] init];
            [_injector injectIntoObject:self.objectCache];
        }

        return self.objectCache;
    }

    id instance = [[self.object alloc] init];
    [_injector injectIntoObject:instance];
    return instance;
}

@end