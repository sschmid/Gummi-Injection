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
@property(nonatomic, strong) NSMutableArray *modules;

@end

@implementation SDInjector
@synthesize context = _context;
@synthesize modules = _modules;


+ (SDInjector *)sharedInjector {
    if (!sInjector)
        sInjector = [[SDInjector alloc] init];
    return sInjector;
}

- (id)init {
    self = [super init];
    if (self) {
        self.context = [[NSMutableDictionary alloc] init];
        self.modules = [[NSMutableArray alloc] init];
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
    SDInjectorEntry *entry = [self createEntryForObject:whenAskedFor mappedTo:use asSingleton:NO];
    self.context[[self keyForObject:entry.whenAskedFor]] = entry;
    return entry;
}

- (SDInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    SDInjectorEntry *entry = [self createEntryForObject:whenAskedFor mappedTo:use asSingleton:YES];
    self.context[[self keyForObject:entry.whenAskedFor]] = entry;
    if (!lazy)
        [self getObject:whenAskedFor];

    return entry;
}

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use {
    SDInjectorEntry *entry = self.context[[self keyForObject:whenAskedFor]];
    return [entry.use isEqual:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    if ([self isObject:whenAskedFor mappedTo:use])
        [self.context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (NSDictionary *)getDependenciesForObject:(id)object withProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties)
        dependencies[propertyName] = [self getObject:[SDReflector getTypeForProperty:propertyName ofClass:[object class]]];

    return dependencies;
}

- (id)createObjectForType:(id)type {
    if ([SDReflector isProtocol:type])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Can not create an object for <%@>. Make sure you have set up a rule for it", type] userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
}

- (SDInjectorEntry *)createEntryForObject:(id)whenAskedFor mappedTo:(id)use asSingleton:(BOOL)asSingleton {
    if ([SDReflector isProtocol:use])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"You can't map protocols (Tried to map <%@>)", use] userInfo:nil];

    if ([SDReflector isClass:use]) {
        SDInjectorClassEntry *entry = [[SDInjectorClassEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self];
        entry.asSingleton = asSingleton;
        return entry;
    } else if ([SDReflector isInstance:use]) {
        return [[SDInjectorInstanceEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self];
    }

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
    [self.modules addObject:module];
}

- (void)removeModule:(SDModule *)module {
    [module unload];
    [self.modules removeObject:module];
}

- (void)removeModuleClass:(Class)moduleClass {
    for (SDModule *module in [self.modules copy]) {
        if ([module isKindOfClass:moduleClass]) {
            [self removeModule:module];
            return;
        }
    }
}

- (BOOL)hasModule:(SDModule *)module {
    return [self.modules containsObject:module];
}

- (BOOL)hasModuleClass:(Class)moduleClass {
    for (SDModule *module in self.modules)
        if ([module isKindOfClass:moduleClass])
            return YES;

    return NO;
}

@end