//
//  SSY.m
//  SSY
//
//  Created by John Hamilton on 1/18/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "SSY.h"
//#import "MKStoreManager.h"
@implementation SSY



+ (id)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

+ (void)checkSSYData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSLog(@"SSY: SSY data doesn't exist copying file");
        
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"SSYData" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:dataPath];
        
        [dictionary writeToFile:filePath atomically:YES];
        
        NSLog(@"SSY: Saved new data file");
    }

}
+ (NSDictionary *)sequences
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}
+ (float)getTotalLengthOfPoses:(NSArray *)poses
{
    float seconds = 0;
    
    NSDictionary *seq  = [SSY sequences];
    
    NSArray *p = [seq objectForKey:@"Poses"];
    
    for (NSDictionary *pose in p)
    {
        NSString *poseName = [pose objectForKey:@"Name"];
        
        for (NSString *pName in poses)
        {
            if ([poseName isEqualToString:pName])
            {
                seconds += [[pose objectForKey:@"Length"] floatValue];
                break;
            }
        }
    }
    return seconds;
}
+ (NSArray *)getSavedSequences
{
    NSArray *savedSequences = [NSArray array];
    
    NSDictionary *seq = [SSY sequences];
    
    savedSequences = [seq objectForKey:@"SavedSequences"];
    
    NSLog(@"Loaded %d sequences", [savedSequences count]);
    return savedSequences;
}
+ (NSArray *)getPackages;
{
    NSArray *savedSequences = [NSArray array];
    
    NSDictionary *seq = [SSY sequences];
    
    savedSequences = [seq objectForKey:@"CustomPackages"];
    
    NSLog(@"Loaded %d custom packages", [savedSequences count]);
    return savedSequences;
}
+ (void)updateSavedSequences:(NSArray *)sequences
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *seq = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    if (seq == nil)
    {
        seq = [[NSMutableDictionary alloc] init];
    }
    
    [seq setObject:sequences forKey:@"SavedSequences"];
    
    [seq writeToFile:filePath atomically:YES];
}
+ (BOOL)HasSaveSlotsAvailable
{
    NSNumber *slots = [[NSUserDefaults standardUserDefaults] objectForKey:@"Slots"];
    int available = [slots intValue];
    
    if (available == 0)
        available = 3;
    
    NSMutableDictionary *seq = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    NSMutableArray *sequences = [NSMutableArray arrayWithArray:[seq objectForKey:@"SavedSequences"]];
    
    if (sequences == nil)
        return YES; // means we don't have any saved at all
    
    if ([sequences count] < available)
        return YES;
    
    return NO;
}
+ (void)saveSequence:(NSDictionary *)sequence
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *seq = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    NSMutableArray *sequences = [NSMutableArray arrayWithArray:[seq objectForKey:@"SavedSequences"]];
    
    if (sequences == nil)
    {
        sequences = [NSMutableArray array];
    }
    if (sequence == nil)
    {
        NSLog(@"Seq is nil");
        return;
    }
    else
        [sequences addObject:sequence];
    
    [seq setObject:sequences forKey:@"SavedSequences"];
    [seq writeToFile:filePath atomically:YES];
}
+ (void)unlockPose:(NSString *)pose
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *seq = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];

    NSArray *poses = [seq objectForKey:@"Poses"];
    
    for (NSMutableDictionary *p in poses)
    {
        if ([[p objectForKey:@"Name"] isEqualToString:pose])
        {
            NSLog(@"Unlocking Pose: %@", pose);
            [p setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
            break;
        }
    }
    
    [seq setObject:poses forKey:@"Poses"];
    [seq writeToFile:filePath atomically:YES];
}
+ (void)unlockSequence:(int)sequence
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    NSMutableArray *sequences = [data objectForKey:@"Sequences"];
    NSArray *m_poses = [data objectForKey:@"Poses"];
    
    NSMutableDictionary *seq = [sequences objectAtIndex:sequence];
    
    NSArray *poses = [seq objectForKey:@"Poses"];
        for (NSString *pose in poses)
        {
            for (NSMutableDictionary * p in m_poses)
            {
                if ([[p objectForKey:@"Name"] isEqualToString:pose])
                {
                    [p setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
                }
            }
        }
        // update pose data
        [data setObject:m_poses forKey:@"Poses"];
        // unlock the sequence
        [seq setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
    
    
    [data setObject:sequences forKey:@"Sequences"];
    [data writeToFile:filePath atomically:YES];
}
+ (void)unlockSequenceWithIdentifier:(NSString*)identifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    NSMutableArray *sequences = [data objectForKey:@"Sequences"];
    NSMutableDictionary *seq = [NSMutableDictionary new];
    NSArray *m_poses = [data objectForKey:@"Poses"];
    
    for (NSMutableDictionary *s in sequences) {
        if ([s[@"App"] isEqualToString:identifier]) {
            seq = s;
            break;
        }
    }
    
    NSArray *poses = [seq objectForKey:@"Poses"];
    for (NSString *pose in poses)
    {
        for (NSMutableDictionary * p in m_poses)
        {
            if ([[p objectForKey:@"Name"] isEqualToString:pose])
            {
                [p setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
            }
        }
    }
    // update pose data
    [data setObject:m_poses forKey:@"Poses"];
    // unlock the sequence
    [seq setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
    
    
    [data setObject:sequences forKey:@"Sequences"];
    [data writeToFile:filePath atomically:YES];
}
+ (void)unlockPackage:(NSDictionary *)packageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    NSMutableArray *sequences = [data objectForKey:@"Sequences"];
    NSArray *m_poses = [data objectForKey:@"Poses"];
    NSArray *packages = [data objectForKey:@"CustomPackages"];
    
    NSMutableDictionary *package;
    
    for (NSMutableDictionary *p in packages) {
        if ([p[@"App"] isEqualToString:packageName[@"App"]]) {
            package = p;
            p[@"Unlocked"] = @YES;
            break;
        }
    }
    
    
    if ([[packageName objectForKey:@"Everything"] boolValue] == YES)
    {
        //Unlock everything
        for (NSMutableDictionary *seq in sequences)
        {
            [seq setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
        }
        for(NSMutableDictionary *pose in m_poses)
        {
            [pose setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
        }
        for (NSMutableDictionary *p in packages) {
            p[@"Unlocked"] = @YES;
        }

    }
    else
    {
        NSArray *packageSequences = [packageName objectForKey:@"Unlocks"];
        
        for (NSString *seq in packageSequences)
        {
            //Find the right sequence
            NSMutableDictionary *sequence = [sequences objectAtIndex:[seq intValue]];
            
         
           //We found the right sequence. Now let's unlock all the poses for this sequence
            NSArray *sPoses = [sequence objectForKey:@"Poses"];
                for (NSString *sPose in sPoses)
                    {
                        for (NSMutableDictionary *p in m_poses)
                        {
                            if ([[p objectForKey:@"Name"] isEqualToString:sPose])
                            {
                                [p setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
                            }
                        }
                        
                        //Unlock the sequence
                        [sequence setObject:[NSNumber numberWithBool:YES] forKey:@"Unlocked"];
                    }
        }
    }
    
    
    // Save our objects
    package[@"Unlocked"] = @YES;
    data[@"CustomPackages"] = packages; 
    [data setObject:sequences forKey:@"Sequences"];
    [data setObject:m_poses forKey:@"Poses"];
    [data writeToFile:filePath atomically:YES];
    
    // Update our slots
    NSNumber *slots = [[NSUserDefaults standardUserDefaults] objectForKey:@"Slots"];
    int s = [slots intValue] + [[packageName objectForKey:@"Slots"] intValue];
    slots = [NSNumber numberWithInt:s];
    [[NSUserDefaults standardUserDefaults] setObject:slots forKey:@"Slots"];
}
+ (BOOL)restorePurchase:(NSString *)identifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SSYData.plist"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[SSY sequences]];
    
    NSMutableArray *sequences = [data objectForKey:@"Sequences"];
    NSArray *m_poses = [data objectForKey:@"Poses"];
    NSMutableArray *packages = [data objectForKey:@"CustomPackages"];
    
    for (int i = 0; i<packages.count; i++)
    {
        NSDictionary *package = packages[i];
        
        if ([package[@"App"] isEqualToString:identifier])
        {
            [SSY unlockPackage:package];
            break;
        }
    }
    
    for (int i = 0; i<[sequences count]; i++)
    {
        NSMutableDictionary *seq = sequences[i];
        
        if ([[seq objectForKey:@"App"] isEqualToString:identifier])
        {
            NSLog(@"Unlocking a sequence");
            [SSY unlockSequence:i];
            break;
        }
    }
    for (NSMutableDictionary *p in m_poses)
    {
        if ([p[@"App"] isEqualToString:identifier])
        {
            NSLog(@"Unlocking Pose");
            [SSY unlockPose:p[@"Name"]];
            break;
        }
    }
    
    return YES;
}
+ (UIImage *)getImageForPose:(NSString *)poseName
{
    
    UIImage *image = nil;
    NSDictionary *seq  = [SSY sequences];
    
    NSArray *p = [seq objectForKey:@"Poses"];
    
    for (NSDictionary *pose in p)
    {
        if ([poseName isEqualToString:[pose objectForKey:@"Name"]])
        {
            image = [UIImage imageNamed:[pose objectForKey:@"Image"]];
            if (image == nil)
            {
                NSLog(@"Unable to locate image: %@", [pose objectForKey:@"Image"]);
            }
            break;
        }
    }
    
    return image;

}
+ (UIImage *)getPurchaseImageForPose:(NSString *)poseName
{
    
    UIImage *image = nil;
    NSDictionary *seq  = [SSY sequences];
    
    NSArray *p = [seq objectForKey:@"Poses"];
    
    for (NSDictionary *pose in p)
    {
        if ([poseName isEqualToString:[pose objectForKey:@"Name"]])
        {
            NSString *imageName = [NSString stringWithFormat:@"%@ T", [pose objectForKey:@"Image"]];
            
            image = [UIImage imageNamed:imageName];
            if (image == nil)
            {
                NSLog(@"Unable to locate image: %@", [pose objectForKey:@"Image"]);
            }
            break;
        }
    }
    
    return image;
    
}

+ (UIImage *)getIAPImageForPose:(NSString *)poseName
{
    
    UIImage *image = nil;
    NSDictionary *seq  = [SSY sequences];
    
    NSArray *p = [seq objectForKey:@"Poses"];
    
    for (NSDictionary *pose in p)
    {
        if ([poseName isEqualToString:[pose objectForKey:@"Name"]])
        {
            NSString *imageName = [NSString stringWithFormat:@"%@ T", pose[@"Image"]];
            image = [UIImage imageNamed:imageName];
            if (image == nil)
            {
                NSLog(@"Unable to locate image: %@", [pose objectForKey:@"Image"]);
            }
            break;
        }
    }
    
    return image;
    
}
+ (NSMutableArray *)getPosesFromNames:(NSArray *)names
{
    NSMutableArray *myPoses = [NSMutableArray array];
    
    NSDictionary *seq  = [SSY sequences];
    
    NSArray *p = [seq objectForKey:@"Poses"];
    
    
    for (int i = 0; i<[names count]; i++)
    {
        NSString *pName = [names objectAtIndex:i];
        
        for (NSDictionary *pose in p)
        {
            if ([pName isEqualToString:[pose objectForKey:@"Name"]])
            {
                [myPoses addObject:pose];
                break;
            }
        }
    }
    
    return myPoses;
}
@end
