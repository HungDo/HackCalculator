//
//  ViewController.swift
//  HackCalculator
//
//  Created by Do, Hung on 2/1/17.
//  Copyright © 2017 Do, Hung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let offset : CGFloat = 4;
    let space : CGFloat = 2;
    
    var opDisplay : UILabel?
    var display : UILabel?
    
    var savedNumber : String?
    
    var state : CalcState = CalcState.NO_OP
    var opState : OpState? = nil
    
    var opSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        self.view.addSubview(buildDisplay(x: offset,
                                          y: UIApplication.shared.statusBarFrame.height + offset,
                                          width: width - (2*offset),
                                          height: width/3 - (2*offset)))
        
        
        
        let numberPadWidth = width - width/4
        self.view.addSubview(buildNumberPad(x: offset,
                                            y: height - numberPadWidth + offset,
                                            width: numberPadWidth - offset,
                                            height: numberPadWidth - (2*offset)))
        
        let operatorsWidth = width/4
        self.view.addSubview(buildBasicOperatorsPad(x: numberPadWidth + space,
                                                    y: height - (5*operatorsWidth) + (4*space),
                                                    width: operatorsWidth - (2*offset),
                                                    height: 5*operatorsWidth))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildBasicOperatorsPad(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let container : UIView = UIView(frame: CGRect.init(x: x, y: y, width: width, height: height))
        
        // container.backgroundColor = UIColor.red
        
        var opBtn : UIButton
        var ypos : CGFloat
        for i in 0..<5 {
            ypos = (CGFloat)(i)*width + (CGFloat)(i)*offset + (CGFloat)(i)*space
        
            opBtn = UIButton.init(frame: CGRect.init(x: 0,
                                                     y: ypos,
                                                     width: width,
                                                     height: width + space))
            switch i {
            case 0:
                opBtn.setTitle("+", for: UIControlState.normal)
                break
            case 1:
                opBtn.setTitle("-", for: UIControlState.normal)
                break
            case 2:
                opBtn.setTitle("x", for: UIControlState.normal)
                break
            case 3:
                opBtn.setTitle("%", for: UIControlState.normal)
                break
            case 4:
                opBtn.setTitle("=", for: UIControlState.normal)
                break
            default:
                break
            }
            
            opBtn.backgroundColor = UIColor.lightGray
            opBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            opBtn.showsTouchWhenHighlighted = true;
            
            opBtn.addTarget(self, action: #selector(operatorSelector(sender:)), for: UIControlEvents.touchUpInside)
            
            container.addSubview(opBtn)
        }
        
        return container
    }
    
    func buildDisplay(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let container : UIView = UIView(frame: CGRect.init(x: x, y: y, width: width, height: height))
        
        let padding : CGFloat = 16
        
        opDisplay = UILabel.init(frame: CGRect.init(x: width - padding - offset, y: y+offset, width: padding, height: padding))
        opDisplay?.textAlignment = NSTextAlignment.right
        opDisplay?.text = "="
        opDisplay?.font = UIFont.systemFont(ofSize: 18)
        
        display = UILabel.init(frame: CGRect.init(x: x + offset + padding,
                                                  y: y + offset + padding,
                                                  width: width - (2*offset) - (2*padding),
                                                  height: height - (2*offset) - padding))
        
        display?.textAlignment = NSTextAlignment.right
        display?.text = "0"
        display?.font = UIFont.systemFont(ofSize: 24)
        
        container.addSubview(display!)
        container.addSubview(opDisplay!)
        container.backgroundColor = UIColor.lightGray
        
        return container;
    }

    func buildNumberPad(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let btnWidth = width/3
        let btnHeight = height/3
        let container : UIView = UIView(frame: CGRect.init(x: x, y: y, width: width, height: height))
        
        var num : UIButton
        var numFrame : CGRect
        var xpos : CGFloat
        var ypos : CGFloat
        for i in 1..<10 {
            xpos = (CGFloat)((i-1) % 3)
            ypos = (CGFloat)((i-1) / 3)
            numFrame = CGRect.init(x: btnWidth*xpos + space,
                                   y: btnHeight*ypos + space,
                                   width: btnWidth - (2*space),
                                   height: btnHeight - (2*space))
            
            num = UIButton.init(frame: numFrame)
            num.backgroundColor = UIColor.lightGray
            num.setTitle("\(i)", for: UIControlState.normal)
            num.setTitleColor(UIColor.black, for: UIControlState.normal)
            num.showsTouchWhenHighlighted = true;
            
            num.addTarget(self, action: #selector(numberSelector(sender:)), for: UIControlEvents.touchUpInside)
            
            container.addSubview(num)
        }
        
        return container;
    }
    
    func compute(savedNum: Int, displayedNum: Int, op: OpState) -> Int {
        switch op {
        case .ADD:
            return savedNum + displayedNum
        case .SUBTRACT:
            return savedNum - displayedNum
        case .MULTIPLY:
            return savedNum * displayedNum
        case .DIVID:
            return savedNum / displayedNum
        }
    }
    
    func operatorSelector(sender: UIButton) {
        opSelected = true
        
        opDisplay?.text = "\(sender.currentTitle!)"
        
        if ("\(sender.currentTitle!)" == "=") {
            state = CalcState.EQ_SELECTED
        }
        
        switch state {
        case CalcState.NO_OP:
            savedNumber = display?.text
            state = CalcState.OP_SELECTED
            switch "\(sender.currentTitle!)" {
            case "+":
                opState = OpState.ADD
                break
            case "-":
                opState = OpState.SUBTRACT
                break
            case "x":
                opState = OpState.MULTIPLY
                break
            case "%":
                opState = OpState.DIVID
                break
            default:
                break
            }
            break
        case CalcState.OP_SELECTED:
            let savedNum = Int(savedNumber!)
            let displayedNum = Int((display?.text)!)
            
            let result = compute(savedNum: savedNum!, displayedNum: displayedNum!, op: opState!)
            display?.text = "\(result)"
            
            switch "\(sender.currentTitle!)" {
            case "+":
                opState = OpState.ADD
                break
            case "-":
                opState = OpState.SUBTRACT
                break
            case "x":
                opState = OpState.MULTIPLY
                break
            case "%":
                opState = OpState.DIVID
                break
            default:
                break
            }
            break
        case CalcState.EQ_SELECTED:
            let savedNum = Int(savedNumber!)
            let displayedNum = Int((display?.text)!)
            
            let result = compute(savedNum: savedNum!, displayedNum: displayedNum!, op: opState!)
            
            display?.text = "\(result)"
            
            state = CalcState.NO_OP
            break
        }
    }
    
    func numberSelector(sender: UIButton) {
        if ((display?.text!.characters.count)! < 20) {
            display?.text = ((display?.text)! == "0") || opSelected ?
                "\(sender.currentTitle!)" : (display?.text)! + "\(sender.currentTitle!)"
        }
        
        opSelected = false
    }
}

