//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "Car.h"
#import "ExternalClass.h"
#import "Wheel.h"
#import "Engine.h"
#import "HybridEngine.h"
#import "ExternalSubClass.h"
#import "Teaser.h"
#import "Frame.h"
#import "Target.h"
#import "Link.h"

SPEC_BEGIN(ExternalConfigSpec)

        describe(@"ExternConfig", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"returns external class with no dependencies set", ^{
                ExternalClass *ec = [injector getObject:[ExternalClass class]];
                [[ec should] beKindOfClass:[ExternalClass class]];
                [ec.car shouldBeNil];
                [ec.wheel shouldBeNil];
                NSObject *engine = ec.engine;
                [engine shouldBeNil];
            });

            it(@"returns external class with all dependencies set", ^{
                [injector map:[HybridEngine class] to:@protocol(Engine)];

                [injector addDependencies:@[@"car", @"wheel", @"engine"] forClass:[ExternalClass class]];

                ExternalClass *ec = [injector getObject:[ExternalClass class]];
                [[ec should] beKindOfClass:[ExternalClass class]];
                [[ec.car should] beKindOfClass:[Car class]];
                [[ec.wheel should] beKindOfClass:[Wheel class]];
                NSObject *engine = ec.engine;
                [[engine should] conformsToProtocol:@protocol(Engine)];
            });

            it(@"returns external class with all dependencies and parent dependecies set", ^{
                [injector map:[HybridEngine class] to:@protocol(Engine)];

                [injector addDependencies:@[@"car", @"wheel", @"engine"] forClass:[ExternalClass class]];
                [injector addDependencies:@[@"otherWheel"] forClass:[ExternalSubClass class]];

                ExternalSubClass *ec = [injector getObject:[ExternalSubClass class]];

                [[ec should] beKindOfClass:[ExternalSubClass class]];
                [[ec.car should] beKindOfClass:[Car class]];
                [[ec.wheel should] beKindOfClass:[Wheel class]];
                [[ec.otherWheel should] beKindOfClass:[Wheel class]];
                NSObject *engine = ec.engine;
                [[engine should] conformsToProtocol:@protocol(Engine)];
            });

            it(@"returns external class with all dependencies and parent dependecies set", ^{
                [injector addDependencies:@[@"target"] forClass:[Button class]];
                [injector addDependencies:@[@"frame"] forClass:[Component class]];
                [injector addDependencies:@[@"link"] forClass:[Teaser class]];

                Teaser *teaser = [injector getObject:[Teaser class]];

                [[teaser should] beKindOfClass:[Teaser class]];
                [[teaser.frame should] beKindOfClass:[Frame class]];
                [[teaser.target should] beKindOfClass:[Target class]];
                [[teaser.link should] beKindOfClass:[Link class]];
            });

            it(@"returns external class with all dependencies and parent dependecies set with unsorted order", ^{
                [injector addDependencies:@[@"link"] forClass:[Teaser class]];
                [injector addDependencies:@[@"target"] forClass:[Button class]];
                [injector addDependencies:@[@"frame"] forClass:[Component class]];

                Teaser *teaser = [injector getObject:[Teaser class]];

                [[teaser should] beKindOfClass:[Teaser class]];
                [[teaser.frame should] beKindOfClass:[Frame class]];
                [[teaser.target should] beKindOfClass:[Target class]];
                [[teaser.link should] beKindOfClass:[Link class]];
            });

            it(@"returns external class with all dependencies", ^{
                [injector addDependencies:@[@"frame", @"link", @"target"] forClass:[Teaser class]];

                Teaser *teaser = [injector getObject:[Teaser class]];

                [[teaser should] beKindOfClass:[Teaser class]];
                [[teaser.frame should] beKindOfClass:[Frame class]];
                [[teaser.target should] beKindOfClass:[Target class]];
                [[teaser.link should] beKindOfClass:[Link class]];
            });

        });

        SPEC_END