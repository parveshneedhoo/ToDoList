//
//  Item.h
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 08/11/2022.
//

#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

@interface Item : NSObject 
// properties
@property NSString *name;
@property NSString *topic;
@property NSString *path;
@property UIImage *image;

//initializer
-(instancetype)initWithName:(NSString *)name andTopic:(NSString *)topic andImage:(UIImage *) image;
-(instancetype)initWithName:(NSString *)name andTopic:(NSString *)topic andImagePath:(NSString *) path;

//methods
+ (NSArray *)fetchItems;

@end
