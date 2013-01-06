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

- (GIInjectorEntry *)createEntryForObject:(id)object mappedTo:(id)whenAskedFor asSingleton:(BOOL)asSingleton {
    if ([GIReflector isProtocol:object])
        @throw [NSException exceptionWithName:@"GIInjectorEntryFactoryException" reason:[NSString stringWithFormat:@"You cannot create an injector entry using protocols (<%@>)", NSStringFromProtocol(object)] userInfo:nil];

    if ([GIReflector isClass:object]) {
        GIInjectorClassEntry *entry = [[GIInjectorClassEntry alloc] initWithObject:object mappedTo:whenAskedFor injector:self.injector];
        entry.asSingleton = asSingleton;
        return entry;
    } else if ([GIReflector isInstance:object]) {
        return [[GIInjectorInstanceEntry alloc] initWithObject:object mappedTo:whenAskedFor injector:self.injector];
    }

    return nil;
}

@end