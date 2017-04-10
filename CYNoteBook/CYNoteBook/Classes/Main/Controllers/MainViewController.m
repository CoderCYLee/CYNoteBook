//
//  MainViewController.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/3/31.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "MainViewController.h"
#import "AddNoteViewController.h"
#import "NoteDetailViewController.h"
#import "NoteDBModel.h"
#import "NoteUtils.h"
#import "AllUtils.h"
#import "SettingTableViewController.h"
#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *writeButton;

@property (weak, nonatomic) IBOutlet UITableView *noteTableView;//“笔记”的TableView

//存放笔记对象的可变数组；
@property(nonatomic,strong) NSMutableArray *notesArray;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [LocationManager shareInstance];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestAllNotes];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoteDBModel *model = [self.notesArray objectAtIndex:indexPath.row];
    
    //设置TableView的圆角；
    tableView.layer.cornerRadius = 10;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoteCell"];
    }
    
    cell.textLabel.text = model.noteTitle;
    cell.detailTextLabel.text = model.noteText;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width , 50)];
    view.backgroundColor = [UIColor whiteColor];
    //需要在Header底部加一条细线，用来分隔第一个cell；默认Header和第一个cell之间是没有分隔线的；
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 50, 30)];
    noteLabel.text = @"笔记";
    noteLabel.textColor = [UIColor grayColor];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - 60, 10, 50, 30)];
    totalLabel.text = @"全部";
    totalLabel.textColor = [UIColor grayColor];
    totalLabel.font = [UIFont systemFontOfSize:12];
    
    //在Header底部绘制一条线；
    UIView *drawLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, tableView.bounds.size.width, 1)];
    drawLine.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    
    [view addSubview:noteLabel];
    [view addSubview:totalLabel];
    [view addSubview:drawLine];
    //增加Header的点击事件；
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteHeaderPressed:)]];
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoteDetailViewController *noteDetailVC = [[NoteDetailViewController alloc] init];
    NoteDBModel *model = self.notesArray[indexPath.row];
    noteDetailVC.model = model;
    [self presentViewController:noteDetailVC animated:YES completion:nil];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //左滑删除；
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //数据库删除；
        [NoteUtils deleteNoteModel:self.notesArray[indexPath.row]];
        
        [self.notesArray removeObjectAtIndex:indexPath.row];//从数组中删除该值；
        [self.noteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (100 * [self.notesArray count] < [UIScreen mainScreen].bounds.size.height) {
            
            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, 100 * [self.notesArray count]);
        }else{
            
            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 65);
        }
    }
}

- (void)requestAllNotes {
    NSArray *allNotes = [NoteUtils findAll];
    self.notesArray = [NSMutableArray arrayWithArray:allNotes];
    [self.noteTableView reloadData];
}

#pragma mark - action
- (void)noteHeaderPressed:(UITapGestureRecognizer *)sender {
    
}

- (IBAction)writeNote:(id)sender {
    
    AddNoteViewController *addNoteVC = [[AddNoteViewController alloc] init];
    
    [self presentViewController:addNoteVC animated:YES completion:nil];
}

- (IBAction)imageNote:(id)sender {
    
}

- (IBAction)setting:(id)sender {
    
//    SettingTableViewController *settingVC = [[SettingTableViewController alloc] init];
//    
//    [self presentViewController:settingVC animated:YES completion:nil];
    
}

#pragma mark - lazy
- (NSMutableArray *)notesArray
{
    if (!_notesArray) {
        _notesArray = [[NSMutableArray alloc] init];
    }
    return _notesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
