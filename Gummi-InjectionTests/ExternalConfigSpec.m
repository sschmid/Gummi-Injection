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

                [injector setDependencies:@[@"car", @"wheel", @"engine"] forClass:[ExternalClass class]];

                ExternalClass *ec = [injector getObject:[ExternalClass class]];
                [[ec should] beKindOfClass:[ExternalClass class]];
                [[ec.car should] beKindOfClass:[Car class]];
                [[ec.wheel should] beKindOfClass:[Wheel class]];
                NSObject *engine = ec.engine;
                [[engine should] conformsToProtocol:@protocol(Engine)];
            });

            it(@"returns external class with all dependencies and parent dependecies set", ^{
                [injector map:[HybridEngine class] to:@protocol(Engine)];

                [injector setDependencies:@[@"car", @"wheel", @"engine"] forClass:[ExternalClass class]];
                [injector setDependencies:@[@"otherWheel"] forClass:[ExternalSubClass class]];

                ExternalSubClass *ec = [injector getObject:[ExternalSubClass class]];
                [[ec should] beKindOfClass:[ExternalSubClass class]];
                [[ec.car should] beKindOfClass:[Car class]];
                [[ec.wheel should] beKindOfClass:[Wheel class]];
                [[ec.otherWheel should] beKindOfClass:[Wheel class]];
                NSObject *engine = ec.engine;
                [[engine should] conformsToProtocol:@protocol(Engine)];
            });

        });

        SPEC_END