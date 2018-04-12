//
//  BoardView.swift
//  UndoRedoDemo
//
//  Created by Ronak Kalavadia on 28/03/18.
//  Copyright © 2018 Ronak Kalavadia. All rights reserved.
//

import UIKit

protocol UpdateUndoRedoButtonDelegate {
    func updateUndoRedoButtons()
    func addCustomView(view: UIView)
    func removeCustomView(view: UIView)
}

class BoardView: UIView,UIGestureRecognizerDelegate {
    
    var delegate: UpdateUndoRedoButtonDelegate?
    
    var selectedView = UIView()
    
    var oldTranslate = CGPoint()
    var oldTransform = CGAffineTransform()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.updateUndoRedoButtons()
        }
        self.observeUndoManager()
        self.createPanGestureRecognizer(targetView: self)
        self.createRotationGestureRecognizer(targetView: self)
        self.createPinchGestureRecognizer(targetView: self)
    }
    
    @objc func updateUndoRedoButtons(){
        if let delegate = delegate{
            delegate.updateUndoRedoButtons()
        }
    }
    
    private func observeUndoManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUndoRedoButtons), name: NSNotification.Name.NSUndoManagerDidUndoChange, object: UndoRedoManager.undoManager)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUndoRedoButtons), name: NSNotification.Name.NSUndoManagerDidRedoChange, object: UndoRedoManager.undoManager)
    }
    
    @objc func undoManagerDidUndoNotification() {
        updateUndoRedoButtons()
    }
    
    @objc func undoManagerDidRedoNotification() {
        updateUndoRedoButtons()
    }
    
    // The Tap Gesture
    func createTapGestureRecognizer(targetView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(handleTapGesture(tapGesture:)))
        tapGesture.delegate = self
        targetView.addGestureRecognizer(tapGesture)
    }
    
    // The Pan Gesture
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(panGesture:)))
        panGesture.delegate = self
        targetView.addGestureRecognizer(panGesture)
    }
    
    // The Rotation Gesture
    func createRotationGestureRecognizer(targetView: UIView) {
        //add rotate gesture.
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(rotateGesture:)))
        rotate.delegate = self
        targetView.addGestureRecognizer(rotate)
    }
    
    // The Pinch Gesture
    func createPinchGestureRecognizer(targetView: UIView) {
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinchGesture:)))
        pinchGesture.delegate = self
        targetView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer){
        if let view = tapGesture.view {
            if view is BoardView {
                return
            }
            selectedView = view
        }
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        if panGesture.state == UIGestureRecognizerState.began {
            oldTranslate = selectedView.center
        }
        if panGesture.state == UIGestureRecognizerState.ended {
            registerUndoMoveView(view: selectedView, oldTranslate: oldTranslate, newTranslate: selectedView.center)
            updateUndoRedoButtons()
        }

        selectedView.center = CGPoint(x:selectedView.center.x + translation.x,
                                      y:selectedView.center.y + translation.y)
        panGesture.setTranslation(.zero, in: self)
    }
    
    @objc func handleRotate(rotateGesture : UIRotationGestureRecognizer) {
        
        let rotation: CGFloat = rotateGesture.rotation
        selectedView.transform = selectedView.transform.rotated(by:rotation)
        
        if rotateGesture.state == UIGestureRecognizerState.began {
            oldTransform = selectedView.transform
        }else if rotateGesture.state == UIGestureRecognizerState.ended {
            registerUndoRotateView(view: selectedView, oldTransform: oldTransform, newTransform: selectedView.transform)
            updateUndoRedoButtons()
        }
        rotateGesture.rotation = 0.0
        
    }
    
    @objc func pinchRecognized(pinchGesture: UIPinchGestureRecognizer) {
        //        if let targetView = selectedView as? CustomView{
//                    targetView.transform = targetView.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
//                    if pinchGesture.state == UIGestureRecognizerState.began {
//                        oldTransform = targetView.transform
//                    }
//                    if pinchGesture.state == UIGestureRecognizerState.ended {
//                        registerUndoRotateView(view: targetView, oldTransform: oldTransform, newTransform: targetView.transform)
//                        updateUndoRedoButtons()
//                    }
        //        }else if let targetView = selectedView as? CustomLabel {
        //            var pinchScale = pinchGesture.scale
        //            pinchScale = round(pinchScale * 1000) / 1000.0
        //            if (pinchScale < 1) {
        //                if targetView.font.pointSize >= 20{
        //                    targetView.font = UIFont.boldSystemFont(ofSize: targetView.font.pointSize - pinchScale)
        //                    targetView.autoresize()
        //                }
        //            }
        //            else{
        //                if targetView.font.pointSize <= 70{
        //                    targetView.font = UIFont.boldSystemFont(ofSize: targetView.font.pointSize + pinchScale)
        //                    targetView.autoresize()
        //                }
        //            }
        //        }
        //        pinchGesture.scale = 1
        
        //        if let view = pinchGesture.view as? CustomLabel {
        var pinchScale = pinchGesture.scale
        if ((-0.08)...(-0.001)).contains(pinchGesture.velocity) {
//            print("Return Velocity: \(pinchGesture.velocity)")
            return
        }
//        print("Velocity: \(pinchGesture.velocity)")
        
        if let targetView = selectedView as? CustomView{
            if pinchGesture.state == UIGestureRecognizerState.began {
                oldTransform = selectedView.transform
            }
            if pinchGesture.state == UIGestureRecognizerState.ended {
                registerUndoRotateView(view: selectedView, oldTransform: oldTransform, newTransform: selectedView.transform)
                updateUndoRedoButtons()
            }
            targetView.transform = targetView.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
        }else if let targetView = selectedView as? CustomLabel {
            pinchScale = round(pinchScale * 1000) / 1000.0
            if (pinchScale < 1) {
                if targetView.font.pointSize >= 20{
                    targetView.font = UIFont.boldSystemFont(ofSize: targetView.font.pointSize - pinchScale)
                    targetView.autoresize()
                }
            }
            else{
                if targetView.font.pointSize <= 100{
                    targetView.font = UIFont.boldSystemFont(ofSize: targetView.font.pointSize + pinchScale)
                    targetView.autoresize()
                }
            }

        }
        
        pinchGesture.scale = 1.0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Undo for move
    @objc func moveView(view: UIView, oldTranslate: CGPoint, newTranslate: CGPoint) {
        registerUndoMoveView(view: view, oldTranslate: oldTranslate, newTranslate: newTranslate)
        view.center = oldTranslate
    }
    
    // Undo for rotate
    func registerUndoRotateView(view: UIView, oldTransform: CGAffineTransform, newTransform: CGAffineTransform) {
        UndoRedoManager.undoManager.registerUndo(withTarget: self) { (ViewController) in
            self.rotateView(view: view, oldTransform: oldTransform, newTransform: newTransform)
        }
    }
    
    // Rotate
    @objc func rotateView(view: UIView, oldTransform: CGAffineTransform, newTransform: CGAffineTransform) {
        registerUndoRotateView(view: view, oldTransform: oldTransform, newTransform: newTransform)
        view.transform = oldTransform
    }
    
    /// MARK: Undo Manager Actions
    func registerUndoAddView(view: UIView) {
        UndoRedoManager.undoManager.registerUndo(withTarget: self) { (ViewController) in
            if let delegate = self.delegate{
                delegate.removeCustomView(view: view)
            }
        }
    }
    
    func registerUndoRemoveView(view: UIView) {
        UndoRedoManager.undoManager.registerUndo(withTarget: self) { (ViewController) in
            if let delegate = self.delegate{
                delegate.addCustomView(view: view)
            }
        }
    }
    
    func registerUndoMoveView(view: UIView, oldTranslate: CGPoint, newTranslate: CGPoint) {
        UndoRedoManager.undoManager.registerUndo(withTarget: self) { (ViewController) in
            self.moveView(view: view, oldTranslate: oldTranslate, newTranslate: newTranslate)
        }
    }
    
}

extension UILabel {
    func autoresize() {
        if let textNSString: String = self.text {
            let previousHeight = self.bounds.size.height
            let rect = textNSString.boundingRect(with: CGSize(width:self.bounds.size.width,height: CGFloat.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedStringKey.font: self.font],
                                                 context: nil)
            let changeInHeight = rect.height - previousHeight
            self.bounds = CGRect(x: self.bounds.origin.x,y: self.bounds.origin.y-(changeInHeight/2),width: self.bounds.size.width,height: rect.height)
        }
    }
}

