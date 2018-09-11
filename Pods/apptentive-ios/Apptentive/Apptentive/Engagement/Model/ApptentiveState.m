//
//  ApptentiveState.m
//  Apptentive
//
//  Created by Frank Schmitt on 11/15/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

#import "ApptentiveState.h"

NS_ASSUME_NONNULL_BEGIN


@implementation ApptentiveState
+ (BOOL)supportsSecureCoding {
	return YES;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
	return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

+ (NSArray *)sensitiveKeys {
	return @[];
}

@end


@implementation ApptentiveState (JSON)

+ (NSDictionary *)JSONKeyPathMapping {
	return @{};
}

- (NSDictionary *)dictionaryForJSONKeyPropertyMapping:(NSDictionary *)JSONKeyPropertyMapping {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:JSONKeyPropertyMapping.count];

	for (NSString *JSONKey in JSONKeyPropertyMapping) {
		NSString *propertyName = JSONKeyPropertyMapping[JSONKey];

		NSObject *value = [self valueForKeyPath:propertyName];

		if (value) {
			result[JSONKey] = value;
		}
	}

	return result;
}

- (NSDictionary *)JSONDictionary {
	return [self dictionaryForJSONKeyPropertyMapping:[[self class] JSONKeyPathMapping]];
}

@end

@implementation ApptentiveState (Criteria)

- (nullable NSObject *)valueForFieldWithPath:(NSString *)path {
	ApptentiveAssertFail(@"Abstract method called");
	return nil;
}

- (NSString *)descriptionForFieldWithPath:(NSString *)path {
	ApptentiveAssertFail(@"Abstract method called");
	return [NSString stringWithFormat:@"Unrecognized field %@", path];
}

@end

NS_ASSUME_NONNULL_END
