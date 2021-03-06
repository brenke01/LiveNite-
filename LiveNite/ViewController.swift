//
//  ViewController.swift
//  VideoRecord1
//
//  Created by Raj Bala on 9/17/14.
//  Copyright (c) 2014 Raj Bala. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import CoreData

var appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
var context:NSManagedObjectContext = appDel.managedObjectContext!
var upVoteInc : CGFloat = 5
var imageUpvotes = UILabel(frame: CGRectMake(150, upVoteInc, 30, 25))
var idInc : Int = 1









class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet
    var tableView : UITableView!
    
    @IBOutlet var collectionView: UICollectionView?
    
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 5)
        layout.itemSize = CGSize(width: 120, height: 160)
        //collectionView = UICollectionView(fr, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView!.delegate = self
        print("cell")
        
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        let nibname = UINib(nibName: "Cell", bundle: nil)
        collectionView!.registerNib(nibname, forCellWithReuseIdentifier: "Cell")
        collectionView!.registerClass(NSClassFromString("GalleryCell"),forCellWithReuseIdentifier:"CELL");

        //collectionView!.backgroundColor = UIColor(red: 42/255, green: 34/255, blue: 34/255, alpha: 1)
        self.view.addSubview(collectionView!)
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        return locations!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.yellowColor()
        
        
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        cell.backgroundColor = UIColor.blackColor()
        
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        var idArray : [Int] = []
        var imageArray : [UIImage] = []
        
        var upVoteArray : [Int] = []
        if let locations = locations{
            for loc in locations{
                
                let imageData: AnyObject? = loc.valueForKey("videoData")
                let imgData = UIImage(data: (imageData as? NSData)!)
                imageArray.append(imgData!)
                let idData : AnyObject? = loc.valueForKey("id")
                let imageId = idData as? Int
                idArray.append(imageId!)
                let upVoteData : AnyObject? = loc.valueForKey("upvotes")
                let upVotes = upVoteData as? Int
                upVoteArray.append(upVotes!)
                
                
                
                
                
            }
        }
        let imageContainer = UIImageView(frame: CGRectMake(0, 0, 120, 160))
        imageContainer.image = imageArray[indexPath.row]
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("viewPost:"))
        imageContainer.userInteractionEnabled = true
        imageContainer.addGestureRecognizer(tapGestureRecognizer)
        
        let layer = imageContainer.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 20)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        cell.addSubview(imageContainer)
        print("cell")
        return cell
    }
    
    func viewPost(img: AnyObject){
        let imageContainer = UIImageView(frame: CGRectMake(0, 0, 220, 260))
        print("test")
        var tapLocation = img.locationInView(self.collectionView)
        var indexPath : NSIndexPath = (self.collectionView?.indexPathForItemAtPoint(tapLocation)!)!
        var image = UIImage()
       
        if let cell = self.collectionView?.cellForItemAtIndexPath(indexPath){
            print(cell.subviews)
            var imageView = cell.subviews[1] as! UIImageView
            image = imageView.image!
        }
        var imageCon = UIImageView()
        imageContainer.image = image
        self.view.addSubview(imageContainer)
    }

    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        return locations!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        let label = UILabel(frame: CGRectMake(15, 5, 250, 50))
        
        var i = 0
        
        label.text = "Fun at Blarneys"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        let commitLabel = UILabel(frame: CGRectMake(15, 440, 105, 30))
        commitLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        commitLabel.text = " I'M GOING"
        commitLabel.backgroundColor = UIColor.yellowColor()
        commitLabel.textColor = UIColor.blackColor()
        let upVotebutton : UIButton = UIButton(frame: CGRectMake(220, 440, 40, 40))
        let downVoteButton = UIButton(frame: CGRectMake(260, 440, 40, 40))
        
        let upVoteImage = UIImage(named: "UpVote")
       
        upVotebutton.setBackgroundImage(upVoteImage, forState: UIControlState.Normal)
        //upVotebutton.backgroundColor = UIColor.yellowColor()
        
        let downVoteImage = UIImage(named: "DownVote")
        
        downVoteButton.setBackgroundImage(downVoteImage, forState: UIControlState.Normal)
        downVoteButton.addTarget(self, action: "DownVote:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        upVotebutton.addTarget(self, action: "UpVote:", forControlEvents: UIControlEvents.TouchUpInside)
        label.textColor = UIColor.whiteColor()
        self.tableView.rowHeight = 480
        //let cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        

       
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        //cell.backgroundColor = UIColor.blackColor()
        
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        var idArray : [Int] = []
        var imageArray : [UIImage] = []
        
        var upVoteArray : [Int] = []
        if let locations = locations{
            for loc in locations{
                
                let imageData: AnyObject? = loc.valueForKey("videoData")
                let imgData = UIImage(data: (imageData as? NSData)!)
                imageArray.append(imgData!)
                let idData : AnyObject? = loc.valueForKey("id")
                let imageId = idData as? Int
                idArray.append(imageId!)
                let upVoteData : AnyObject? = loc.valueForKey("upvotes")
                let upVotes = upVoteData as? Int
                upVoteArray.append(upVotes!)
                
                
                
                
                
            }
        }
       
        

        upVotebutton.tag = idArray[indexPath.row]
        downVoteButton.tag = idArray[indexPath.row]
        if cell.viewWithTag(100) == nil{
            
            let upVoteLabel = UILabel(frame: CGRectMake(15, 400, 50, 50))
            upVoteLabel.textColor = UIColor.whiteColor()
            upVoteLabel.text = "\(upVoteArray[indexPath.row])"
            upVoteLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
            upVoteLabel.tag = 100
            cell.addSubview(upVoteLabel)
            
            
        }else{
            let upVoteLabel = cell.viewWithTag(100) as! UILabel
            print(upVoteArray[indexPath.row], terminator: "")
            upVoteLabel.text = "\(upVoteArray[indexPath.row])"
            cell.addSubview(upVoteLabel)
            
        }
        cell.addSubview(commitLabel)
        cell.addSubview(label)
        cell.addSubview(upVotebutton)
        cell.addSubview(downVoteButton)
        let imageContainer = UIImageView(frame: CGRectMake(0, 50, 320, 350))
        imageContainer.image = imageArray[indexPath.row]
        cell.addSubview(imageContainer)

        
       return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        //selectedCell?.contentView.backgroundColor = UIColor.blackColor()
        print("selected", terminator: "")
        var imageDetails = UIView(frame: CGRectMake(0, 0, 325, 600))
        let fetchRequest = NSFetchRequest(entityName: "Entity")

        
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        var idArray : [Int] = []
        var imageArray : [UIImage] = []
        
        var upVoteArray : [Int] = []
        if let locations = locations{
            for loc in locations{
                
                let imageData: AnyObject? = loc.valueForKey("videoData")
                let imgData = UIImage(data: (imageData as? NSData)!)
                imageArray.append(imgData!)
                let idData : AnyObject? = loc.valueForKey("id")
                let imageId = idData as? Int
                idArray.append(imageId!)
                let upVoteData : AnyObject? = loc.valueForKey("upvotes")
                let upVotes = upVoteData as? Int
                upVoteArray.append(upVotes!)
                
                
                
                
                
            }
        }
        
        
    }*/
    
    @IBAction func capVideo() {
        
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            //imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            print("Camera not available.")
        }
    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject]) {
        
        
        if let newVideo = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext:context) as? NSManagedObject{
            let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
            let dataImage:NSData = UIImageJPEGRepresentation(tempImage, 0.0)!
            newVideo.setValue(dataImage, forKey: "videoData")
            var date = NSDate()
            var calendar = NSCalendar.currentCalendar()
            var components = calendar.components([.Hour, .Minute], fromDate: date)
            var hourOfDate = components.hour
            newVideo.setValue(hourOfDate, forKey: "time")
            var setImageTitle : String = "Fun at Blarneys"
            var setUpVotes : Int = 0
            var setId : Int = getImageId()
            print(setId, terminator: "")
            newVideo.setValue(setId, forKey: "id")
            newVideo.setValue(setUpVotes, forKey: "upvotes")
            newVideo.setValue(setImageTitle, forKey: "title")
            do {
                try context.save()
            } catch _ {
            }
            print("saved successfully", terminator: "")
            
            dismissViewControllerAnimated(true, completion: nil)
            self.tableView.reloadData()
            
            
            
        }
        
        
        
    }

    //Reconstruct to use tableView
    func loadImageFeed(){
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        var count : CGFloat = 70
        var imageCount : CGFloat = 30
        let containerCount : CGFloat = 300
        
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        let multiplier : Int = locations!.count

        let imageContainer = UIView(frame: CGRectMake(5, 50, 300, containerCount * CGFloat(multiplier)))
        if let locations = locations{
            for loc in locations{
                print("test", terminator: "")
                let imageData: AnyObject? = loc.valueForKey("videoData")
                let imageText : AnyObject? = loc.valueForKey("title")
                var upVoteCount : AnyObject? = loc.valueForKey("upvotes")
                let imageId : AnyObject? = loc.valueForKey("id")
                let imgData = UIImage(data: (imageData as? NSData)!)
                var img : UIImageView
                let imageviewObj = UIImageView(frame: CGRectMake(5, imageCount, 300, 250))
                imageviewObj.image = imgData
                
                
                let imageTitle : UILabel = UILabel(frame: CGRectMake(5,upVoteInc, 150, 25))
                
                imageUpvotes = UILabel(frame: CGRectMake(150, upVoteInc, 30, 25))
                imageUpvotes.textColor = UIColor.blackColor()
                let upVotebutton : UIButton = UIButton(frame: CGRectMake(250,upVoteInc, 70, 25))
                upVoteCount = upVoteCount as? Int
                imageUpvotes.text = "\(upVoteCount!)"
                upVotebutton.setTitle("^", forState: UIControlState.Normal)
                
                //var upVoteLabel: UILabel = UILabel(frame: CGRectMake(180, containerCount, 20, 25))
                upVotebutton.addTarget(self, action: "UpVote:", forControlEvents: UIControlEvents.TouchUpInside)
                let id = imageId as! Int
                upVotebutton.tag = id
                upVotebutton.backgroundColor = UIColor.blackColor()
                
                //upVoteLabel.text = upVoteCount as? String
                //upVoteLabel.textColor = UIColor.whiteColor()
                //imageTitle.addSubview(upVoteLabel)
                
                imageTitle.textColor = UIColor.blackColor()
                imageTitle.text = imageText as? String
                imageContainer.addSubview(imageviewObj)
                
                
                imageContainer.sendSubviewToBack(imageUpvotes)
                imageContainer.addSubview(imageTitle)
                
                imageContainer.addSubview(upVotebutton)
                imageContainer.addSubview(imageUpvotes)
                
                imageContainer.backgroundColor = UIColor.yellowColor()
                
                
                scroller.contentSize = imageContainer.bounds.size
                
                scroller.addSubview(imageContainer)
                scroller.sendSubviewToBack(imageContainer)
                
                
                
                count = count + 300
                
                imageCount += 300
                upVoteInc += 300
                
                
                
            }
            
        }
        
        self.view.addSubview(scroller)
        

        
    }
    
    func UpVote(sender: UIButton){
        print(sender.tag, terminator: "")
        let id = 0
        let disableMyButton = sender as UIButton
        disableMyButton.enabled = false
        let disableUpVoteImage = UIImage(named: "UpVoted")
        disableMyButton.setBackgroundImage(disableUpVoteImage, forState: UIControlState.Normal)
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id = %i", sender.tag)
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        if let locations = locations{
            
            for loc in locations{
                let idData : AnyObject? = loc.valueForKey("id")
                let id = idData as! Int
                print(id, terminator: "")
                let upvoteData : AnyObject? = loc.valueForKey("upvotes")
                var upvote = upvoteData as! Int
                upvote = upvote + 1
                
                loc.setValue(upvote, forKey: "upvotes")
                do {
                    try context.save()
                } catch _ {
                }
                
                
                
            }
            
            
            
            
            
            
        }
        userUpvoted(id)
        self.tableView.reloadData()
        
    }
    
    func userUpvoted(id : Int){
        
    }
    func DownVote(sender: UIButton){
        print(sender.tag, terminator: "")
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id = %i", sender.tag)
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        if let locations = locations{
            
            for loc in locations{
                
                let idData : AnyObject? = loc.valueForKey("id")
                let id = idData as! Int
                print(id, terminator: "")
                let upvoteData : AnyObject? = loc.valueForKey("upvotes")
                var upvote = upvoteData as! Int
                upvote = upvote - 1
                loc.setValue(upvote, forKey: "upvotes")
                do {
                    try context.save()
                } catch _ {
                }
                
                
                
            }
            
            
            
            
            
            
        }
       
        self.tableView.reloadData()
        
    }
    
    func getImageId()-> Int{
        var currentID = 1
        let fetchRequest = NSFetchRequest(entityName: "CurrentID")
        let locations = (try? context.executeFetchRequest(fetchRequest)) as! [NSManagedObject]?
        if let locations = locations{
            for loc in locations{
                let idData : AnyObject? = loc.valueForKey("id")
                if (idData == nil){
                    currentID = 1
                }else{
                    currentID = (idData as? Int)!
                }

                

            }}
        if let newId = NSEntityDescription.insertNewObjectForEntityForName("CurrentID", inManagedObjectContext:context) as? NSManagedObject{
            currentID = currentID + 1
            newId.setValue(currentID, forKey: "id")
            do {
                try context.save()
            } catch _ {
            }
        }
        
        return currentID
    }


}

