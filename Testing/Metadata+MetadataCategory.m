//
//  Metadata+MetadataCategory.m
//  Testing
//
//  Created by Ashwin Jiwane on 8/20/12.
//  Copyright (c) 2012 Ashwin Jiwane. All rights reserved.
//

#import "Metadata+MetadataCategory.h"

@implementation Metadata (MetadataCategory)

+ (Metadata *) metadataWithInfo:(NSDictionary *)metadataInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Metadata *metadata = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Metadata"];
    request.predicate = [NSPredicate predicateWithFormat:@"filename = %@ AND time = %@ AND latitude = %@ AND longitude = %@", [metadataInfo objectForKey:@"METADATA_INFO_FILENAME"], [metadataInfo objectForKey:@"METADATA_INFO_TIME"], [metadataInfo objectForKey:@"METADATA_INFO_LATITUDE"], [metadataInfo objectForKey:@"METADATA_INFO_LONGITUDE"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
     NSLog(@"MetadataInfo to save: %@", metadataInfo);
    
    if (!matches) {
        return nil;
        //error
    } else if ([matches count] == 0) {
        metadata = [NSEntityDescription insertNewObjectForEntityForName:@"Metadata" inManagedObjectContext:context];
        metadata.filename = [metadataInfo objectForKey:@"METADATA_INFO_FILENAME"];
        metadata.time = [metadataInfo objectForKey:@"METADATA_INFO_TIME"];
        metadata.latitude = [metadataInfo objectForKey:@"METADATA_INFO_LATITUDE"];
        metadata.longitude = [metadataInfo objectForKey:@"METADATA_INFO_LONGITUDE"];        
        //update user info here
    } else {
        metadata = [matches lastObject];
    }
    return metadata;
}
@end
