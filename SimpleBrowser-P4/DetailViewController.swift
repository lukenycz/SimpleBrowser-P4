//
//  DetailViewController.swift
//  SimpleBrowser-P4
//
//  Created by Łukasz Nycz on 01/07/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView:WKWebView!
    var progressView: UIProgressView!
    var websites = ["google.com", "demotywatory.pl", "kwejk.pl", "hackingwithswift.com", "facebook.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        

        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(forwardTapped))
        let backward = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backTapped))
        let backToTable = UIBarButtonItem(title: "Back to Table", style: .plain, target: self, action: #selector(backToTableTapped))
        
        navigationItem.leftBarButtonItems = [backToTable, backward, forward]
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func backToTableTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func backTapped() {
        webView.goBack()
    }
    @objc func forwardTapped() {
        webView.goForward()
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle)  else { return }
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    func configureAlert() {
        let ac = UIAlertController(title: "Page Blocked!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        if webView.isLoading == false {
            present(ac, animated: true)
            return
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        configureAlert()
        decisionHandler(.cancel)
        
    }
}
