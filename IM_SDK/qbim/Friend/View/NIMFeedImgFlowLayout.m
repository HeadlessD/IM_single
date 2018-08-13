//
//  NIMFeedImgFlowLayout.m
//  QianbaoIM
//
//  Created by iln on 14/8/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFeedImgFlowLayout.h"

@interface NIMFeedImgFlowLayout()
@property (nonatomic) CGSize size;
@end

@implementation NIMFeedImgFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
}

+ (CGSize)CollectionBubbleSizeWithCount:(NSInteger)count{
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width-16;
    CGSize size = CGSizeZero;
    if (count < 3) {
        size = CGSizeMake(width, width/2);
    }else if (count < 4){
        size = CGSizeMake(width, width / 3);
    }else if (count < 5){
        size = CGSizeMake(width,width);
        
    }else if (count < 10){
        NSInteger lines = 2;
        if (count>=5 && count <= 6) {
            lines = 2;
        }else{
            lines = 3;
        }
        size = CGSizeMake(width, (width / 3) * lines);
    }
    
    return size;
}

- (CGSize)collectionViewContentSize
{
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    CGSize size = CGSizeZero;
    if (_cellCount < 3) {
        size = CGSizeMake(width, ceil(width/2));
    }else if (_cellCount < 4){
        size = CGSizeMake(width, ceil(width / 3));
    }else if (_cellCount < 5){
        size = CGSizeMake(width,width);
    }else if (_cellCount < 10){
        NSInteger lines = 2;
        if (_cellCount >= 5 && _cellCount <= 6) {
            lines = 2;
        }else{
            lines = 3;
        }
        
        size = CGSizeMake(width, ceil((width / 3) * lines));
    }
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    CGSize cSize = self.collectionView.frame.size;
    CGSize size = CGSizeZero;
    CGPoint p = CGPointZero;
    if (_cellCount < 3) {
        CGFloat w = ceil(cSize.width/2);
        size = CGSizeMake(w, w);
        p = CGPointMake(path.row * w, 0);
    }else if (_cellCount < 4){
        CGFloat w = ceil(cSize.width/ 3);
        size = CGSizeMake(w, w);
        p = CGPointMake(path.row * w, 0);
        
    }else if (_cellCount < 5){
        CGFloat w = ceil(cSize.width/ 2);
        size = CGSizeMake(w, w);
        CGFloat y = ceil((path.row + 0) / 2) * w;
        p = CGPointMake(path.row % 2 * w, y);
        
    }else if (_cellCount < 10){
        CGFloat w = ceil(cSize.width/ 3);
        size = CGSizeMake(w,w);
        CGFloat y = ceil((path.row + 0) / 3) * w;
        p = CGPointMake(path.row % 3 * w, y);
    }
    attributes.size = size;
    CGRect frame = CGRectZero;
    frame.origin = p;
    frame.size = size;
    attributes.frame = frame;
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the inserted ones) and
// even gets called when deleting cells!
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)path
{
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:path];
//    CGSize cSize = self.collectionView.frame.size;
//    CGSize size = CGSizeZero;
//    CGPoint p = CGPointZero;
//    if (_cellCount < 3) {
//        size = CGSizeMake(cSize.width / 2, cSize.width/2);
//        p = CGPointMake(path.row * size.width, 0);
//    }else if (_cellCount < 4){
//        size = CGSizeMake(cSize.width / 3, cSize.width / 3);
//        p = CGPointMake(path.row * size.width, 0);
//        
//    }else if (_cellCount < 5){
//        size = CGSizeMake(cSize.width / 2, cSize.width / 2);
//        p = CGPointMake(path.row % 2 * size.width, path.row % 2);
//        
//    }else if (_cellCount < 10){
//        size = CGSizeMake(cSize.width / 3, cSize.width / 3);
//    }
//    
//    attributes.size = size;
//    CGRect frame = CGRectZero;
//    frame.origin = p;
//    frame.size = size;
//    attributes.frame = frame;
    return attributes;
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the deleted ones) and
// even gets called when inserting cells!
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    return attributes;
}

@end
