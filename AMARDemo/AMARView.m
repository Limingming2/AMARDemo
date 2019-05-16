//
//  AMARView.m
//  AMARDemo
//
//  Created by limingming on 2019/5/15.
//  Copyright © 2019 xiaoming. All rights reserved.
//

#import "AMARView.h"

@interface AMARView ()
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGFloat currentRotation;
@property (nonatomic, assign) CGFloat currentScale;
@end

@implementation AMARView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    pan.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:pan];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [self addGestureRecognizer:rotation];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    SCNNode *node = self.scene.rootNode.childNodes.firstObject;
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
            self.currentScale = pinch.scale;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat scale = self.currentScale - pinch.scale;
            node.scale = SCNVector3Make(scale + node.scale.x, scale + node.scale.y, scale + node.scale.z);
            self.currentScale = pinch.scale;
        }
        default:
            break;
    }
}

- (void)rotationAction:(UIRotationGestureRecognizer *)rotation
{
    SCNNode *node = self.scene.rootNode.childNodes.firstObject;
    CGFloat w = rotation.rotation;
    
    switch (rotation.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.currentRotation = rotation.rotation;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            w = self.currentRotation - rotation.rotation;
            node.rotation = SCNVector4Make(node.worldPosition.x, node.worldPosition.y, node.worldPosition.z, w  + node.rotation.w);
            self.currentRotation = rotation.rotation;
        }
            break;
        default:
            break;
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    SCNNode *node = self.scene.rootNode.childNodes.firstObject;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.currentPoint = [pan locationInView:self];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pan locationInView:self];
            CGFloat x = (self.currentPoint.x - point.x) / 5;
            CGFloat y = (self.currentPoint.y - point.y) / 5;
            node.worldPosition = SCNVector3Make(node.position.x, node.position.y + y, node.position.z + x);
            
            self.currentPoint = point;
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
            self.currentPoint = CGPointZero;
            break;
        case UIGestureRecognizerStateEnded:
            self.currentPoint = CGPointZero;
            break;
        default:
            break;
    }
    NSLog(@"%@", pan);
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    SCNNode *node = self.scene.rootNode.childNodes.firstObject;
    if (tap.numberOfTouches == 2) {
        node.position = SCNVector3Make(node.position.x, node.position.y, node.position.z - 10);
    }else {
        node.position = SCNVector3Make(node.position.x  - 10, node.position.y, node.position.z);
    }
//    node.rotation = SCNVector4Make(<#float x#>, <#float y#>, <#float z#>, <#float w#>)
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

@end
