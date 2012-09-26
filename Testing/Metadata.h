//
//  Metadata.h
//  Testing
//
//  Created by Ashwin Jiwane on 8/22/12.
//  Copyright (c) 2012 Ashwin Jiwane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Metadata : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSDate * time;

@end
