//
//  ViewController.swift
//  URLSession-Combine
//
//  Created by Adam Chin on 11/11/19.
//  Copyright © 2019 Adam Chin. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
  private var cancellable: AnyCancellable?
  
  private var posts: [Post] = [] {
    didSet {
      posts.forEach {
        (print("id: \($0.id) • title: \($0.title)"))
      }
    }
  }
  
  private var cards: [Card] = [] {
    didSet{
      cards.forEach{
        (print("id: \(String(describing: $0.id)) • title: \(String(describing: $0.name))"))
        // describing because attributes are optional
      }
    }
  }
  
  var pst = Pst.self{
    didSet{
        print(pst)
    }
  }
  
  private var jobs: [Position] = [] {
    didSet{
      jobs.forEach {
        (print("id: \($0.id) • title: \($0.title)"))
      }
    }
  }
   
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func tappedURL(_ sender: Any) {
      getData()
  }
  
  @IBAction func tappedCombine(_ sender: Any) {
      getDataWithCombine()
  }
  
  @IBAction func tappedMultipleCombine(_ sender: Any) {
    getMultipleCombine()
  }
  
  @IBAction func tappedChainingHttp(_ sender: Any) {
    getPosts()
  }
  
  @IBAction func tappedPokeCards(_ sender: Any) {
    getPokeCards()
  }
  
  @IBAction func tappedGetJobs(_ sender: Any) {
    
    //https://jobs.github.com/positions.json?search=swift"
    
    getJobs()
  }
  func getJobs() {
    let url = URL(string: "https://jobs.github.com/positions.json?search=Swift")!
    self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
     .map { $0.data }
     .decode(type: [Position].self, decoder: JSONDecoder())
     .replaceError(with: [])
     .eraseToAnyPublisher()
     .assign(to: \.jobs, on: self)
   }
   
  
  func getPosts(){
    let url1 = URL(string: "https://jsonplaceholder.typicode.com/posts")!

       self.cancellable = URLSession.shared.dataTaskPublisher(for: url1)
       .map { $0.data }
       .decode(type: [Post].self, decoder: JSONDecoder())
       .tryMap { posts in
           guard let id = posts.first?.id else {
               throw HTTPError.post
           }
           return id
       }
        //////////////////////////////////////
        // flat map is like a sql join :)  //
       .flatMap { id in
           return self.getDetails(for: id)
       }
       .sink(receiveCompletion: { completion in

       }) { post in
        print("id: \(post.id) title: \(post.title) body: \(post.body)")
       }
  }
  

  func getDetails(for id: Int) -> AnyPublisher<Post, Error> {
      let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
      return URLSession.shared.dataTaskPublisher(for: url)
          .mapError { $0 as Error }
          .map { $0.data }
          .decode(type: Post.self, decoder: JSONDecoder())
          .eraseToAnyPublisher()
  }
  
  // No more let group = DispatchGroup(), group.enter(), and defer{group.leave()} !!!!
  func getMultipleCombine() {
    
    let url1 = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    let url2 = URL(string: "https://jsonplaceholder.typicode.com/todos")!

    let publisher1 = URLSession.shared.dataTaskPublisher(for: url1)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())

    let publisher2 = URLSession.shared.dataTaskPublisher(for: url2)
    .map { $0.data }
    .decode(type: [Todo].self, decoder: JSONDecoder())

    self.cancellable = Publishers.Zip(publisher1, publisher2)
    .eraseToAnyPublisher()
    .catch { _ in
        Just(([], []))
    }
    .sink(receiveValue: { posts, todos in
      posts.forEach {
        (print("post id: \($0.id) • title: \($0.title)"))
      }
      todos.forEach {
        (print("todo id \($0.id) • title: \($0.title) • completed: \($0.completed)"))
      }
    })
  }
  
  func getPokeCards() {
    if #available(iOS 13.0, *) {
      let url = URL(string: "https://my-json-server.typicode.com/cjazz/jbucket/cards/")!
         self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
           .map { $0.data }
           .decode(type: [Card].self, decoder: JSONDecoder())
           .replaceError(with: [])
           .eraseToAnyPublisher()
           .assign(to: \.cards, on: self)
      
    } else {
      let jsonUrlString = "https://my-json-server.typicode.com/cjazz/jbucket/cards/"
           guard let url = URL(string: jsonUrlString) else {return}
           URLSession.shared.dataTask(with: url) { (data , response, err) in
             guard let data = data else {return}
             do {
               let cards = try JSONDecoder().decode([Card].self, from: data)
               print(cards)
       
             } catch let jsonErr {
       
               print("json error \(jsonErr)")
             }
           }.resume()
    }
  }
  
  func getDataWithCombine() {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .replaceError(with: [])
    .eraseToAnyPublisher()
    .assign(to: \.posts, on: self)
  }
  
  func getData() {
    // old school JSONSerialization
    let jsonUrlStr = "https://jsonplaceholder.typicode.com/posts/1"
    guard let url = URL(string: jsonUrlStr) else { return }
  
    URLSession.shared.dataTask(with: url) { (data, response, err) in
      
      guard let data = data else { return }
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
        
        let post = Pst(json: json)
        print(post.title, post.id)
        
      } catch let jsonErr {
        print("Ërror serializing", jsonErr)
      }
    }.resume()
  }

}

