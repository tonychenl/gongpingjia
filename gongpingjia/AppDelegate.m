//
//  AppDelegate.m
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "AppDelegate.h"
#import "BrandModel.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

static NSMutableArray *brand_first_letter = nil;
static NSMutableArray *brand_content = nil;
static NSMutableDictionary *car_model = nil;

-(NSString*)assetsdir
{
   return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"assets"];
}

-(NSArray*)brand_content
{
    [self loadbrandjson];
    return  brand_content;
}

-(NSArray*)brand_first_letter
{
    [self loadbrandjson];
    return brand_first_letter;
}

-(NSDictionary*)car_model
{
    [self loadbrandjson];
    return car_model;
}


-(void)loadbrandjson
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *brand_json_path = [[self assetsdir] stringByAppendingPathComponent:@"brand_json.dat"];
        NSString *model_json_path = [[self assetsdir] stringByAppendingPathComponent:@"model_json.dat"];
    
        NSData *json_data = [[NSData alloc] initWithContentsOfFile:brand_json_path];
        NSError *error;
        NSArray  *brand_json = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:&error];
    
        json_data = [[NSData alloc] initWithContentsOfFile:model_json_path];
        car_model = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:&error];
        
        brand_first_letter = [[NSMutableArray alloc] init];
        brand_content      = [[NSMutableArray alloc] init];
        
        for (NSDictionary* dic in brand_json) {
            NSUInteger index = [brand_first_letter indexOfObject:[dic valueForKey:@"first_letter"]];
            if (index == NSNotFound) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [brand_content addObject:array];
                [brand_first_letter addObject:[dic valueForKey:@"first_letter"]];
            }
            NSUInteger i2 = [brand_first_letter indexOfObject:[dic valueForKey:@"first_letter"]];
            __weak NSMutableArray *array = [brand_content objectAtIndex:i2];
            BrandModel *model = [[BrandModel alloc] init];
            model.first_letter =[dic valueForKey:@"first_letter"];
            model.name = [dic valueForKey:@"name"];
            model.logo_img = [[[self assetsdir] stringByAppendingPathComponent:@"brand_img"] stringByAppendingPathComponent:[dic valueForKey:@"logo_img"]];
            //[dic valueForKey:@"logo_img"];
            model.slug = [dic valueForKey:@"slug"];
            [array addObject:model];
        }
        NSLog(@"%@",brand_first_letter);
        NSLog(@"%@",brand_content);
        NSLog(@"%d,%d",[brand_first_letter count],[brand_content count]);
        NSLog(@"%@",car_model);
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadbrandjson];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
