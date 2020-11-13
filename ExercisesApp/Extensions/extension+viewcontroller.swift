//
//  extension+viewcontroller.swift
//  ScheduleApp
//
//  Created by developer on 7/25/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {

    func showHUD(){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
        }
    }
    
  
    func dismissHUD(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func showErrorAlert(){
        
        let alert = UIAlertController(title: "Error", message: "Camera can't be used.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return  UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showConfirmAlert(_ title: String, msg: String, completion: @escaping (_ ok: Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            completion(false)
        }))
        self.present(alert, animated: true)
    }
    
    func showFailureAlert() {
        
        let alert = UIAlertController(title: "Warning", message: "The connection failed. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
    
    func calculateAge(dob : String, format:String = "MM/dd/yyyy") -> Int{
            let df = DateFormatter()
            df.dateFormat = format
            let date = df.date(from: dob)
            guard let val = date else{
                return 0
            }
            var years = 0
            var months = 0
            var days = 0
            
            let cal = Calendar.current
            years = cal.component(.year, from: Date()) -  cal.component(.year, from: val)
            
            let currMonth = cal.component(.month, from: Date())
            let birthMonth = cal.component(.month, from: val)
            
            //get difference between current month and birthMonth
            months = currMonth - birthMonth
            //if month difference is in negative then reduce years by one and calculate the number of months.
            if months < 0
            {
                years = years - 1
                months = 12 - birthMonth + currMonth
                if cal.component(.day, from: Date()) < cal.component(.day, from: val){
                    months = months - 1
                }
            } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: val)
            {
                years = years - 1
                months = 11
            }
            
            //Calculate the days
            if cal.component(.day, from: Date()) > cal.component(.day, from: val){
                days = cal.component(.day, from: Date()) - cal.component(.day, from: val)
            }
            else if cal.component(.day, from: Date()) < cal.component(.day, from: val)
            {
                _ = cal.component(.day, from: Date())
                _ = cal.date(byAdding: .month, value: -1, to: Date())
                
//                days = date!.day - cal.component(.day, from: val) + today
            } else
            {
                days = 0
                if months == 12
                {
                    years = years + 1
                    months = 0
                }
            }
            
            return years
        }
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

extension UIView {

    func imageSnapshot() -> UIImage {
        return self.imageSnapshotCroppedToFrame(frame: nil)
    }

    func imageSnapshotCroppedToFrame(frame: CGRect?) -> UIImage {
        let scaleFactor = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scaleFactor)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        if let frame = frame {
            // UIImages are measured in points, but CGImages are measured in pixels
            let scaledRect = frame.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))

            if let imageRef = image.cgImage!.cropping(to: scaledRect) {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
    }
}

extension Locale
{
   var measurementSystem : String?
   {
    return (self as NSLocale).object(forKey: NSLocale.Key.measurementSystem) as? String
   }
}
