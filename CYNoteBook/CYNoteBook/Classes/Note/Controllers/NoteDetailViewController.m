//
//  NoteDetailViewController.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteUtils.h"
#import "AllUtils.h"
#import "NoteDBModel.h"

@interface NoteDetailViewController ()


@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.noteTitleTextField.text = self.model.noteTitle;
    self.noteTextTextView.text = self.model.noteText;
    
    self.timeLabel.text = [AllUtils getDateFromString:self.model.noteCreatedTime];

    self.locationLabel.text = self.model.noteLocation;
    
    if (self.model.images) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:self.model.images];
        
        //获得类
        NSArray *arr = [unarchiver decodeObjectForKey:@"kArchivingDataKey"];// initWithCoder方法被调用
        [unarchiver finishDecoding];
        
        UIImage *image = arr[0];
        
        self.imageView.image = image;
    }
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
    if (![noteTitle isEqualToString:@""] && ![noteText isEqualToString:@""]){
        [NoteUtils updateNoteWithNoteModel:self.model noteTitle:noteTitle noteText:noteText time:time  todo:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                [AllUtils showPromptDialog:@"提示" andMessage:@"修改笔记成功" OKButton:@"确定" OKButtonAction:^(UIAlertAction *action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    NSLog(@"回到主界面");
                } cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }else {
                
                [AllUtils showPromptDialog:@"提示" andMessage:@"服务器异常，增加笔记失败！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    } else {
        [AllUtils showPromptDialog:@"提示" andMessage:@"标题和内容缺一不可！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
    }
}

@end
