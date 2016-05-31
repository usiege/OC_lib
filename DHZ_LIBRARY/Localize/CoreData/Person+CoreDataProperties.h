//
//  Person+CoreDataProperties.h
//  DHZ_LIBRARY
//
//  Created by 先锋电子技术 on 16/5/30.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
