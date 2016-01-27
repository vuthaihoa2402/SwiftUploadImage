//
//  ViewController.swift
//  upload
//
//  Created by Admin on 1/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnGet: UIButton!
    @IBOutlet weak var btnImg2: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    var selectImg1 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTouchDown(sender: AnyObject) {
        selectImg1 = true
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnTouchDown2(sender: AnyObject) {
        selectImg1 = false
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if(selectImg1 == true){
            imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else {
            imgView2.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onUploadTapped(sender: AnyObject) {
        btnUpload.enabled = false
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.txtView.text = ""
            self.myImageUploadRequest()
        })
    }
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://thaihoa.somee.com/api/upload");
        //let myUrl = NSURL(string: "http://192.168.1.157:49343/api/upload");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "compare_type"  : "all",
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(imgView.image!, 1)
        let imageData2 = UIImageJPEGRepresentation(imgView2.image!, 1)
        
        if(imageData == nil || imageData2 == nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey1: "firstFile", filePathKey2: "secondFile", imageDataKey: imageData!,imageDataKey2: imageData2!, boundary: boundary)
        
        //myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            self.btnUpload.enabled = true
            
            if (error == nil){
                let s = String(data: data!, encoding: NSUTF8StringEncoding)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.txtView.text = s
                })
            }
        }
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey1: String?, filePathKey2: String?, imageDataKey: NSData, imageDataKey2: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename1 = "firstFile.jpg"
        let filename2 = "secondFile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey1!)\"; filename=\"\(filename1)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey2!)\"; filename=\"\(filename2)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey2)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}