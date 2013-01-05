//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorEntryFactory.h"
#import "GIInjectorEntry.h"
#import "GIInjectorInstanceEntry.h"
#import "GIReflector.h"
#import "GIInjectorClassEntry.h"
#import "GIInjector.h"


@interface GIInjectorEntryFactory ()
@property(nonatomic, strong) GIInjector *injector;
@end

@implementation GIInjectorEntryFactory
@synthesize injector = _injector;

- (id)initWithInjector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        self.injector = injector;
    }

    return self;
}

- (GIInjectorEntry *)createEntryForObject:(id)whenAskedFor mappedTo:(id)use asSingleton:(BOOL)asSingleton {
    if ([GIReflector isProtocol:use])
        @throw [NSException exceptionWithName:@"GIInjectorEntryFactoryException" reason:[NSString stringWithFormat:@"You cannot create an injector entry using protocols (<%@>)", NSStringFromProtocol(use)] userInfo:nil];

    if ([GIReflector isClass:use]) {
        GIInjectorClassEntry *entry = [[GIInjectorClassEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self.injector];
        entry.asSingleton = asSingleton;
        return entry;
    } else if ([GIReflector isInstance:use]) {
        return [[GIInjectorInstanceEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self.injector];
    }

    return nil;
}

@end