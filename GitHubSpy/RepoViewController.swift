/**
 * @name            RepoViewController.swift
 * @partof          GitHubSpy
 * @description
 * @author	 		Vasco Mouta
 * @created			17/12/15
 *
 * Copyright (c) 2015 zucred AG All rights reserved.
 * This material, including documentation and any related
 * computer programs, is protected by copyright controlled by
 * zucred AG. All rights are reserved. Copying,
 * including reproducing, storing, adapting or translating, any
 * or all of this material requires the prior written consent of
 * zucred AG. This material also contains confidential
 * information which may not be disclosed to others without the
 * prior written consent of zucred AG.
 */

import UIKit

class RepoViewController: UITableViewController {
    
    static let GitHubImageFork = "Fork"
    static let GitHubImageRepository = "Repository"
    
    static let GitHubRepoFork = "fork"
    static let GitHubRepoName = "full_name"
    static let GitHubRepoCreated = "created_at"
    static let GitHubRepoDescription = "description"
    
    var repos: NSArray?
    
    @IBAction func refresh(sender: AnyObject) {
        fetchData()
    }
    
    func fetchData() {
        var url: NSURL
        let parent: ViewController? = self.navigationController?.viewControllers[0] as? ViewController
        if let parentUrl = parent?.url {
            url = parentUrl
        } else {
            url = NSURL(string:"https://api.github.com/users/mralexgray/repos")!
        }
        
        let urlSession = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        print("Fetch repos. Url: \(url)")
        
        /* Lets keep the option of downloading to a temporary file for the moment as comments
        let  task  =  urlSession.downloadTaskWithRequest(request)   {(request,  response,  error)  in
            guard (error == nil) else {
                print("Upsss!!! Went wrong")
                return
            }
            if let data = NSData(contentsOfURL:url) {
                self.repos = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray
                print(self.repos)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }
        }
        task.resume()
        */
        
        let  task  =  urlSession.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
            guard let data = data where error == nil else {
                print("\nerror on download \(error)")
                return
            }
            
            self.repos = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            print(self.repos)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        })
        task.resume()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.beginRefreshing()
        self.tableView.contentOffset = CGPointMake(0, -(self.refreshControl?.frame.size.height ?? 0));
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: We know the cell exist "!" but some add some protection would look nicer
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("RepoViewCell")!

        if let repo: NSDictionary = self.repos?[indexPath.row] as? NSDictionary {
            /// Cell Configuration
            cell.textLabel?.text = repo.valueForKey(RepoViewController.GitHubRepoName) as? String
            var details: String? = repo.valueForKey(RepoViewController.GitHubRepoCreated) as? String
            let description: String? = repo.valueForKey(RepoViewController.GitHubRepoDescription) as? String
            if description?.isEmpty == false {
                details? += " - " + description!
            }
            cell.detailTextLabel?.text = details
            let isFork : Bool? = repo.valueForKey(RepoViewController.GitHubRepoFork) as? Bool
            if isFork?.boolValue == true {
                cell.imageView?.image = UIImage(named: RepoViewController.GitHubImageFork)
            } else {
                cell.imageView?.image = UIImage(named: RepoViewController.GitHubImageRepository)
            }
        } else {
            print("Something went wrong")
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}


class RepoViewCell: UITableViewCell {
    
    
}