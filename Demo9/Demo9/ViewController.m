//
//  ViewController.m
//  Demo9
//
//  Created by vfa on 8/18/22.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionArr;
@end

@implementation ViewController

-(NSMutableArray *) newSectionWithIndex:(NSUInteger *) index cellCount:(NSUInteger) cellCount{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSInteger counter = 0;
    for(counter = 0 ; counter<cellCount;counter++){
        [result addObject:[[NSString alloc]initWithFormat:@"Section %lu Cell %lu",(unsigned long)index,(unsigned long)counter+1]];
    }
    return  result;
}

-(NSMutableArray *) sectionArr{
    
    if(_sectionArr == nil){
    
        NSMutableArray *section1 = [self newSectionWithIndex:1 cellCount:3];
        NSMutableArray *section2 = [self newSectionWithIndex:2 cellCount:3];
        NSMutableArray *section3 = [self newSectionWithIndex:3 cellCount:3];
        
        _sectionArr = [[NSMutableArray alloc] initWithArray:@[section1,section2,section3]];
    }
    
    NSLog(@"%lu", (unsigned long)_sectionArr.count);
    return  _sectionArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *sectionArray = self.sectionArr[section];
    return sectionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.sectionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableArray *sectionArray = self.sectionArr[indexPath.section];
    cell.textLabel.text = sectionArray[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
    if(action == @selector(copy:)) return YES;
    return NO;
}

-(void) tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if(action == @selector(copy:)){
        UITableViewCell * cell =[tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:cell.textLabel.text];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview: self.tableView];

    
    //move section 1 to section 3
    
    [self moveSection1ToSection3];
        // Do any additional setup after loading the view.
}
-(void) moveSection1ToSection3{
    NSMutableArray *section1 = self.sectionArr[0];
    NSLog(@"%@",section1);
    [self.sectionArr removeObject:section1];
    [self.sectionArr addObject:section1];

    [self.tableView moveSection:0 toSection:2];
}

@end
