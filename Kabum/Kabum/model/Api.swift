//
//  Api.swift
//  Kabum
//
//  Created by Elis Nunes on 11/08/22.
//

import Foundation
import UIKit

class API: NSObject
{

    // coloquei os dados da api no meu servidor pois não sei por qual motivo a api da kabum está retornando 403 quando carregada aqui no swift
    //public let urlApi = "https://servicespub.prod.api.aws.grupokabum.com.br/home/v1"
    public let urlApi = "https://unitzap.com/kabum/home/v1"
    
    func produtos(pagina paginaInt:Int, completion: @escaping (AnyObject) -> ())
    {
        let session = URLSession.shared

        let todoEndpoint: String = urlApi + "/home/produto?app=1&limite=10&pagina=\(paginaInt)"
        guard let url = URL(string: todoEndpoint) else {
          print("Error: cannot create URL")
          return
        }

        var urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 15.0)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest)
        {(data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }

            //let str = String(decoding: data!, as: UTF8.self)
            //print(str);//teste ver html
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            completion(json as AnyObject);
        }
        task.resume()
    }
    
}
