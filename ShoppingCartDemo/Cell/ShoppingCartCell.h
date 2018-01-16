//
//  ShoppingCartCell.h
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

//购物车单元格
@interface ShoppingCartCell : UITableViewCell

//单元格对应的购物车中单个产品
@property (nonatomic, strong) ShoppingCartProduct *shoppingCartProduct;

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//减少按钮，tag为0
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
//添加按钮，tag为1
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
