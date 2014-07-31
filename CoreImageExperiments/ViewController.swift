//
//  ViewController.swift
//  CoreImageExperiments
//
//  Created by CraigGrummitt on 31/07/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderChanged(sender: AnyObject) {
        filterImage()
    }
    var context:CIContext = CIContext(options: nil)
    var filter:CIFilter = CIFilter(name:"CISepiaTone")
    var beginImage = CIImage(image:UIImage(named: "flowers"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(UIImage(named: "flowers"))
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        filterImage()
        
    }
    
    func filterImage() {
        
        filter.setValue(slider.value, forKey: kCIInputIntensityKey)
        var outputImage = filter.outputImage;
        println(filter)
        //        var newImage = UIImage(CIImage: outputImage)                          //<--removed now using context
        var cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent()) //<--new line with context
        
        var newImage = UIImage(CGImage: cgimg)
        self.imageView.image = newImage
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

