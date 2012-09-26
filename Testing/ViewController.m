//
//  ViewController.m
//  Testing
//
//  Created by Ashwin Jiwane on 8/19/12.
//  Copyright (c) 2012 Ashwin Jiwane. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize assetsLibrary = _assetsLibrary;
@synthesize metadataDatabase = _metadataDatabase;

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.metadataDatabase.fileURL path]]) {
        NSLog(@"Creating database file");
        [self.metadataDatabase saveToURL:self.metadataDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            //[self setupFetchedResultsController];
            //[self fetchFlickerDataIntoDocument:self.metadataDatabase];
        }];
    } else if (self.metadataDatabase.documentState == UIDocumentStateClosed) {
        NSLog(@"Opeing the database file");
        // NSLog(@"at %@", self.metadataDatabase.fileURL);
        [self.metadataDatabase openWithCompletionHandler:^(BOOL success) {
            //[self setupFetchedResultsController];
            // pass
        }];
    } else if (self.metadataDatabase.documentState == UIDocumentStateNormal) {
        NSLog(@"database file is open");
        //[self setupFetchedResultsController];
        // pass
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"In View Did Appear");
    if (!self.metadataDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"PhotoMetaDataDB"];
        
        NSLog(@"Println url: %@", url);
        self.metadataDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    [self useDocument];

    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    __block BOOL finishedAllPhotos = NO;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            NSLog(@"Inside queue");
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
                if (!finishedAllPhotos) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]){
                    
                    NSLog(@"This is a photo asset");                        
                        NSDictionary *metadata = result.defaultRepresentation.metadata;
                    NSString *filename = result.defaultRepresentation.filename;
                    NSLog(@" metadata: %@", metadata);
                    NSDate *time = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
                    NSString *latitude = [[metadata objectForKey:@"{GPS}"] objectForKey:@"Latitude"];
                    NSString *longitude = [[metadata objectForKey:@"{GPS}"] objectForKey:@"Longitude"];
                    
                    NSDictionary *metadataInfo = [NSDictionary dictionaryWithObjectsAndKeys:filename, @"METADATA_INFO_FILENAME",
                                                  time, @"METADATA_INFO_TIME", latitude, @"METADATA_INFO_LATITUDE", longitude, @"METADATA_INFO_LONGITUDE", nil];
                    Metadata * obj = [Metadata metadataWithInfo:metadataInfo inManagedObjectContext:self.metadataDatabase.managedObjectContext];
                    }
                } else {
                    *stop = YES;
                }
            }];
        NSLog(@"Done adding metadata to DB");
        finishedAllPhotos = YES;
        *stop = YES;
        } failureBlock:^(NSError *error) {
            NSLog(@"Failed to enumerate the asset groups.");
        }];
   NSLog(@"End of the function call");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
