//
//  Image.h
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 14/11/2022.
//
#import <AVFoundation/AVFoundation.h>

@interface Image : NSObject
// properties
@property NSString *imageUrl;

//initializer


//methods
+ (NSString *)uploadimage:(UIImage *)image addPath:(NSString *)path;
+ (void) takeImage;
+ (NSString *) getMimeType:(NSData *) data;

@end
