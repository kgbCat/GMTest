//
//  CustomMarker.swift
//  GMTest
//
//  Created by Anna Delova on 3/13/22.
//

import UIKit

class CustomMarker {

    //MARK: Custom Marker
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {

        let imgView = UIImageView(image: image)
        imgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        picImgView.setNeedsLayout()

        imgView.addSubview(picImgView)

        imgView.setNeedsLayout()

        let newImage = imageWithView(view: imgView)
        return newImage
    }

    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
}
