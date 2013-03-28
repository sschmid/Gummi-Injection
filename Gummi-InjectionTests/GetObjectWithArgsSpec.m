//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "BagOfBalls.h"
#import "Ball.h"
#import "OtherBall.h"
#import "BrokenDefaultInitilaizerObject.h"

SPEC_BEGIN(GetObjectWithArgsSpec)

        describe(@"GetObjectWithArgs", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"raises exception when defaultInitializer does not exist", ^{
                [[theBlock(^{
                    [injector getObject:[BrokenDefaultInitilaizerObject class]];
                }) should] raiseWithName:@"GIInjectorException"];
            });

            it(@"returns instance with custom initializer (externally set)", ^{
                [injector setDefaultInitializer:@selector(initAlternative) forClass:[Ball class]];
                Ball *ball = [injector getObject:[Ball class]];

                [[ball should] beKindOfClass:[Ball class]];
                [[ball.color should] equal:@"green"];
            });

            it(@"returns instance with custom initializer (internally set)", ^{
                Ball *ball = [injector getObject:[OtherBall class]];

                [[ball should] beKindOfClass:[OtherBall class]];
                [[ball.color should] equal:@"green"];
            });

            it(@"returns object with custom args (externally set)", ^{
                [injector setDefaultInitializer:@selector(initWithColor:) forClass:[Ball class]];
                NSString *color = @"red";

                Ball *ball = [injector getObject:[Ball class] withArgs:@[color]];

                [[ball.color should] equal:color];
            });

            context(@"when class mapped", ^{

                beforeEach(^{
                    [injector map:[Ball class] to:[Ball class]];
                    [injector map:[OtherBall class] to:[OtherBall class]];
                });

                it(@"returns instance with custom initializer (externally set)", ^{
                    [injector setDefaultInitializer:@selector(initAlternative) forClass:[Ball class]];
                    Ball *ball = [injector getObject:[Ball class]];

                    [[ball should] beKindOfClass:[Ball class]];
                    [[ball.color should] equal:@"green"];
                });

                it(@"returns instance with custom initializer (internally set)", ^{
                    Ball *ball = [injector getObject:[OtherBall class]];

                    [[ball should] beKindOfClass:[OtherBall class]];
                    [[ball.color should] equal:@"green"];
                });

                it(@"returns object with custom args", ^{
                    [injector setDefaultInitializer:@selector(initWithColor:) forClass:[Ball class]];
                    NSString *color = @"red";

                    Ball *ball = [injector getObject:[Ball class] withArgs:@[color]];

                    [[ball.color should] equal:color];
                });

            });

            context(@"when block mapped", ^{

                beforeEach(^{
                    GIFactoryBlock(ballBlock) = ^id(GIInjector *inj, NSArray *args) {
                        return [[Ball alloc] initWithColor:args[0]];
                    };
                    GIFactoryBlock(otherBallBlock) = ^id(GIInjector *inj, NSArray *args) {
                        return [[OtherBall alloc] initWithColor:args[0]];
                    };

                    [injector map:ballBlock to:[Ball class]];
                    [injector map:otherBallBlock to:[OtherBall class]];
                });

                it(@"returns object with custom args", ^{
                    NSString *color = @"red";

                    Ball *ball = [injector getObject:[Ball class] withArgs:@[color]];
                    OtherBall *otherBall = [injector getObject:[OtherBall class] withArgs:@[color]];

                    [[ball.color should] equal:color];
                    [[otherBall.color should] equal:color];
                });

            });

            context(@"when singletons mapped", ^{

                beforeEach(^{
                    [injector mapSingleton:[Ball class] to:[Ball class]];
                    [injector mapSingleton:[OtherBall class] to:[OtherBall class]];
                });

                it(@"returns instance with custom initializer (externally set)", ^{
                    [injector setDefaultInitializer:@selector(initAlternative) forClass:[Ball class]];
                    Ball *ball = [injector getObject:[Ball class]];

                    [[ball should] beKindOfClass:[Ball class]];
                    [[ball.color should] equal:@"green"];
                });

                it(@"returns instance with custom initializer (internally set)", ^{
                    Ball *ball = [injector getObject:[OtherBall class]];

                    [[ball should] beKindOfClass:[OtherBall class]];
                    [[ball.color should] equal:@"green"];
                });

                it(@"returns object with custom args", ^{
                    [injector setDefaultInitializer:@selector(initWithColor:) forClass:[Ball class]];
                    NSString *color = @"red";

                    Ball *ball = [injector getObject:[Ball class] withArgs:@[color]];
                    Ball *ball2 = [injector getObject:[Ball class] withArgs:@[@"blue"]];

                    [[ball.color should] equal:color];
                    [[ball2.color should] equal:color];
                });

            });
        });

        SPEC_END