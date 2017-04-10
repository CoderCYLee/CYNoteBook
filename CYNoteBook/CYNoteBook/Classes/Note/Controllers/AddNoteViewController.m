//
//  AddNoteViewController.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "AddNoteViewController.h"
#import "NoteUtils.h"
#import "AllUtils.h"
#import "LocationManager.h"
#import "NoteDBModel.h"
#import "CYEditorTextView.h"

@interface AddNoteViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet CYEditorTextView *noteTextTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) LocationManager *manager;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.timeLabel.text = [AllUtils getDateFromString:[AllUtils getDate]];
    
    LocationManager *manager = [LocationManager shareInstance];
    self.manager = manager;
    [self.manager startUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    
    self.manager.addressBlock = ^(NSString *address){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.locationLabel.text = address;
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)save:(id)sender {
    NSString *noteTitle = [self.noteTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *noteText = [self.noteTextTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *time = [AllUtils getDate];
    NSString *location = self.locationLabel.text;
    
    
    
    if (![noteTitle isEqualToString:@""] && ![noteText isEqualToString:@""]){
        
        NoteDBModel *model = [[NoteDBModel alloc] init];
        model.noteTitle = noteTitle;
        model.noteCreatedTime = time;
        model.noteText = noteText;
        model.noteLocation = location;
        
        if (self.image) {
            NSArray *array = @[self.image];
            
            NSMutableData *dd = [[NSMutableData alloc] init];
            
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dd];
            [archiver encodeObject:array forKey:@"kArchivingDataKey"]; // archivingDate的encodeWithCoder
            [archiver finishEncoding];
            
            model.images = dd;
        }
        
        
        
        [NoteUtils addNoteWithNoteModel:model todo:^(BOOL isSuccessful, NSError *error) {
        
//        [NoteUtils addNoteWithNoteTitle:noteTitle noteText:noteText time:time noteLocation:location todo:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                [AllUtils showPromptDialog:@"提示" andMessage:@"增加一条笔记成功" OKButton:@"确定" OKButtonAction:^(UIAlertAction *action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    NSLog(@"回到主界面");
                } cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            } else {
                
                [AllUtils showPromptDialog:@"提示" andMessage:@"服务器异常，增加笔记失败！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    } else {
        [AllUtils showPromptDialog:@"提示" andMessage:@"标题和内容缺一不可！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
    }
}

- (IBAction)addImage:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
 
    //获取照片的原图
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.image = original;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *array = @[self.image];
    self.noteTextTextView.imagesArray = [NSMutableArray arrayWithArray:array];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.noteTitleTextField endEditing:YES];
    [self.noteTextTextView endEditing:YES];
}


@end
