//
//  InterfaceController.swift
//  pm25test WatchKit Extension
//
//  Created by xiaobo on 15/4/22.
//  Copyright (c) 2015年 xiaobo. All rights reserved.
//

import WatchKit
import Foundation

struct CityAQI {
    var city:String
    var aqi:Int
    var level:String
}

func warningInfo(aqi: Int) -> (bgcolor:UIColor,fgcolor:UIColor, suggestion:String) {
    
    switch aqi {
    case 0...50:
        return (UIColor.greenColor(),UIColor.lightGrayColor(),"清新世界太美丽")
    case 51...100:
        return (UIColor.yellowColor(),UIColor.lightGrayColor(),"平淡日子静静流")
    case 101...150:
        return (UIColor.orangeColor(),UIColor.whiteColor(),"愁云惨雾万里凝")
    case 151...200:
        return (UIColor.redColor(),UIColor.whiteColor(),"雾霾来袭兵临城")
    case 201...300:
        return (UIColor.purpleColor(),UIColor.whiteColor(),"魔王压境无明日")
    case 300...999:
        return (UIColor.brownColor(),UIColor.whiteColor(),"天诛地灭人绝迹")
    default:
        return (UIColor.blackColor(),UIColor.whiteColor(),"")
    }
}


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var labelCitySH: WKInterfaceLabel!
    @IBOutlet weak var labelCityBJ: WKInterfaceLabel!
    
    @IBOutlet weak var groupBJ: WKInterfaceGroup!
    @IBOutlet weak var labelBeijing: WKInterfaceLabel!
    @IBOutlet weak var labelShanghai: WKInterfaceLabel!
    
    @IBOutlet weak var groupSH: WKInterfaceGroup!
    
    @IBOutlet weak var labelLevelBJ: WKInterfaceLabel!
    @IBOutlet weak var labelLevelSH: WKInterfaceLabel!
    
    
    @IBOutlet weak var labelCitySY: WKInterfaceLabel!
    @IBOutlet weak var labelSY: WKInterfaceLabel!
    @IBOutlet weak var labelLevelSY: WKInterfaceLabel!
    
    @IBOutlet weak var groupSY: WKInterfaceGroup!
    
    @IBOutlet weak var labelCityDL: WKInterfaceLabel!
    
    @IBOutlet weak var labelDL: WKInterfaceLabel!
    
    @IBOutlet weak var labelLevelDL: WKInterfaceLabel!
    
    @IBOutlet weak var groupDL: WKInterfaceGroup!
    
    @IBOutlet weak var labelSuggestBJ: WKInterfaceLabel!
    
    @IBOutlet weak var labelSuggestSH: WKInterfaceLabel!
    
    @IBOutlet weak var labelSuggestSY: WKInterfaceLabel!
    
    
    @IBOutlet weak var labelSuggestDL: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    func getAQI(city:String, completion:(CityAQI?)->()) {
        
            let baseURL = "http://apistore.baidu.com/microservice/aqi?city="
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            

                let requestURL = (baseURL + city).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let task = session.dataTaskWithURL(NSURL(string: requestURL!)!, completionHandler: { (data, resp, error) -> Void in
                    if error == nil {
                        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                            
                            if let retData = json["retData"] as? NSDictionary, aqi = retData["aqi"] as? Int, level = retData["level"] as? String {
                                let cityAQI = CityAQI(city: city, aqi: aqi, level: level)
                                
                                completion(cityAQI)
                            }
                            
                        }
                    }
                })
                task.resume()
        
    }
    


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let bj = labelBeijing, levelbj = labelLevelBJ {
            
            getAQI("北京", completion: { (ci:CityAQI?) -> () in
                if let ci = ci {
                    bj.setText(ci.aqi.description)
                    bj.setTextColor(warningInfo(ci.aqi).fgcolor)
                    
                    
                    levelbj.setText(ci.level)
                    levelbj.setTextColor(warningInfo(ci.aqi).fgcolor)
                    self.groupBJ.setBackgroundColor(warningInfo(ci.aqi).bgcolor)
                    self.labelSuggestBJ.setText(warningInfo(ci.aqi).suggestion)
                    
                } else {
                    println("没有获取到数据")
                }
                
            })
        }
        
        if let sh = labelShanghai, levelsh = labelLevelSH {
            getAQI("上海", completion: { (ci:CityAQI?) -> () in
                
                if let ci = ci {
                    sh.setText(ci.aqi.description)
                    sh.setTextColor(warningInfo(ci.aqi).fgcolor)
                    levelsh.setText(ci.level)
                    levelsh.setTextColor(warningInfo(ci.aqi).fgcolor)
                    self.groupSH.setBackgroundColor(warningInfo(ci.aqi).bgcolor)
                    self.labelSuggestSH.setText(warningInfo(ci.aqi).suggestion)
                } else {
                    println("没有获取到数据")
                }
                
                
            })
        }
        
        if let sy = labelSY, levelsy = labelLevelSY {
            getAQI("三亚", completion: { (ci:CityAQI?) -> () in
                if let ci = ci {
                    sy.setText(ci.aqi.description)
                    sy.setTextColor(warningInfo(ci.aqi).fgcolor)
                    levelsy.setText(ci.level)
                    levelsy.setTextColor(warningInfo(ci.aqi).fgcolor)
                    self.groupSY.setBackgroundColor(warningInfo(ci.aqi).bgcolor)
                    self.labelSuggestSY.setText(warningInfo(ci.aqi).suggestion)
                }
            })
        }
        
        if let dl = labelDL, leveldl = labelLevelDL {
            getAQI("大连", completion: { (ci:CityAQI?) -> () in
                if let ci = ci {
                    dl.setText(ci.aqi.description)
                    dl.setTextColor(warningInfo(ci.aqi).fgcolor)
                    leveldl.setText(ci.level)
                    leveldl.setTextColor(warningInfo(ci.aqi).fgcolor)
                    self.groupDL.setBackgroundColor(warningInfo(ci.aqi).bgcolor)
                    self.labelSuggestDL.setText(warningInfo(ci.aqi).suggestion)
                }
            })
        }
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
