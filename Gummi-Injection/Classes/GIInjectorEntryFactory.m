//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorEntryFactory.h"
#import "GIInjectorEntry.h"
#import "GIInjectorInstanceEntry.h"
#import "GRReflection.h"
#import "GIInjectorClassEntry.h"
#import "GIInjector.h"
#import "GIInjectorBlockEntry.h"

@interface GIInjectorEntryFactory ()
@property(nonatomic, strong) GIInjector *injector;
@end

@implementation GIInjectorEntryFactory

- (id)initWithInjector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        self.injector = injector;
    }

    return self;
}

- (GIInjectorEntry *)createEntryForObject:(id)object mappedTo:(id)keyObject asSingleton:(BOOL)asSingleton {
    if ([GRReflection isProtocol:object])
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
                                       reason:[NSString stringWithFormat:@"You cannot create an injector entry using protocols (<%@>)", NSStringFromProtocol(object)]
                                     userInfo:nil];

    if ([GRReflection isClass:object]) {
        GIInjectorClassEntry *entry = [[GIInjectorClassEntry alloc] initWithObject:object mappedTo:keyObject injector:self.injector];
        entry.asSingleton = asSingleton;
        return entry;
    }
    else if ([GRReflection isBlock:object]) {
        return [[GIInjectorBlockEntry alloc] initWithObject:object mappedTo:keyObject injector:self.injector];
    }
    else if ([GRReflection isInstance:object]) {
        return [[GIInjectorInstanceEntry alloc] initWithObject:object mappedTo:keyObject injector:self.injector];
    }

    return nil;
}

@end