//
//  ViewController.m
//  Demo9DeleteCellAndSection
//
//  Created by vfa on 8/18/22.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *numberDic;
@property (nonatomic,strong) UIBarButtonItem *barBtnAction;
@property (nonatomic,strong) UIBarButtonItem *barBtnAction1;
@end

static NSString *SectionOddNumbers = @"Odd Numbers";
static NSString *SectionEvenNumbers = @"Even Numbers";
@implementation ViewController

-(NSMutableDictionary *) numberDic{
    if(_numberDic == nil){
        NSMutableArray *evenNum = [[NSMutableArray alloc] initWithArray:@[@0,@2,@4,@6]];
        NSMutableArray *oddNum = [[NSMutableArray alloc] initWithArray:@[@1,@3,@5,@7]];
        _numberDic = [[NSMutableDictionary alloc]
                      initWithDictionary:@{SectionOddNumbers: oddNum,
                                           SectionEvenNumbers:evenNum}];
        
    }
    return  _numberDic;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.numberDic.allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionName = self.numberDic.allKeys[section];
    NSArray *sectionArray = self.numberDic[sectionName];
    return sectionArray.count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barBtnAction = [[UIBarButtonItem alloc] initWithTitle:@"Delete Odd Number" style:UIBarButtonItemStylePlain target:self action:@selector(deleteOdd:)];
    self.barBtnAction1 = [[UIBarButtonItem alloc] initWithTitle:@"Delete Numbers >2" style:UIBarButtonItemStylePlain target:self action:@selector(deleteGreaterThan2:)];
    [self.navigationItem setRightBarButtonItem:self.barBtnAction animated:NO];
    [self.navigationItem setLeftBarButtonItem:self.barBtnAction1 animated:NO];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *sectionName = self.numberDic.allKeys[indexPath.section];
    NSArray *sectionArray = self.numberDic[sectionName];
    
    NSNumber *number = sectionArray[indexPath.row];
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[number unsignedIntegerValue]];
    
    return  cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return  self.numberDic.allKeys[section];
}

-(void) deleteOdd:(id)paramSender{
    
    NSString *key = SectionOddNumbers;
    NSInteger indexForKey = [[self.numberDic allKeys] indexOfObject:key];
    
    if(indexForKey == NSNotFound){
        return;
    }
    
    [self.numberDic removeObjectForKey:key];
    
    NSIndexSet *sectionDelete = [NSIndexSet indexSetWithIndex:indexForKey];
    
    [self.tableView deleteSections:sectionDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

-(void) deleteGreaterThan2:(id) paramSender{
    
    NSMutableArray *deleteIndexPath = [[NSMutableArray alloc]init];
    NSMutableArray *deleteObj = [[NSMutableArray alloc] init];
    
    __block NSUInteger keyIndex = 0;
    
    [self.numberDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj unsignedIntegerValue]>2){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:keyIndex];
                
                [deleteIndexPath addObject:indexPath];
                [deleteObj addObject:obj];
            }
        }];
        keyIndex++;
    }];
    
    
    if([deleteObj count]>0){
        NSMutableArray *oddNums = self.numberDic[SectionOddNumbers];
        NSMutableArray *evenNums = self.numberDic[SectionEvenNumbers];
        
        [deleteObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([oddNums indexOfObject:obj] != NSNotFound){
                [oddNums removeObject:obj];
            }
            if([evenNums indexOfObject:obj] !=NSNotFound){
                [evenNums removeObject:obj];
            }
        }];
    }
    
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}
@end
