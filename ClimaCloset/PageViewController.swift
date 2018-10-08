//
//  PageViewController.swift
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dataSource = self
        //If let to check if firstViewController is not nil to use it.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward, animated: true, completion: nil)
        }
        
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
        
        return orderedViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //Guard = some kind of if statement.
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
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
        
        return orderedViewControllers[nextIndex]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
