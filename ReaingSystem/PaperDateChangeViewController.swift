//
//  PaperDateChangeViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol ChangePaperDataDelegate {
    func sentData(data: String)
}

class PaperDateChangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    //年
    var yearArray: [Int] = []
    var monthArray: [Int] = []
    var dayArray: [Int] = []
    //传值代理
    var sendDelegate: ChangePaperDataDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.initDate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        self.sendDelegate.sentData("")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func downClick(sender: UIButton) {
        
        self.sendDelegate.sentData(self.getSearchData())
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return yearArray.count
        case 1:
            return monthArray.count
        case 2:
            return dayArray.count
        default:
            return 0
        }
    }

    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let width = self.pickerView(pickerView, widthForComponent: component)
        let height = self.pickerView(pickerView, rowHeightForComponent: component)
        //返回UIVIew
        let returnView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height-10))
        //添加UILabel
        let label = UILabel()
        label.frame = returnView.frame
        label.font = UIFont.systemFontOfSize(15)
        returnView.addSubview(label)
        //赋值
        switch component {
        case 0:
            let yearStr = intToString(0, array: yearArray)
            label.text = yearStr[row]
        case 1:
            let monthStr = intToString(1, array: monthArray)
            label.text = monthStr[row]
        case 2:
            let dayStr = intToString(2, array: dayArray)
            label.text = dayStr[row]
        default:
            break
        }
        return returnView
        
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 90
        } else {
            return 55
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            setDay(monthArray[pickerView.selectedRowInComponent(1)], year: yearArray[row])
            pickerView.reloadComponent(2)
        case 1:
            setDay(monthArray[row], year: yearArray[pickerView.selectedRowInComponent(0)])
            pickerView.reloadComponent(2)
        default:
            break
        }
    }
    
    //获取当前显示字符串
    func getSearchData() -> String{
        let year = yearArray[pickerView.selectedRowInComponent(0)]
        var month = monthArray[pickerView.selectedRowInComponent(1)]
        var day = dayArray[pickerView.selectedRowInComponent(2)]
        
        let yearStr = "\(year)"
        let monthStr: String!
        if month < 10 {
            monthStr = "0\(month)"
        } else {
            monthStr = "\(month)"
        }
        
        let dayStr: String!
        if day < 10 {
            dayStr = "0\(day)"
        } else {
            dayStr = "\(day)"
        }
        
        
        return "\(yearStr)-\(monthStr)-\(dayStr)"
    }
    
    func initDate() {
        //获取当前年份
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let year = calendar.component(.Year, fromDate: currentDate)
        let month = calendar.component(.Month, fromDate: currentDate)
        let day = calendar.component(.Day, fromDate: currentDate)
        //给年数组赋值
        var y = year - 20
        while y <= year {
            yearArray.append(y)
            y += 1
        }
        //月数组赋值
        for i in 1...12 {
            monthArray.append(i)
        }
        //天数组赋值
        setDay(month, year: year)
        //转盘初始化
        setRow(0, array: yearArray, index: year)
        setRow(1, array: monthArray, index: month)
        setRow(2, array: dayArray, index: day)
    }
    
    func setRow(component: Int, array: [Int], index: Int) {
        for i in 0..<array.count {
            if array[i] == index {
                pickerView.selectRow(i, inComponent: component, animated: true)
            }
        }

    }
    
    func intToString(component: Int, array: [Int]) -> [String] {
        let arr: [String] = array.map({ (index) in
            if index < 10 {
                return "0\(index)"
            } else {
                return "\(index)"
            }
        })
        switch component {
        case 0:
            return arr.map({
                "\($0)年"
            })
        case 1:
            return arr.map({
                "\($0)月"
            })
        case 2:
            return arr.map({
                "\($0)日"
            })
        default:
            return []
        }
    }
    
    //设定每月的天数
    func setDay(month: Int, year: Int) {
        dayArray.removeAll()
        switch month {
        case 1,3,5,7,8,10,12:
            for i in 1...31 {
                dayArray.append(i)
            }
        case 2:
            if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
                for i in 1...29 {
                   dayArray.append(i)
                }
            } else {
                for i in 1...28 {
                    dayArray.append(i)
                }
            }
        case 4,6,9,11:
            for i in 1...30 {
                dayArray.append(i)
            }
        default:
            break
        }
    }

}
