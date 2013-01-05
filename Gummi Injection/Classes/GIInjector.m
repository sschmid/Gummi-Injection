//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GIReflector.h"
#import "GIModule.h"
#import "GIInjectorEntryFactory.h"

static GIInjector *sInjector;

@interface GIInjector ()
@property(nonatomic, strong) NSMutableDictionary *context;
@property(nonatomic, strong) NSMutableArray *modules;
@property(nonatomic, strong) GIInjectorEntryFactory *entryFactory;
@end

@implementation GIInjector
@synthesize context = _context;
@synthesize modules = _modules;
@synthesize entryFactory = _entryFactory;

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
        self.entryFactory = [[GIInjectorEntryFactory alloc] initWithInjector:self];
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
    GIInjectorEntry *entry = [self.entryFactory createEntryForObject:whenAskedFor mappedTo:use asSingleton:NO];
    self.context[[self keyForObject:entry.whenAskedFor]] = entry;
    return entry;
}

- (GIInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    GIInjectorEntry *entry = [self.entryFactory createEntryForObject:whenAskedFor mappedTo:use asSingleton:YES];
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
        @throw [NSException exceptionWithName:@"GIInjectorException" reason:[NSString stringWithFormat:@"Can not create an object for <%@>. Make sure you have set up a rule for it", NSStringFromProtocol(type)] userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
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

- (void)reset {
    [self.context removeAllObjects];
    [self.modules removeAllObjects];
}

@end