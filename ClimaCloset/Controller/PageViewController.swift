//
//  PageViewController.swift     -         Swiping functionality.
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 08/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedViewControllers : [UIViewController] = {
    return [self.newVC(viewController : "ClimaVC"),
            self.newVC(viewController : "WeatherVC"),
        self.newVC(viewController : "ClosetVC")]
    }()
    
    var myViewControllers = [UIViewController]()
    
    var currentIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.dataSource = self
        
        setViewControllers([orderedViewControllers[1]],
                               direction: .forward, animated: true, completion: nil)
     
        self.delegate = self
        
    
    }
    
    
    func newVC(viewController : String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //Guard = some kind of if statement.
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
       
        
        let previousIndex = viewControllerIndex - 1;
        
        guard previousIndex >= 0 else {
           // return orderedViewControllers.last
            //Return nil to avoid swiping forever.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        currentIndex = previousIndex
        
        //Soluce 2
        if(currentIndex == 0) {
            (orderedViewControllers.first as! ClimaViewController).timeOfDayClima = (orderedViewControllers[1] as! WeatherViewController).timeOfDay
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //Guard = some kind of if statement.
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1;
        
        guard orderedViewControllers.count != nextIndex else {
            //return orderedViewControllers.first
            //Return nil to avoid swiping forever.
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        currentIndex = nextIndex
        
       //Soluce 2
        if(currentIndex == orderedViewControllers.count-1) {
            (orderedViewControllers.last as! ClosetViewController).timeOfDayCloset = (orderedViewControllers[1] as! WeatherViewController).timeOfDay
        }
        
        return orderedViewControllers[nextIndex]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//      //  if( (orderedViewControllers.last as! ClosetViewController).viewAlreadyInitialized == true){
//            (orderedViewControllers.last as! ClosetViewController).updateBackground()
//            print("FIRST UPBG HAPPENS")
//
//        //}
//       // if( (orderedViewControllers.first as! ClimaViewController).viewAlreadyInitialized == true){
//            (orderedViewControllers.first as! ClimaViewController).updateBackground()
//            print("LAST UPBG HAPPENS")
//       // }
//
//        while(ClimaViewController.pressed) {
//            print("PRESSED TRUE IN SECOND. City =  \(ClimaViewController.newCity)")
//            (orderedViewControllers[1] as! WeatherViewController).userEnteredNewCityName(city: ClimaViewController.newCity)
//
//        }
//
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        //Update timeOfDayClima to fix bug of ClimaVC background not updating after pressing "Confirm".
        (orderedViewControllers.first as! ClimaViewController).timeOfDayClima = (orderedViewControllers[1] as! WeatherViewController).timeOfDay
        
        (orderedViewControllers.last as! ClosetViewController).updateBackground()
        print("FIRST UPBG HAPPENS")
        
        //}
        // if( (orderedViewControllers.first as! ClimaViewController).viewAlreadyInitialized == true){
        (orderedViewControllers.first as! ClimaViewController).updateBackground()
        print("LAST UPBG HAPPENS")
        // }
        
        while(ClimaViewController.pressed) {
            
            print("PRESSED TRUE IN SECOND. City =  \(ClimaViewController.newCity)")
            (orderedViewControllers[1] as! WeatherViewController).userEnteredNewCityName(city: ClimaViewController.newCity)
            
        }
    }

    
}

