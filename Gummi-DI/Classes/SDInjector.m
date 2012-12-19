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
#import "SDModule.h"

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

- (SDInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    [self validateMapping:whenAskedFor with:use];
    SDInjectorEntry *entry = [self createEntryForObject:use asSingleton:NO];
    self.context[[self keyForObject:whenAskedFor]] = entry;
    return entry;
}

- (SDInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    [self validateMapping:whenAskedFor with:use];
    SDInjectorEntry *entry = [self createEntryForObject:use asSingleton:YES];
    self.context[[self keyForObject:whenAskedFor]] = entry;
    if (!lazy)
        [self getObject:whenAskedFor];

    return entry;
}

- (BOOL)is:(id)whenAskedFor mappedTo:(id)use {
    SDInjectorEntry *entry = self.context[[self keyForObject:whenAskedFor]];
    return [entry.object isEqual:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    if ([self is:whenAskedFor mappedTo:use])
        [self.context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (void)validateMapping:(id)whenAskedFor with:(id)use {
    if ([SDReflector isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, [self keyForObject:whenAskedFor]] userInfo:nil];
}

- (NSDictionary *)getDependenciesForObject:(id)object withProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties)
        dependencies[propertyName] = [self getObject:[SDReflector getTypeForProperty:propertyName ofClass:[object class]]];

    return dependencies;
}

- (id)createObjectForType:(id)type {
    if ([SDReflector isProtocol:type])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Can not create an object for <%@>. Make sure you have set up a rule for it", NSStringFromProtocol(type)] userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
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

- (NSString *)keyForObject:(id)object {
    if ([SDReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}


#pragma mark Modules
- (void)addModule:(SDModule *)module {
    [module configure:self];
}


@end