//
//  TransitionType.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import UIKit

enum ModalOperationType {
    case Presentation, Dismissal
}

enum TransitionType {
    case NavigtionTransition(UINavigationControllerOperation)
    case TabTransition(TabOperationDirection)
    case ModalTransition(ModalOperationType)
    
}

enum TabOperationDirection {
    case Left, Right
}
