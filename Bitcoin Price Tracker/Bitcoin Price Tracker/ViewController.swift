//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by ADG RIT 2 on 31/03/19.
//  Copyright © 2019 Harshubh Meherishi. All rights reserved.
//

import UIKit
import SwiftChart
class ViewController: UIViewController, ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        //
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    //
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        //
    }
    

    struct Prices: Decodable{
        let bpi: [String: Bpi]
        
    }
    struct Bpi: Decodable{
        let code: String?
        let rate_float: Double?
    }
    func updatechart(usdValue: Double, priceArray: inout [Double]){
        if priceArray.count > 20{
            priceArray.remove(at: 0)
        }
        
        priceArray.append(usdValue)
        let series = ChartSeries(priceArray)
        Chart.removeAllSeries()
        Chart.add(series)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getPrice()
        Chart.delegate = self
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getPrice), userInfo: nil, repeats: true)
        //print(MySeg)
    }
    
    @IBOutlet weak var Chart: Chart!
    @IBOutlet weak var MySeg: UISegmentedControl!
    var arrayUSD: [Double] = [4000.0]
    var arrayINR: [Double] = [200000.0]
    @IBAction func buttonTap(_ sender: Any) {
        getPrice()
    }
    @IBOutlet weak var rateLabel: UILabel!
    
    @objc func getPrice(){
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/INR.json")
        URLSession.shared.dataTask(with: url!){ (data,response,error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            if let data = data{
                let price = try? JSONDecoder().decode(Prices.self, from:data)
                let bpi = price?.bpi
                //let code = bpi!["USD"]!.code
                let rateINR = bpi!["INR"]!.rate_float!
                let rateUSD = bpi!["USD"]!.rate_float!
                DispatchQueue.main.async {
                    if self.MySeg.selectedSegmentIndex == 0{
                    self.rateLabel.text = "\(rateUSD)"
                        self.updatechart(usdValue: rateUSD, priceArray: &self.arrayUSD)
                }
                    else{
                        self.rateLabel.text="\(rateINR)"
                        self.updatechart(usdValue: rateINR, priceArray: &self.arrayINR)                    }
            }
            }
            
        }.resume()
    }


}

