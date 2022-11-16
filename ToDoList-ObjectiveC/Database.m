//
//  Database.m
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 09/11/2022.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import <sqlite3.h>
#import "Item.h"

@implementation Database

+ (void)addToDatabase:(NSString *)task andDetail:(NSString *)Detail andImagePath:(NSString *) path{
    NSFileManager *fs;
    sqlite3 *db;
    char *errorMsg;
    NSString *filePath;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    filePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent: @"todo.sqlite"]];
    fs = [NSFileManager defaultManager];
    
    if([fs fileExistsAtPath:filePath] == true){
        NSLog(@"FILE FOUND.");
        //code to create table.
        if(sqlite3_open([filePath UTF8String], &db) == SQLITE_OK){
            //create table query
            NSString *createTable = @"CREATE TABLE IF NOT EXISTS tasks(taskid INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, detail TEXT, path TEXT)";
            if(sqlite3_exec(db,[createTable UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
                NSLog(@"Table created!");
            }
            else{
                NSLog(@"Error while creating table : %s", errorMsg);
            }
        }
        else{
            NSLog(@"Failed to open database file");
        }
    }
    else{
        NSLog(@"FILE NOT FOUND.");
        //create a new database if file not found
        [fs createFileAtPath:filePath contents:NULL attributes:NULL];
    }
    
    
    if(sqlite3_open([filePath UTF8String], &db) == SQLITE_OK){
        //create table query
        NSString *insertTable = [NSString stringWithFormat:@"INSERT INTO tasks(task,detail,path) VALUES('%@','%@','%@')", task, Detail,path];
        if(sqlite3_exec(db,[insertTable UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
            NSLog(@"Value inserted!");
        }
        else{
            NSLog(@"Error while inserting record : %s", errorMsg);
        }
    }
    else{
        NSLog(@"Failed to open database file");
    }
}

+ (NSMutableDictionary *)readDatabase{
    NSFileManager *fs;
    NSString *filePath;
    sqlite3 *db;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *docsDir = dirPaths[0];
    
    filePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent: @"todo.sqlite"]];
    
    fs = [NSFileManager defaultManager];
    
    if(sqlite3_open([filePath UTF8String], &db) == SQLITE_OK){
        
        //create table query
        char *selectQuery = "SELECT * FROM tasks";
        sqlite3_stmt *allRecords;
        NSMutableDictionary *platform = [[NSMutableDictionary alloc] init];
        
        if(sqlite3_prepare_v2(db, selectQuery, -1, &allRecords, NULL)==SQLITE_OK){
            
            while(sqlite3_step(allRecords) == SQLITE_ROW){
                NSString *primarykey = [NSString stringWithFormat:@"%s",sqlite3_column_text(allRecords, 0)];
                NSString *task = [NSString stringWithFormat:@"%s",sqlite3_column_text(allRecords, 1)];
                NSString *detail = [NSString stringWithFormat:@"%s",sqlite3_column_text(allRecords, 2)];
                NSString *imagePath = [NSString stringWithFormat:@"%s",sqlite3_column_text(allRecords, 3)];
                Item *newItem = [[Item alloc]initWithName:task andTopic:detail andImagePath:imagePath];
                [platform  setObject:newItem forKey:primarykey];
            }
            return platform;
        }
        else{
            NSLog(@"Error while fetching data");
        }
    }
    else{
        NSLog(@"Failed to open database file");
    }
    
    return  NULL;
}

+ (void)emptyDatabase{
    NSFileManager *fs;
    sqlite3 *db;
    NSString *filePath;
    char *errorMsg;
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *docsDir = dirPaths[0];
    
    filePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent: @"todo.sqlite"]];
    
    fs = [NSFileManager defaultManager];
    
    if([fs fileExistsAtPath:filePath] == true){
        NSLog(@"FILE FOUND.");
        
        //code to delete items from table.
        if(sqlite3_open([filePath UTF8String], &db) == SQLITE_OK){
            //create table query
            NSString *clearTable = @"DELETE FROM tasks";
            if(sqlite3_exec(db,[clearTable UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
                NSLog(@"Table created!");
            }
            else{
                NSLog(@"Error while clearing table : %s", errorMsg);
            }
        }
        else{
            NSLog(@"Failed to open database file");
        }
    }
    else{
        NSLog(@"FILE NOT FOUND.");
        //create a new database if file not found
        [fs createFileAtPath:filePath contents:NULL attributes:NULL];
    }
}

+(void) deleteRecordWithtask:(NSString *)task andDetail:(NSString *)Detail andImagePath:(NSString *) path{
    NSFileManager *fs;
    sqlite3 *db;
    NSString *filePath;
    char *errorMsg;
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *docsDir = dirPaths[0];
    
    filePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent: @"todo.sqlite"]];
    
    fs = [NSFileManager defaultManager];
    
    if([fs fileExistsAtPath:filePath] == true){
        NSLog(@"FILE FOUND.");
        
        //code to delete items from table.
        if(sqlite3_open([filePath UTF8String], &db) == SQLITE_OK){
            //create table query
            NSString *deleteRecordFromTable =[NSString stringWithFormat:@"DELETE FROM tasks WHERE task='%@' AND detail='%@' AND path='%@'", task, Detail,path];
            if(sqlite3_exec(db,[deleteRecordFromTable UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
                NSLog(@"Record Deleted!");
            }
            else{
                NSLog(@"Error while deleting record : %s", errorMsg);
            }
        }
        else{
            NSLog(@"Failed to open database file");
        }
    }
    else{
        NSLog(@"FILE NOT FOUND.");
        //create a new database if file not found
        [fs createFileAtPath:filePath contents:NULL attributes:NULL];
    }
}

@end
