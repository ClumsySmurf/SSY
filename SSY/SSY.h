//
//  SSY.h
//  SSY
//
//  Created by John Hamilton on 1/18/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSY : NSObject
{
    
}



#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

+ (id)sharedInstance;
+ (void)checkSSYData;
+ (void)loadSequences;
+ (NSDictionary *)sequences;
+ (float)getTotalLengthOfPoses:(NSArray*)poses;
+ (NSMutableArray *)getPosesFromNames:(NSArray *)names;
+ (UIImage *)getImageForPose:(NSString *)poseName;
+ (NSArray *)getSavedSequences;
+ (void)updateSavedSequences:(NSArray *)sequences;
+ (void)saveSequence:(NSDictionary *)sequence;
+ (NSArray *)getPackages;
+ (void)unlockPose:(NSString *)pose;
+ (void)unlockSequence:(int)sequence;
+ (void)unlockPackage:(NSDictionary*)packageName;
+ (BOOL)HasSaveSlotsAvailable;
+ (BOOL)restorePurchase:(NSString *)identifier;
+ (UIImage *)getPurchaseImageForPose:(NSString *)poseName;
+ (UIImage *)getIAPImageForPose:(NSString *)poseName;
+ (void)unlockSequenceWithIdentifier:(NSString*)identifier;
@end
