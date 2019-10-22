//
//  ViewController.swift
//  MobXTestProject
//
//  Created by Артем Григорян on 19.10.2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import WebKit

// enum, который содержит адреса веб-сайтов.
enum Sites {
    case faberlic
    
    func stringDescription() -> String {
         switch self {
            case .faberlic: return "https://new.faberlic.com"
         }
     }
}

class ViewController: UIViewController, WKUIDelegate, UIApplicationDelegate, WKNavigationDelegate {

    // Вьюшка, на которой будет лежать webView (она желтая в Storyboard).
    @IBOutlet private weak var webViewContainer: UIView!
    // Собственно, сама webView.
    private var webView: WKWebView!
    // Названия картинок.
    private let images = ["profile", "menu", "faberlic", "book", "littleFaberlic", "cart", "left-arrow"]
    
    // Во viewDidLoad будем производить инициализацию webView (отрисуем её, добавим в нее пользовательские сценарии), и затем загрузим в нее веб-сайт.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
        configurateWebView()
        loadWebPage()
    }
    
    // Этот метод проинициализирует объект webView пользователскими сценариями.
    private func initWebView() {
        guard let config = injectUserScripts() else { return }
        
        webView = WKWebView(frame: .zero, configuration: config)
    }
    
    // Этот метод отрисует webView на экране, расставит констрейнты.
    private func configurateWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
    }
    
    // Этот метод создаст URLRequest, который примет метод load объекта класса WKWebView (у меня этот объект называется webView).
    private func createURLRequest() -> URLRequest? {
        let path = Sites.faberlic.stringDescription()
        guard let url = URL(string: path) else { return nil }
        let request = URLRequest(url: url)
        
        return request
    }
    
    // В этом методе мы получаем нужный URLRequest для запуска главной страницы Фаберлик.
    private func loadWebPage() {
        guard let request = createURLRequest() else { return }
       
        webView.load(request)
    }
    
    // В этом методе будет происходить подгрузка "пользовательских сценариев" (js, css).
    private func injectUserScripts() -> WKWebViewConfiguration? {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // Подгрузим скрипт с кодом js.
        guard let scriptURL = Bundle.main.path(forResource: "scripts", ofType: "js") else { return nil }
        let scriptContent = try! String(contentsOfFile: scriptURL, encoding: String.Encoding.utf8)
        let script = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        // Подгрузим css файл.
        guard let mycss = Bundle.main.path(forResource: "mycss", ofType: "css") else { return nil }
        let cssString = try! String(contentsOfFile: mycss).components(separatedBy: .newlines).joined()
        
        // Напишем js код, который внедрит подгруженный выше css файл в html-страницу.
        let source = """
            var style = document.createElement('style');
            style.innerHTML = '\(cssString)';
            document.head.appendChild(style);
        """

        // Создадим WKUserScript, который содержит в себе выше созданный js код.
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        // Вставим "пользовательские сценарии" в объект класса WKWebViewConfiguration, который потом съинектит их в веб-страницу.
        contentController.addUserScript(userScript)
        contentController.addUserScript(script)
        
        // Перебираем все изображения, чтобы вставить их с помощью js-кода по соответствующим id в html-коде (см. scripts.js).
        for img in images {
            if let image = UIImage(named: img) {
                let data = image.pngData()
                // Раньше все кодировалось в ютф-8. Для изображений нужно base64.
                let base64 = data!.base64EncodedString(options: [])
                let urlImg = "data:application/png;base64," + base64
                // Вот тут вставляем их с javascript в соответствующие id. У них одинаковые названия.
                let source2 = """
                    var a = document.getElementById('\(img)');
                    a.src = '\(urlImg)';
                """
                
                let userScript2 = WKUserScript(source: source2, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                contentController.addUserScript(userScript2)
            }
        }
        
        // Объект конфигурации webView будет содержать выше описанный контроллер.
        config.userContentController = contentController

        return config
    }
}

