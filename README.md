## Gummi Injection

Gummi Injection is a lightweight dependency injection framework for Objective-C.

## How to use Gummi Injection



1. Map stuff to injector
2. put inject into classes
3. Get object

#### Add rules to injector
```objective-c

GIInjector *injector = [[GIInjector alloc] init];

// Or
GIInjector *injector = [GIInjector sharedInjector];


// [injector map:whenAskedFor to:use]

// Map protocols to classes	
[injector map:@protocol(MyProtocol) to:[MyImplementation class]];
[injector map:[MyClass class] to:[MyClass class]]


```







## Use Gummi Injection in your project

You find the source files you need in Gummi Injection/Classes

Create a Podfile and put it into your root folder of your project

#### Edit your Podfile
```
platform :ios, '5.0'

pod 'Gummi Injection'
```

#### Setup [CocoaPods], if not done already

```
$ sudo gem install cocoapods
$ pod setup
```

#### Add this remote
```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

#### Install Gummi
```
$ cd path/to/project
$ pod install
```

[cocoapods]: http://cocoapods.org/
