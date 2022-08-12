//
//  Produto.swift
//  Kabum
//
//  Created by Elis Nunes on 12/08/22.
//

import Foundation

struct Produto
{
    var fabricante : String!
    var nome : String!
    var foto : String!
    var valor : String!
    var valor10x : String!
    
    init(dictionary: [AnyHashable: Any]) {
        let fabricanteJson = dictionary["fabricante"] as! [AnyHashable: Any]
        self.fabricante = fabricanteJson["nome"] as? String ?? ""
        self.nome = dictionary["nome"] as? String ?? ""
        self.foto = dictionary["img"] as? String ?? ""
        self.valor = dictionary["preco_desconto_formatado"] as? String ?? ""
        self.valor10x = dictionary["preco_formatado"] as? String ?? ""
        self.valor10x += " em até 10x"
    }

}
