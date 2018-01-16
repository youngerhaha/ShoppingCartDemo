//
//  ShoppingCartCell.m
//  
//
//  Created by 李洋 on 16/8/11.
//
//

#import "ShoppingCartCell.h"

@interface ShoppingCartCell ()

//商品图片视图
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
//商品名称label
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
//价格label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//数量按钮
@property (weak, nonatomic) IBOutlet UIButton *quantityButton;
//库存label
@property (weak, nonatomic) IBOutlet UILabel *stockQuantityLabel;

@end

@implementation ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShoppingCartProduct:(ShoppingCartProduct *)shoppingCartProduct
{
    _shoppingCartProduct = shoppingCartProduct;
    self.selectButton.selected = shoppingCartProduct.isSelected;
    self.goodsNameLabel.text = shoppingCartProduct.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shoppingCartProduct.salesPrice];
    [self.quantityButton setTitle:shoppingCartProduct.quantity forState:UIControlStateNormal];
    self.stockQuantityLabel.text = [NSString stringWithFormat:@"（库存%@件）",shoppingCartProduct.stockQuantity];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
