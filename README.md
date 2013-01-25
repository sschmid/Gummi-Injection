# Gummi Injection
![Gummi Injection Logo](http://sschmid.com/Libs/Gummi-Injection/Gummi-Injection-128.png)

## Description
Gummi Injection is a lightweight dependency injection framework for Objective-C.

## Dependencies
Gummi-Injection uses [Gummi Reflection](https://github.com/sschmid/Gummi-Reflection) to inspect objects.

## Features
* Add and remove injection rules (mappings) at any time
* One api for different kind of mappings ([injector map: to:])
* Inject into existing objects
* Extend injector context with modules
* Add or remove modules at any time
* Map blocks to classes or protocols
* Map singletons and eager singletons
* Handles circular dependencies for singletons
* Injector can create unmapped dependencies, when they can be created like this [[MyObject alloc] init]
* Specify a custom selector for objects to get notified when injection is complete
* Child Injector

## How to use Gummi Injection

#### Get an injector

```objective-c
// Create your own injector
GIInjector *injector = [[GIInjector alloc] init];

// or use the shared injector
GIInjector *injector = [GIInjector sharedInjector];

// Child Injector
GIInjector *childInjector = [injector createChildInjector];

```

#### Add injection rules [injector map:object to:keyObject]

```objective-c
// Map classes
[injector map:[MyImplementation class] to:@protocol(MyProtocol)];

// You don't have to do this. Gummi Injection will figure it out itself.
[injector map:[MyImplementation class] to:[MyImplementation class]];

// But you could do this
[injector map:[MyImplementation1 class] to:[MyImplementation2 class]];

// Map instances
[injector map:car to:[Car class]]
[injector map:car to:@protocol(Vehicle)]

// Map singletons and eager singletons.
// Eager singletons will be instantiated immediately
[injector mapEagerSingleton:[Service class] to:@protocol(RemoteService)];
[injector mapSingleton:[Model class] to:[Model class]];

// Map blocks
id (^factoryBlock)(GIInjector *) = ^(GIInjector *injector) {
    id stuff = [injector getObject:[SomeStuff class]];
    Car *car = [[Car alloc] initWithStuff:stuff];
    return car;
};
[injector map:factoryBlock to:@protocol(Vehicle)];

// You can remove mappings at any time
[injector unMap:[Service class] from:@protocol(RemoteService)];
```

#### Mark properties for injection with "inject"

```objective-c
@class Wheel;

@interface Car : NSObject <Vehicle>
@property(nonatomic, strong) Wheel *wheel1;
@property(nonatomic, strong) Wheel *wheel2;
@property(nonatomic, strong) Wheel *wheel3;
@property(nonatomic, strong) Wheel *wheel4;
@property(nonatomic) id <Motor> motor;
@end

@implementation Car

inject(@"wheel1", @"wheel2", @"wheel3", @"wheel4", @"motor");

// Optional selector gets performed, when injection is complete
injection_complete(@selector(startEngine))

- (void)startEngine {
    if (self.motor)
        NSLog(@"[%@] Brrrmmmmm....", NSStringFromClass([self class]));
}

...
@end
```

#### Create an object with all dependencies set
When an object gets created by calling injector#getObject, all its dependencies will be satisfied as well.

```objective-c
// No need to set up rules for simple injections like Wheel
// that can be created with alloc init.
// For protocols there's no way to know which implementation to return -
// we need to set up a rule for it.
[injector map:[HybridMotor class] to:@protocol(Motor)];

Car *car = [injector getObject:[Car class]];

// or use protocols
[injector map:[Car class] to:@protocol(Vehicle)];
Car *car = [injector getObject:@protocol(Vehicle)];

// or inject into existing objects
Car *car = [[Car alloc] init];
[injector injectIntoObject:car];

// This will happen:
// - getObject looks up type Car -> no rule set -> Instantiate Car and inject into object
//     - Each Car wants Wheels
//         - Look up type Wheel -> no rule set -> Instantiate Wheel and inject into object
//     - Car wants <Motor>
//         - Look up type <Motor> -> rule found: [HybridMotor class]
//         - Instantiate HybridMotor and inject into object
// Done


```

## Modules
Modules are a wrapper for related mappings. They extend the context of the injector and can be added and removed at any time.

```objective-c
GIModule *module = [[GameModule alloc] init];
[injector addModule:module];

// After the game, remove the Module by class
[injector removeModuleClass:[GameModule class]];
// or by instance
[injector removeModule:gameModule];
```

```objective-c
@interface GameModule : GIModule
@end

@implementation GameModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[MyGameModel class]
                    to:@protocol(GameModel)];
    
    // Example Service starts automatically on init
    [self mapEagerSingleton:[MyRemoteService class]
                         to:@protocol(RemoteService)];
}

- (void)unload {
    // For convenience, close all connections to stop service
    Service *service = [_injector getObject:@protocol(RemoteService)];
    [service close];

    [super unload];
}

- (void)dealloc {
    NSLog(@"Service and Model get dealloced with me.");
}

@end
```

## Install Gummi Injection
You find the source files you need in Gummi-Injection/Classes.

You also need:
* [Gummi Reflection] (https://github.com/sschmid/Gummi-Reflection) - Reflection for Objective-C

## CocoaPods
Install [CocoaPods] (http://cocoapods.org) and add the Gummi Injection reference to your Podfile

```
platform :ios, '5.0'
  pod 'Gummi-Injection'
end
```

#### Add this remote

```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

#### Install Gummi Injection

```
$ cd path/to/project
$ pod install
```
Open the created Xcode Workspace file.

## Projects that use Gummi Injection
* [Gummi Commander] (https://github.com/sschmid/Gummi-Commander) Event Command Mapping System for Objective-C