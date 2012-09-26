//
//  Metadata+MetadataCategory.h
//  Testing
//
//  Created by Ashwin Jiwane on 8/20/12.
//  Copyright (c) 2012 Ashwin Jiwane. All rights reserved.
//

#import "Metadata.h"

@interface Metadata (MetadataCategory)

+ (Metadata *) metadataWithInfo:(NSDictionary *)metadataInfo inManagedObjectContext:(NSManagedObjectContext *)context;


@end
