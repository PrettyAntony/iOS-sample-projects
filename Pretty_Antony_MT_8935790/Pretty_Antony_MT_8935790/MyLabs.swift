//
//  MyLabsViewController.swift
//  Pretty_Antony_MT_8935790
//
//  Created by user234138 on 10/31/23.
//

import UIKit

class MyLabs: UIViewController {
    
    //projects array
    var projects : [String]=["Kribbz","SpotOn","Stadium","TrailCamera","Kithu"]
    
    //project array
    var projectDescriptions : [String]=["My 1st international project:Kribbz is the evolution of real estate. Buy and sell a home instantly from your mobile device.","SpotOn GPS Fence offers dogs and dog owners a reliable and convenient wireless containment system. Simply set the boundary and leave your dog to go about their business.","Encourages clients to watch a match live,along with rewards points for food & beverages. All info related to match and stadium is provided along with food outlets and amenities nearby.","Monitoring the animal visits in the plantation, captures the images and videos, along with live streaming in the mobile phones and helps in hunting","My most favourite and hardest of my projects and an Ongoing one;my daughter Kithu"]
    
    //project images array
    var projectImages = [UIImage(named: "Kribbz"),UIImage(named: "VirtualFence"),UIImage(named: "Stadium"),UIImage(named: "TrailCamera"),UIImage(named: "Kithu")]
    

    @IBOutlet weak var projectImageView: UIImageView!
    
    @IBOutlet weak var projectDescription: UITextView!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet weak var buttonPrevious: UIButton!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var indexCount = 0;
    
    //to change all images, texts on next button clicked
    @IBAction func buttonNextClicked(_ sender: UIButton) {
        
        //checking the count is les than array size
        if(indexCount<self.projects.count){
            
            //updating the index
            indexCount+=1
            
            //assigning the images and text according to the index count
            projectImageView.image = self.projectImages[indexCount]
            projectDescription.text = self.projectDescriptions[indexCount]
            projectNameLabel.text = String("My Notable Projects : "+self.projects[indexCount])
            
            //hiding and showing previous and next buttons
            buttonPrevious.isHidden = false
            if(indexCount==4){
                buttonNext.isHidden = true
            }else{
                buttonNext.isHidden = false
            }
        }
    }
    
    //to change all images, texts on previous button clicked
    @IBAction func buttonPreviousClicked(_ sender: UIButton) {
        
        //checking the count is greater than zero
        if(indexCount>0){
            //updating the index
            indexCount-=1
            
            //assigning the images and text according to the index count
            projectImageView.image = self.projectImages[indexCount]
            projectDescription.text = self.projectDescriptions[indexCount]
            projectNameLabel.text = String("My Notable Projects : "+self.projects[indexCount])
            
            //hiding and showing previous and next buttons
            buttonNext.isHidden = false
            if(indexCount==0){
                buttonPrevious.isHidden = true
            }else {
                buttonPrevious.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
