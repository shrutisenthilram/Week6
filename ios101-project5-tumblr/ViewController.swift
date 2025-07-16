//
//  ViewController.swift
//  ios101-project5-tumbler
//
import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 120
        
        fetchPosts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Could not dequeue PostTableViewCell")
        }

        let post = posts[indexPath.row]
        cell.summaryLabel.text = post.summary

      
        return cell
    }

    func fetchPosts() {
        let apiKey = "YOUR_API_KEY" // Replace with your Tumblr API key
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                DispatchQueue.main.async {
                    self?.posts = blog.response.posts
                    self?.tableView.reloadData()
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}
