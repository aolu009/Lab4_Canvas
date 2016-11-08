//
//  ViewController.swift
//  Lab4_Canvas
//
//  Created by Lu Ao on 11/5/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var deadFace: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayEndingCenter: CGPoint! = CGPoint()
    var trayStartingCenter: CGPoint! = CGPoint()
    var imageOriginalCenter: CGPoint! = CGPoint()
    var newlyCreatedFace: UIImageView!
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayEndingCenter? = CGPoint(x: 207, y: 815)
        trayStartingCenter = self.trayView.center
    }

    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        //** Calculate the translation of the pan in the parent's coordinate system.
        let point = panGestureRecognizer.location(in: trayView)
        
        if panGestureRecognizer.state == .began {
            self.trayOriginalCenter = trayView.center
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == .changed {
            
            //trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + panGestureRecognizer.translation(in: trayView).y)
            
            if panGestureRecognizer.velocity(in: trayView).y > 0{
                print("Moving Down")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.trayView.center = self.trayEndingCenter
                }, completion: { (Bool) in
                    
                    print("Success")
                })
                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI / 180))
            }
            else{
                print("Moving Up")
                UIView.animate(withDuration: 0.5, animations: {
                    self.trayView.center = self.trayStartingCenter
                })
                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(360 * M_PI / 180))
            }
            
            print("Gesture changed at: \(point)")
        } else if panGestureRecognizer.state == .ended {
            
        }
        
        
    }
    
    @IBAction func dragToCreateFace(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        if panGestureRecognizer.state == .began {
            let imageView = panGestureRecognizer.view as! UIImageView
            self.imageOriginalCenter = imageView.center
            self.imageOriginalCenter.y += self.trayView.frame.origin.y
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            let doubletapRecognozer = UITapGestureRecognizer.init(target: self, action: #selector(self.onDoubleTap))
            let panrecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.onPan))
            self.pinchRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(self.onPinch))
            self.pinchRecognizer.delegate = self
            doubletapRecognozer.delegate = self
            doubletapRecognozer.numberOfTapsRequired = 2
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(self.pinchRecognizer)
            newlyCreatedFace.addGestureRecognizer(panrecognizer)
            newlyCreatedFace.addGestureRecognizer(doubletapRecognozer)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates
            newlyCreatedFace.center.y += self.trayView.frame.origin.y
            
            //Scale a little as a being selected indicator
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: 2)
            
        } else if panGestureRecognizer.state == .changed {
            newlyCreatedFace.center = CGPoint(x: self.imageOriginalCenter.x + 2*panGestureRecognizer.translation(in: self.newlyCreatedFace).x, y: self.imageOriginalCenter.y + 2*panGestureRecognizer.translation(in: self.newlyCreatedFace).y)
            
        } else if panGestureRecognizer.state == .ended {
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1 , y: 1)
        }
    }
    func onPinch(sender:UIPinchGestureRecognizer){
        
        sender.view?.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        //Allows gesturing on the same stuff over and and over
        sender.view?.addGestureRecognizer(sender)
        print("pinching velocity:\(sender.velocity)")
    }
    func onPan(panRecognizer: UIPanGestureRecognizer){
        print("I can still moving")
        //let originalView = panRecognizer.view
        if panRecognizer.state == .began {
            self.trayOriginalCenter = panRecognizer.view?.center
        } else if panRecognizer.state == .changed {
            
            panRecognizer.view?.center = CGPoint(x: trayOriginalCenter.x + panRecognizer.translation(in: panRecognizer.view).x, y: trayOriginalCenter.y + panRecognizer.translation(in: panRecognizer.view).y)
            
        } else if panRecognizer.state == .ended {
    
        }
    }
    func onDoubleTap(doubleTapRecognizer:UITapGestureRecognizer){
        doubleTapRecognizer.view?.removeFromSuperview()
    }
    
}

