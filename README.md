## Gummi Injection
![Gummi Injection Logo](http://sschmid.com/Gummi/Gummi-Injection/Gummi-Injection-128.png)

Gummi Injection is a lightweight dependency injection framework for Objective-C.

## Features
* Add and remove mappings at any time
* One api for different kind of mappings ([injector map: to:])
* Inject into existing objects
* Extend injector context with modules
* Add or remove modules at any time
* Instantiate singletons lazily or not
* Handles circular dependencies for singletons
* Can handle unmapped dependencies, when they can be created like this [[MyObject alloc] init]

## How to use Gummi Injection

#### Get an injector
```objective-c
// Create your own injector
GIInjector *injector = [[GIInjector alloc] init];

// or use the shared injector
GIInjector *injector = [GIInjector sharedInjector];
```

#### Add rules to injector [injector map:object to:whenAskedFor]
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

// Map singletons lazily or not
[injector mapSingleton:[Service class] to:@protocol(RemoteService) lazy:NO];
[injector mapSingleton:[Model class] to:[Model class] lazy:YES];

// You can remove mappings at any time
[injector unMap:[Service class] from:@protocol(RemoteService)];
```

#### Mark properties for injection with "inject"
```objective-c
@interface Car : NSObject <Vehicle>
@property(nonatomic, strong) Wheel *leftFrontWheel;
@property(nonatomic, strong) Wheel *rightFrontWheel;
@property(nonatomic, strong) Wheel *leftRearWheel;
@property(nonatomic, strong) Wheel *rightRearWheel;
@property(nonatomic) id <Motor> motor;
@end


@implementation Car

inject(@"leftFrontWheel", @"rightFrontWheel", @"leftRearWheel", @"rightRearWheel", @"motor");

@synthesize leftFrontWheel = _leftFrontWheel;
@synthesize rightFrontWheel = _rightFrontWheel;
@synthesize leftRearWheel = _leftRearWheel;
@synthesize rightRearWheel = _rightRearWheel;
@synthesize motor = _motor;

…
@end
```

#### Create an object with all dependencies set
When an object gets created by calling injector#getObject, all its dependecies will be satisfied as well.
```objective-c
// No need to set up rules for simple injections like Wheel that can be created with alloc init.
// For protocols there's no way to know which implementation to return - we need to set up a rule for it.
[injector map:[HybridMotor class] to:@protocol(Motor)];

Car *car = [injector getObject:[Car class]];

// or use protocols
[injector map:[Car class] to:@protocol(Vehicle)];
Car *car = [injector getObject:@protocol(Vehicle)];

// or injecti into existing objects
Car *car = [[Car alloc] init];
[injector injectIntoObject:car];
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

    [self mapSingleton:[MyAppModel class] to:@protocol(AppModel) lazy:YES];
    
    // Example Service starts automatically on init
    [self mapSingleton:[MyRemoteService class] to:@protocol(RemoteService) lazy:NO];
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

## Use Gummi Injection in your project

You find the source files you need in Gummi-Injection/Classes

## CocoaPods
Create a Podfile and put it into your root folder of your project

#### Edit your Podfile
```
platform :ios, '5.0'

pod 'Gummi-Injection'
```

#### Setup [CocoaPods] (http://cocoapods.org/), if not done already

```
$ sudo gem install cocoapods
$ pod setup
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

## Other projects using Gummi Injection

* [Gummi Commander] (https://github.com/sschmid/Gummi-Commander) Event Command Mapping System for Objective-C

If you enjoy using Gummi Injection in your projects let me know, and I'll mention your projects here.

