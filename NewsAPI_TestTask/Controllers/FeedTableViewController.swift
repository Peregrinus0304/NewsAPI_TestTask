//
//  FeedTableViewController.swift
//  NewsAPI_TestTask
//
//  Created by TarasPeregrinus on 12.04.2021.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    
    var news = News()
    var params = Params()
    var searching = false
    private var fetchedNews:[News.Articles] = []
    private var filteredNews:[News.Articles] = []
    
    var picker: UIPickerView!
    var toolbar: UIToolbar!
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilter()
        picker.delegate = self
        picker.dataSource = self
        updateData()
    }
    
    // getting data from News API, sorting it and saving to collection
    func updateData() {
        news.getData{
            DispatchQueue.main.async {
                self.fetchedNews.append(contentsOf: self.news.result!.articles.sorted(by: {
                self.getDate($0.publishedAt) < self.getDate($1.publishedAt)}))
                self.tableView.reloadData()
            }
        }
    }
    
    // set up picker and toolbar for filtering
    func setupFilter() {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        picker.backgroundColor = .yellow
        picker.tintColor = .yellow
        picker.layer.cornerRadius = 10
        picker.layer.borderWidth = 2
        
        view.addSubview(picker)
        
        let doneButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(donePressed(sender:)))
        let cancelButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelPressed(sender:)))
        
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 40))
        toolbar.backgroundColor = .yellow
        toolbar.tintColor = .cyan
        toolbar.layer.cornerRadius = 10
        toolbar.layer.borderWidth = 2
        
        toolbar.setItems([doneButtonItem, cancelButtonItem], animated: true)
        
        view.addSubview(toolbar)
       
        toolbar.isHidden = true
        picker.isHidden = true
        
    }
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    // show filter
    @IBAction func filter(_ sender: Any) {
        picker.isHidden = false
        toolbar.isHidden = false
    }
    
    // hide filter, fetch new data with selected params
    @objc func donePressed(sender: UIBarButtonItem) {
        fetchedNews = []
        updateData()
        picker.isHidden = true
        toolbar.isHidden = true
    }
    
    // hide filter
    @objc func cancelPressed(sender: UIBarButtonItem) {
        picker.isHidden = true
        toolbar.isHidden = true
    }
    
}

// MARK: - UIPickerView protocols

extension FeedTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
            case 0:
                return params.country.count
            case 1:
                return params.category.count
            default:
                return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
                news.country = params.country[row]
            case 1:
                news.category = params.category[row]
            default:
                return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 45))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 45))
        
        switch component {
            case 0:
                label.text = params.country[row]
            default:
                label.text = params.category[row]
        }
        
        label.textColor = .cyan
        label.font = UIFont(name: "AmericanTypewriter", size: 28)
        label.textAlignment = .center
        label.minimumScaleFactor = 10/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        return view
    }
    
}

// MARK: - UITableView protocols

extension FeedTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredNews.count ?? 0
        } else {
            return fetchedNews.count ?? 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        var articles = fetchedNews[indexPath.row]
        
        if searching {
            articles = filteredNews[indexPath.row]
        } else {
            articles = fetchedNews[indexPath.row]
        }
        
        // updating the cell with fetched data
        cell.newsTitleLabel.text = articles.title
        cell.newsAuthorLabel.text = articles.author
        cell.newsDescriptionTextView.text = articles.description
        cell.newsSourceLabel.text = articles.source.name
        
        let articleImageURL = URL(string: articles.urlToImage ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.islandpacket.com%2F&psig=AOvVaw1uUxV67BUqInuSqRChYv64&ust=1608243550759000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKjP16fE0-0CFQAAAAAdAAAAABAJ")!
        if let data = try? Data(contentsOf: articleImageURL) {
            cell.newsImageView.image = UIImage(data: data)
        } else {
            //   cell.newsImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var data = fetchedNews[indexPath.row]
        
        if searching {
            data = filteredNews[indexPath.row]
        } else {
            data = fetchedNews[indexPath.row]
        }
        
        // open article`s url with WKWebView in seperate Controller
        let vc = WebViewController()
        vc.articleURL = data.url ?? "https://pecodesoftware.com"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UISearchView protocols

extension FeedTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        // search searched data for input string and save rhose objects to seperate collection
        filteredNews = fetchedNews.filter({($0.title?.lowercased().starts(with: searchText.lowercased()))!})
        
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        self.view.endEditing(true)
        print("cancel")
    }
    
}

//MARK: - UIScrollView delegate

extension FeedTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let possition = scrollView.contentOffset.y
        
        if possition > ((tableView?.contentSize.height)!-200-scrollView.frame.height) {
            print("fetch more data")
            
            updateData()
        }
    }
    
}

//MARK: - Extension format date

extension FeedTableViewController {
    
    func getDate(_ ISOString:String?)->Date {
        var result: Date!
        let ISOformatter = ISO8601DateFormatter()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        
        if let unwrappedString = ISOString {
            let date = ISOformatter.date(from: unwrappedString)
            result = date
        }
        return result
    }
    
}
