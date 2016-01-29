//
//  CLContactsTableViewCell.m
//  Cardman
//
//  Created by Jason Lee on 16/1/29.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLContactsTableViewCell.h"
#import "CLPerson.h"
#import "UIView+CLFrameShortcut.h"

@interface CLContactsTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *avatarMaskView; // 用来遮罩成圆形头像，避免使用CALayer耗费性能

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *noteLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation CLContactsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.contentView addSubview:_noteLabel];
        _noteLabel.font = [UIFont systemFontOfSize:12.0f];
        _noteLabel.textColor = [UIColor grayColor];
    }
    return _noteLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        _bottomLine.height = 0.5f;
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

#pragma mark -

- (void)configWithCLPerson:(CLPerson *)clPerson {
    UIImage *avatar = [UIImage imageNamed:@"CLDefaultAvatar_Male"];
    if (clPerson.avatar != nil) avatar = clPerson.avatar;
    self.avatarView.image = avatar;
    
    // 在没有遮罩之前先绘制成圆形头像
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.width / 2;
    self.avatarView.layer.borderWidth = 1.0f;
    self.avatarView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.nameLabel.text = clPerson.name.compositeName;
    [self.nameLabel sizeToFit];
    
    NSString *notes = nil;
    if ([clPerson.job hasInfo]) {
        notes = [clPerson.job fullJobTitle];
    } else if (clPerson.note.length > 0) {
        notes = clPerson.note;
    }
    
    if (notes) {
        self.noteLabel.text = notes;
        [self.noteLabel sizeToFit];
    }
}

#pragma mark -

- (void)layoutSubviews {
    if (_avatarView) {
        _avatarView.left = 10.0f;
        _avatarView.top = 8.0f;
        
        _nameLabel.left = _avatarView.right + 10.0f;
        _nameLabel.top = _avatarView.top + 4.0f;
        
        _noteLabel.left = _nameLabel.left;
        _noteLabel.bottom = _avatarView.bottom - 4.0f;
        
        self.bottomLine.left = _nameLabel.left;
        self.bottomLine.bottom = self.contentView.height;
        self.bottomLine.width = self.contentView.width - self.bottomLine.left - 20.0f;
    }
}

@end
