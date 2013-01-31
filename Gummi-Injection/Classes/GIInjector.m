//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GRReflection.h"
#import "GIModule.h"
#import "GIInjectorEntryFactory.h"

static GIInjector *sInjector;

@interface GIInjector ()
@property(nonatomic, weak) GIInjector *parentInjector;
@property(nonatomic, strong) NSMutableDictionary *context;
@property(nonatomic, strong) NSMutableDictionary *propertyNames;
@property(nonatomic, strong) NSMutableArray *modules;
@property(nonatomic, strong) GIInjectorEntryFactory *entryFactory;
@end

@implementation GIInjector

+ (GIInjector *)sharedInjector {
    if (!sInjector)
        sInjector = [[GIInjector alloc] init];

    return sInjector;
}

- (id)init {
    self = [super init];
    if (self) {
        self.context = [[NSMutableDictionary alloc] init];
        self.propertyNames = [[NSMutableDictionary alloc] init];
        self.modules = [[NSMutableArray alloc] init];
        self.entryFactory = [[GIInjectorEntryFactory alloc] initWithInjector:self];
    }

    return self;
}

- (GIInjector *)createChildInjector {
    GIInjector *childInjector = [[GIInjector alloc] init];
    childInjector.parentInjector = self;
    return childInjector;
}

- (void)addDependencies:(NSArray *)propertyNames forClass:(id)aClass {
    NSMutableSet *propertyNamesForClass = [self getPropertyNamesForClass:aClass];
    [propertyNamesForClass unionSet:[NSSet setWithArray:propertyNames]];
}

- (id)getObject:(id)keyObject {
    if (!keyObject)
        return nil;

    GIInjectorEntry *entry = [self entryForKeyObject:keyObject];
    if (!entry)
        return [self createObjectForType:keyObject];

    return entry.extractObject;
}

- (void)injectIntoObject:(id)object {
    NSMutableSet *properties = [self mergedPropertyNamesForClass:[object class]];
    [object setValuesForKeysWithDictionary:[self getDependenciesOfClass:[object class] forProperties:properties]];
    [self notifyObjectOfInjectionComplete:object];
}

- (void)map:(id)object to:(id)keyObject {
    GIInjectorEntry *entry = [self.entryFactory createEntryForObject:object mappedTo:keyObject asSingleton:NO];
    self.context[[self keyForObject:entry.keyObject]] = entry;
}

- (void)mapSingleton:(id)object to:(id)keyObject {
    GIInjectorEntry *entry = [self.entryFactory createEntryForObject:object mappedTo:keyObject asSingleton:YES];
    self.context[[self keyForObject:entry.keyObject]] = entry;
}

- (void)mapEagerSingleton:(id)object to:(id)keyObject {
    [self mapSingleton:object to:keyObject];
    [self getObject:object];
}

- (BOOL)isObject:(id)object mappedTo:(id)keyObject {
    GIInjectorEntry *entry = self.context[[self keyForObject:keyObject]];
    return [entry.object isEqual:object];
}

- (void)unMap:(id)object from:(id)keyObject {
    if ([self isObject:object mappedTo:keyObject])
        [self.context removeObjectForKey:[self keyForObject:keyObject]];
}

- (GIInjectorEntry *)entryForKeyObject:(id)keyObject {
    GIInjectorEntry *entry = self.context[[self keyForObject:keyObject]];
    if (!entry)
        entry = [self.parentInjector entryForKeyObject:keyObject];

    return entry;
}

- (NSMutableSet *)getPropertyNamesForClass:(Class)aClass {
    NSString *key = [self keyForObject:aClass];
    NSMutableSet *propertyNames = self.propertyNames[key];
    if (!propertyNames) {
        propertyNames = [[NSMutableSet alloc] init];
        self.propertyNames[key] = propertyNames;
    }

    return propertyNames;
}

- (NSMutableSet *)mergedPropertyNamesForClass:(Class)aClass {
    NSMutableSet *propertyNamesForClass = [self getPropertyNamesForClass:aClass];
    if ([aClass respondsToSelector:@selector(requiredProperties:)])
        [aClass performSelector:@selector(requiredProperties:) withObject:self];

    id superClass = class_getSuperclass(aClass);
    while (superClass != nil) {
        NSMutableSet *parentDependencies = [self getPropertyNamesForClass:superClass];
        if ([superClass respondsToSelector:@selector(requiredProperties:)])
            [superClass performSelector:@selector(requiredProperties:) withObject:self];

        [propertyNamesForClass unionSet:parentDependencies];
        superClass = class_getSuperclass(superClass);
    }

    return propertyNamesForClass;
}

- (NSDictionary *)getDependenciesOfClass:(id)aClass forProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties)
        dependencies[propertyName] = [self getObject:[GRReflection getTypeForProperty:propertyName ofClass:aClass]];

    return dependencies;
}

- (void)notifyObjectOfInjectionComplete:(id)object {
    if ([[object class] respondsToSelector:@selector(injectionCompleteSelector)]) {
        NSString *onCompleteSelectorName = [[object class] performSelector:@selector(injectionCompleteSelector)];
        SEL onCompleteSelector = NSSelectorFromString(onCompleteSelectorName);
        if (![object respondsToSelector:onCompleteSelector])
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
                                           reason:[NSString stringWithFormat:@"Object '%@' does not respond to selector '%@'",
                                                           NSStringFromClass([object class]), onCompleteSelectorName]
                                         userInfo:nil];
        else
            [object performSelector:onCompleteSelector];
    }
}

- (id)createObjectForType:(id)type {
    if ([GRReflection isProtocol:type])
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
                                       reason:[NSString stringWithFormat:@"Can not create an object for <%@>. Make sure you have set up a rule for it",
                                                       NSStringFromProtocol(type)]
                                     userInfo:nil];

    id object = [[type alloc] init];
    [self injectIntoObject:object];
    return object;
}

- (NSString *)keyForObject:(id)object {
    if ([GRReflection isProtocol:object])
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
        if ([module isKindOfClass:moduleClass])
            [self removeModule:module];
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
    for (GIModule *module in [self.modules copy])
        [self removeModule:module];

    [self.context removeAllObjects];
}

@end