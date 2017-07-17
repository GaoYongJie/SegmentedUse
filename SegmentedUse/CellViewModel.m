//
//  CellViewModel.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/14.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "CellViewModel.h"
#import "CellModel.h"

@interface CellViewModel ()

@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@end
@implementation CellViewModel

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CellModel *)model
{
    if (_model != model)
    {
        _model = model;
    }
    
    _fileNameLab.text = _model.fileName;
    
    if (model.isSign)
    {
        _signImg.image = [UIImage imageNamed:@"round_sel"];
    }
    else
    {
        _signImg.image = [UIImage imageNamed:@"round"];
    }
}

//WORD
//EXCEL
//PDF
- (void)setFileType:(NSString *)fileType
{
    if (_fileType !=fileType)
    {
        _fileType = fileType;
    }
    if ([_fileType isEqualToString:@"WORD"])
    {
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"Word"] forState:UIControlStateNormal];
    }
    else if ([_fileType isEqualToString:@"EXCEL"])
    {
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"Excel"] forState:UIControlStateNormal];
    }
    else if ([_fileType isEqualToString:@"PDF"])
    {
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"pdf_page"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
