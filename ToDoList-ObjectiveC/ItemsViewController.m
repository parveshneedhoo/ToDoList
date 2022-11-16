//
//  ViewController.m
//  ToDoList-ObjectiveC
//
//  Created by Kunal on 08/11/2022.
//

#import "ItemsViewController.h"
#import "Item.h"
#import "Database.h"
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>
#import <Cloudinary/Cloudinary.h>
#import <AFNetworking/AFNetworking.h>
#import <AFURLSessionManager.h>
#import "Image.h"


//conform to UITABLEVIEW DATASOURCE
@interface ItemsViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *items;
@property NSString *filePath;
@property NSString *globalName;
@property NSString *globalTopic;
@property UIImage *globalImage;
@property (strong, nonatomic) NSString *path;
@end
@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=UIColor.redColor;
    //self.tableView.backgroundColor=UIColor.blueColor;
    [self configureNavBar];
    //table view's data
    self.items = [[NSMutableArray alloc]initWithArray:[Item fetchItems]];
    self.tableView.dataSource=self;
    [self readDatabase];
    
    
    
}

-(void)readDatabase{
    NSMutableDictionary *record = [Database readDatabase];
    
    for(Item *key in record)
    {
        [self.items addObject:record[key]];
        //2. create an indexpath at the end of items array
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
        //3. insert indexpath into table view
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)configureNavBar{
    // 1. Create an image for the bar button item
    UIImage*image = [UIImage systemImageNamed:@"plus"];
    //2. Create bar button item
    UIBarButtonItem *plusButton =[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector((addItem))];
    plusButton.tintColor=UIColor.greenColor;
    //3. Set the plus button as the right bar button item
    UIImage*image1 = [UIImage systemImageNamed:@"xmark.bin.fill"];
    //2. Create bar button item
    UIBarButtonItem *minusButton =[[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector((delete))];
    minusButton.tintColor=UIColor.greenColor;
    NSArray *arrNavigationButtons = [NSArray arrayWithObjects:plusButton,minusButton, nil];
    //3. Set the plus button as the right bar button item
    self.navigationItem.leftBarButtonItems = arrNavigationButtons;
    //4. Give navigation bar a title
    self.navigationItem.title = @"To Do List";
}

-(void) delete{
    //1. initialize an alert controller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear List" message:@"Delete all tasks in the list" preferredStyle:UIAlertControllerStyleAlert];
    //4. add action items "Cancel" and "Save"
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        //handle code here
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //handle code here to empty database
        [Database emptyDatabase];
        [self.items removeAllObjects];
        [self.tableView reloadData];
    }];
    //5. Add actions to the alert controller
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) addItem{
    //1. initialize an alert controller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Items" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //2. Add two text fields to the alert controller
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //code
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //code
    }];
    //3. add placeholder text to the text fields
    alertController.textFields[0].placeholder = @"Enter the name of the item";
    alertController.textFields[1].placeholder=@"Enter the topic";
    //4. add action items "Cancel" and "Save"
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        //handle code here
    }];
    UIAlertAction *uploadPicture = [UIAlertAction actionWithTitle:@"Choose Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //handle code here
        self.globalName=alertController.textFields[0].text;
        self.globalTopic=alertController.textFields[1].text;
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerView animated:YES completion:nil];
        
    }];
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"Take Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //handle code here
        self.globalName=alertController.textFields[0].text;
        self.globalTopic=alertController.textFields[1].text;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    //5. Add actions to the alert controller
    [alertController addAction:cancelAction];
    //[alertController addAction:saveAction];
    [alertController addAction:uploadPicture];
    [alertController addAction:takePicture];
    [self presentViewController:alertController animated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    Item *item = self.items[indexPath.row];
    //UIImage *display = [UIImage imageWithData:[NSData dataWithContentsOfFile:item.path]];
    UIImage *image = [UIImage imageWithContentsOfFile:item.path];
    NSLog(@"%@", item.path);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.topic;
    cell.imageView.image=image;
    CGRect buttonRect = CGRectMake(350, 9, 65, 25);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = buttonRect;
    // set the button title here if it will always be the same
    [button setTitle:@"DELETE" forState:UIControlStateNormal];
    button.tintColor=UIColor.redColor;
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    return cell;
}

-(void)deleteItem:(id) sender{
    UIButton *btn = (UIButton *)sender;
    Item *item = self.items[btn.tag];
    NSLog(@"%@", item.name);
    NSLog(@"%@", item.topic);
    NSLog(@"%@", item.path);
    
    NSLog(@"ETEREEEEDDDD");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete this task?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //4. add action items "Cancel" and "Save"
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        //handle code here
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //handle code here
        [Database deleteRecordWithtask:item.name andDetail:item.topic andImagePath:item.path];
        [self.items removeObjectAtIndex:btn.tag];
        [self.tableView reloadData];
        //[self readDatabase];
    }];
    //5. Add actions to the alert controller
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:true completion:nil];
    

    
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    NSLog(@"printing uiimage %@",info[UIImagePickerControllerEditedImage]);
    image = info[UIImagePickerControllerEditedImage];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *profilePicturePath = [docsDir stringByAppendingPathComponent:dateString];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:profilePicturePath atomically:NO];
    
    NSString *imageUrl = [Image uploadimage:image addPath:profilePicturePath];
    
    
    
    [Database addToDatabase:self.globalName andDetail:self.globalTopic andImagePath:imageUrl];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    Item *newItem = [[Item alloc]initWithName:self.globalName andTopic:self.globalTopic andImagePath:profilePicturePath];
    [self.items addObject:newItem];
    //2. create an indexpath at the end of items array
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
    //3. insert indexpath into table view
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)uploadimage:(UIImage *)image addPath:(NSString *)path
{
    
    NSData *imageData =UIImagePNGRepresentation(image);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://api.cloudinary.com/v1_1/dssmidp0h/image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:imageData name:@"file" fileName:path mimeType:[self getMimeType:imageData]];
        [formData appendPartWithFormData:[@"873728271175549" dataUsingEncoding:NSUTF8StringEncoding] name:@"api_key"];
        [formData appendPartWithFormData:[@"dm1jfy0d" dataUsingEncoding:NSUTF8StringEncoding] name:@"upload_preset"];

    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
       progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"Upload Progress %@", uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Upload Error: %@", error);
        } else {
            NSLog(@"Upload Sucesss %@", response);
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSLog(@" VALUE %@", [responseDict valueForKey:@"url"]);
        }
    }];
    [uploadTask resume];
}

- (NSString *) getMimeType:(NSData *) data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

@end
