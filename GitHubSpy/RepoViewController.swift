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
    static let GitHubRepoName = "name"
    static let GitHubRepoCreated = "created_at"
    static let GitHubRepoDescription = "description"
    
    static let GitHubCommitSha = "sha"
    
    var repos: NSArray?
    
    @IBAction func refresh(sender: AnyObject) {
        fetchData()
    }
    
    func fetchData() {
        var url = getParent()?.url
        if url == nil {
            url = NSURL(string:"https://api.github.com/users/mralexgray/repos")!
        }
        
        let urlSession = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        
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

        print("Fetch repos url: \(url)")
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
    
    func getParent() -> ViewController? {
        return self.navigationController?.viewControllers[0] as? ViewController
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
        let cell : RepoViewCell = (tableView.dequeueReusableCellWithIdentifier("RepoViewCell") as! RepoViewCell)
        if let repo: NSDictionary = self.repos?[indexPath.row] as? NSDictionary {
            /// Cell Configuration
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
            
            if let name = repo.valueForKey(RepoViewController.GitHubRepoName) as? String {
                var url = getParent()?.commitsUrl(name)
                if url == nil {
                    print("Something went wrong let use the defaut commits url")
                    url = NSURL(string:"https://api.github.com/repos/mralexgray/ACEView/commits")!
                }
                cell.textLabel?.text = name
                cell.updateCommits(url!)
            }
        } else {
            print("Something went wrong with repos data!")
            cell.textLabel?.text = "No Data"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}

class RepoViewCell: UITableViewCell {
    
    func updateCommits(url: NSURL)
    {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard let data = data where error == nil else {
                print("error on download \(error)")
                return
            }
            
            let commits = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            print(commits)
            if let commit: NSDictionary? = commits?[0] as? NSDictionary {
                if let sha = commit?.valueForKey(RepoViewController.GitHubCommitSha) as? String {
                    self.detailTextLabel?.text? += " sha:" + sha
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                print("download completed \(url)")
                self.layoutSubviews()
            }
        }).resume()
    }
}