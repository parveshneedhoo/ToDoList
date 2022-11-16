//
//  Database.h
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 09/11/2022.
//
#import <sqlite3.h>

@interface Database : NSObject
// properties
//@property NSString *name;
//@property NSString *topic;

//initializer
//-(instancetype)initWithName:(NSString *)name andTopic:(NSString *)topic;

//methods
//+ (NSArray *)fetchItems;

+(void)addToDatabase:(NSString *) task andDetail:(NSString *) Detail andImagePath:(NSString *) path;
+(NSMutableDictionary *)readDatabase;
+(void)emptyDatabase;
+(void)deleteRecordWithtask:(NSString *) task andDetail:(NSString *) Detail andImagePath:(NSString *) path;
@end
