//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjector.h"
#import "SDInjectorEntry.h"
#import "SDInjectorClassEntry.h"
#import "SDInjectorInstanceEntry.h"
#import "SDReflector.h"

static NSString *const SDInjectorException = @"SDInjectorException";
static SDInjector *sInjector;

@interface SDInjector ()
@property(nonatomic, strong) NSMutableDictionary *context;
@end

@implementation SDInjector
@synthesize context = _context;

+ (SDInjector *)sharedInjector {
    if (!sInjector)
        sInjector = [[SDInjector alloc] init];
    return sInjector;
}

- (id)init {
    self = [super init];
    if (self) {
        self.context = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)getObject:(id)type {
    if (!type)
        return nil;

    SDInjectorEntry *entry = self.context[[self keyForObject:type]];
    if (!entry)
        return [self createObjectForType:type];

    return entry.extractObject;
}

- (void)injectIntoObject:(id)object {
    if ([[object class] respondsToSelector:@selector(desiredProperties)]) {
        NSSet *properties = [[object class] performSelector:@selector(desiredProperties)];
        [object setValuesForKeysWithDictionary:[self getDependenciesForObject:object withProperties:properties]];
    }
}

- (NSDictionary *)getDependenciesForObject:(id)object withProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties) {
        id propertyType = [SDReflector getTypeForProperty:propertyName ofClass:[object class]];
        id dependency = [self getObject:propertyType];
        if (!dependency)
            dependency = [self createObjectForType:propertyType];

        dependencies[propertyName] = dependency;
    }

    return dependencies;
}

- (id)createObjectForType:(id)type {
    if ([SDReflector isProtocol:type])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Can not retrieve object from context for <%@>. Make sure you have set up a rule for it", NSStringFromProtocol(type)] userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
}

- (void)map:(id)whenAskedFor to:(id)use asSingleton:(BOOL)asSingleton {
    if ([SDReflector isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, [self keyForObject:whenAskedFor]] userInfo:nil];

    self.context[[self keyForObject:whenAskedFor]] = [self createEntryForObject:use asSingleton:asSingleton];
}

- (SDInjectorEntry *)createEntryForObject:(id)object asSingleton:(BOOL)asSingleton {
    if ([SDReflector isProtocol:object])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"You can't map protocols (Tried to map <%@>)", NSStringFromProtocol(object)] userInfo:nil];

    if ([SDReflector isClass:object])
        return [SDInjectorClassEntry entryWithObject:object injector:self asSingleton:asSingleton];
    else if ([SDReflector isInstance:object])
        return [SDInjectorInstanceEntry entryWithObject:object injector:self];

    return nil;
}

- (void)map:(id)whenAskedFor to:(id)use {
    return [self map:whenAskedFor to:use asSingleton:NO];
}

- (void)mapSingleton:(Class)aClass {
    return [self map:aClass to:aClass asSingleton:YES];
}

- (void)mapEagerSingleton:(Class)aClass {
    [self mapSingleton:aClass];
    [self getObject:aClass];
}

- (BOOL)is:(id)whenAskedFor mappedTo:(id)use {
    SDInjectorEntry *entry = self.context[[self keyForObject:whenAskedFor]];
    return [entry.object isEqual:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    if ([self is:whenAskedFor mappedTo:use])
        [self.context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (NSString *)keyForObject:(id)object {
    if ([SDReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end