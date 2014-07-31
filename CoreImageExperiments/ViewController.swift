//
//  ViewController.swift
//  CoreImageExperiments
//
//  Created by CraigGrummitt on 31/07/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//
//http://www.raywenderlich.com/22167/beginning-core-image-in-ios-6


import UIKit
import AssetsLibrary

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                            
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderChanged(sender: AnyObject) {
        filterImage()
    }
    @IBAction func loadPhoto(sender: AnyObject) {
        var pickerC = UIImagePickerController()
        pickerC.delegate=self;
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    var context:CIContext = CIContext(options: nil)
    var filter:CIFilter = CIFilter(name:"CISepiaTone")
    var beginImage = CIImage(image:UIImage(named: "flowers"))
    var orientation:UIImageOrientation?
    
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
        var newImage:UIImage
        if let imgOrientation=orientation {
            newImage = UIImage(CGImage: cgimg, scale: 1.0, orientation: imgOrientation)
        } else {
            newImage = UIImage(CGImage: cgimg)
        }

        self.imageView.image = newImage
    }
    @IBAction func savePhoto(sender: AnyObject) {
        var saveToSave = filter.outputImage

        var softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        var cgImg = softwareContext.createCGImage(saveToSave, fromRect: saveToSave.extent())
        var library = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(cgImg, metadata: saveToSave.properties(), completionBlock: nil)
    }
    //------------------------------------------
    //UIImagePickerController
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        var gotImage:UIImage = info[UIImagePickerControllerOriginalImage]! as UIImage
        orientation = gotImage.imageOrientation
        beginImage = CIImage(CGImage: gotImage.CGImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filterImage()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

