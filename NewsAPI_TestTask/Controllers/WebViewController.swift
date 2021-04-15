//
//  WebViewController.swift
//  NewsAPI_TestTask
//
//  Created by TarasPeregrinus on 13.04.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    //MARK: - Properties
    
    var webView: WKWebView!
    var articleURL = "https://www.hackingwithswift.com"
    
    //MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: articleURL)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}
