//
//  AppDelegate.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 21/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIImageView *helpView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

