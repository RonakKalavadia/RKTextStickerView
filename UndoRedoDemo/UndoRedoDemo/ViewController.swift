//
//  ViewController.swift
//  UndoRedoDemo
//
//  Created by Ronak Kalavadia on 28/03/18.
//  Copyright © 2018 Ronak Kalavadia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnRedo: UIButton!
    @IBOutlet weak var curveSlider: UISlider!
    @IBOutlet weak var fontSlider: UISlider!
    
    var myCustomViews = [CustomView]()
    var myCustomLabels = [CustomLabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnAddViewClicked(_ sender: UIButton) {
        let customView = CustomView(frame: CGRect(x: boardView.center.x - 50, y: boardView.center.y - 50, width: 100, height: 100))
        boardView.addSubview(customView)
        myCustomViews.append(customView)
        boardView.selectedView = customView
        boardView.createTapGestureRecognizer(targetView: customView)
        boardView.registerUndoAddView(view: customView)
        updateUndoRedoButtons()
    }
    
    @IBAction func btnAddLabelClicked(_ sender: UIButton) {
        let customLabel = CustomLabel(frame: boardView.bounds)
        boardView.addSubview(customLabel)
        myCustomLabels.append(customLabel)
        boardView.selectedView = customLabel
        boardView.createTapGestureRecognizer(targetView: customLabel)
        boardView.registerUndoAddView(view: customLabel)
        updateUndoRedoButtons()
    }
    
    /// MARK: Actions on Views
    @objc func addView(_ view: UIView) {
        boardView.registerUndoAddView(view: view)
        boardView.addSubview(view)
        if view.isKind(of: CustomView().classForCoder) {
            myCustomViews.append(view as! CustomView)
        }else if view.isKind(of: CustomLabel().classForCoder){
            myCustomLabels.append(view as! CustomLabel)
        }
        updateUndoRedoButtons()
    }
    
    @objc func removeView(_ view: UIView) {
        boardView.registerUndoRemoveView(view: view)
        view.removeFromSuperview()
        if view.isKind(of: CustomView().classForCoder) {
            if let index = myCustomViews.index(of: view as! CustomView) {
                myCustomViews.remove(at: index)
            }
        }else if view.isKind(of: CustomLabel().classForCoder){
            if let index = myCustomLabels.index(of: view as! CustomLabel) {
                myCustomLabels.remove(at: index)
            }
        }
    }
    
    @IBAction func btnUndoClicked(_ sender: UIButton) {
        UndoRedoManager.undoManager.undo()
    }
    
    @IBAction func btnRedoClicked(_ sender: UIButton) {
        UndoRedoManager.undoManager.redo()
    }
    

}

extension ViewController: UpdateUndoRedoButtonDelegate{
    func updateUndoRedoButtons(){
        btnUndo.isEnabled = UndoRedoManager.undoManager.canUndo == true
        btnRedo.isEnabled = UndoRedoManager.undoManager.canRedo == true
    }
    
    func addCustomView(view: UIView) {
        self.addView(view)
    }
    
    func removeCustomView(view: UIView) {
        self.removeView(view)
    }
}

