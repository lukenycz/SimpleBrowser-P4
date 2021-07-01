//
//  ViewController.swift
//  SimpleBrowser-P4
//
//  Created by Łukasz Nycz on 01/07/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView:WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.apple.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }


}

