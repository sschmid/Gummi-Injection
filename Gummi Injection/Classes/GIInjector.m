//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GIInjectorClassEntry.h"
#import "GIInjectorInstanceEntry.h"
#import "GIReflector.h"
#import "GIModule.h"

static NSString *const GIInjectorException = @"GIInjectorException";
static GIInjector *sInjector;

@interface GIInjector ()
@property(nonatomic, strong) NSMutableDictionary *context;
@property(nonatomic, strong) NSMutableArray *modules;
@end

@implementation GIInjector
@synthesize context = _context;
@synthesize modules = _modules;

+ (GIInjector *)sharedInjector {
    if (!sInjector)
        sInjector = [[GIInjector alloc] init];
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

    GIInjectorEntry *entry = self.context[[self keyForObject:type]];
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

- (GIInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    GIInjectorEntry *entry = [self createEntryForObject:whenAskedFor mappedTo:use asSingleton:NO];
    self.context[[self keyForObject:entry.whenAskedFor]] = entry;
    return entry;
}

- (GIInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    GIInjectorEntry *entry = [self createEntryForObject:whenAskedFor mappedTo:use asSingleton:YES];
    self.context[[self keyForObject:entry.whenAskedFor]] = entry;
    if (!lazy)
        [self getObject:whenAskedFor];

    return entry;
}

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use {
    GIInjectorEntry *entry = self.context[[self keyForObject:whenAskedFor]];
    return [entry.use isEqual:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    if ([self isObject:whenAskedFor mappedTo:use])
        [self.context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (NSDictionary *)getDependenciesForObject:(id)object withProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties)
        dependencies[propertyName] = [self getObject:[GIReflector getTypeForProperty:propertyName ofClass:[object class]]];

    return dependencies;
}

- (id)createObjectForType:(id)type {
    if ([GIReflector isProtocol:type])
        @throw [NSException exceptionWithName:GIInjectorException reason:[NSString stringWithFormat:@"Can not create an object for <%@>. Make sure you have set up a rule for it", type] userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
}

- (GIInjectorEntry *)createEntryForObject:(id)whenAskedFor mappedTo:(id)use asSingleton:(BOOL)asSingleton {
    if ([GIReflector isProtocol:use])
        @throw [NSException exceptionWithName:GIInjectorException reason:[NSString stringWithFormat:@"You can't map protocols (Tried to map <%@>)", use] userInfo:nil];

    if ([GIReflector isClass:use]) {
        GIInjectorClassEntry *entry = [[GIInjectorClassEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self];
        entry.asSingleton = asSingleton;
        return entry;
    } else if ([GIReflector isInstance:use]) {
        return [[GIInjectorInstanceEntry alloc] initWithObject:whenAskedFor mappedTo:use injector:self];
    }

    return nil;
}

- (NSString *)keyForObject:(id)object {
    if ([GIReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}


#pragma mark Modules
- (void)addModule:(GIModule *)module {
    [module configure:self];
    [self.modules addObject:module];
}

- (void)removeModule:(GIModule *)module {
    [module unload];
    [self.modules removeObject:module];
}

- (void)removeModuleClass:(Class)moduleClass {
    for (GIModule *module in [self.modules copy]) {
        if ([module isKindOfClass:moduleClass]) {
            [self removeModule:module];
            return;
        }
    }
}

- (BOOL)hasModule:(GIModule *)module {
    return [self.modules containsObject:module];
}

- (BOOL)hasModuleClass:(Class)moduleClass {
    for (GIModule *module in self.modules)
        if ([module isKindOfClass:moduleClass])
            return YES;

    return NO;
}

@end