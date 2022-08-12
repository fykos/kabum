//
//  InicioTableViewController.swift
//  Kabum
//
//  Created by Elis Nunes on 11/08/22.
//

import Foundation
import UIKit

class InicioTableViewController: UITableViewController
{
    
    var loaderView: UIView!
    
    var carregouInicial: Bool = false
    var carregando: Bool = false
    
    var paginaAtual: Int!

    var produtosArray = [Produto]()
    
    // MARK: - Private functions
    
    func aplicaSombra(view: UIView, opacidade: Float)
    {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacidade
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10.0
        view.layer.cornerRadius = 10.0
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func listaProdutos()
    {
        if (self.carregando)
        {
            return;
        }
        
        self.paginaAtual += 1
        self.carregando = true
        
        self.tableView.reloadData()
        
        API().produtos(pagina: paginaAtual) { (json) in
            DispatchQueue.main.async {
                
                if let data = json as? [String: Any] {
                    
                    self.carregouInicial = true
                    self.carregando = false
                    
                    let array = data["produtos"] as! Array<Any>;
                    for dic in array
                    {
                        guard let dict = dic as? [AnyHashable: Any] else {
                            print("\(dic) erro ao ler os dados")
                            return
                        }
                    
                        self.produtosArray.append(Produto(dictionary: dict))
                    }
                }
                
                self.tableView.reloadData();
                
            }
        };
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 94.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 64.0/255.0, green: 94.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
        
        
        self.paginaAtual = 0;
        
        listaProdutos()
        
        tableView.separatorColor = UIColor.clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
          return .lightContent
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if (self.carregouInicial)
        {
            if (self.carregando)
            {
                return 3
            }
            else
            {
                return 2
            }
        }
        else
        {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 1)
        {
            return self.produtosArray.count
        }
        else
        {
            return 1;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var identifier = "";
        
        if (!self.carregouInicial || indexPath.section == 2)
        {
            identifier = "Carregando Cell";
        }
        else
        {
            if (indexPath.section == 0)
            {
                identifier = "Titulo Cell";
            }
            else
            {
                identifier = "Item Cell";
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (indexPath.section == 1)
        {
         
            let produto = self.produtosArray[indexPath.row]
            
            let fotoImageView: UIImageView = cell.viewWithTag(1) as! UIImageView;
            let fabricanteLabel: UILabel = cell.viewWithTag(2) as! UILabel;
            let nomeLabel: UILabel = cell.viewWithTag(3) as! UILabel;
            let valorLabel: UILabel = cell.viewWithTag(4) as! UILabel;
            let valor10xLabel: UILabel = cell.viewWithTag(5) as! UILabel;
            let activityIndicatorView: UIActivityIndicatorView = cell.viewWithTag(6) as! UIActivityIndicatorView;
            let comprarButton: UIButton = cell.viewWithTag(7) as! UIButton;
            
            activityIndicatorView.startAnimating();
            let queue = DispatchQueue.global();
            queue.async {
                let url = URL(string: produto.foto)!
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = data {
                        fotoImageView.image = UIImage(data: imageData)
                    }
                    else
                    {
                        fotoImageView.image = UIImage(named: "sem-foto")
                    }
                    activityIndicatorView.stopAnimating();
                }
            }
            
            fabricanteLabel.text = produto.fabricante;
            nomeLabel.text = produto.nome;
            valorLabel.text = produto.valor;
            valor10xLabel.text = produto.valor10x + " em até 10x";
            
            // gradiente no background da celula do produto
            let backgroundView: UIView = cell.viewWithTag(99)!;
            let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = gradientLayer.bounds
            backgroundView.layer.insertSublayer(gradientLayer, at:0)
            backgroundView.layer.cornerRadius = 10.0
            backgroundView.clipsToBounds = true
            backgroundView.layer.masksToBounds = true
            
            // sombra no background da celula do produto
            let sobraView: UIView = cell.viewWithTag(98)!;
            aplicaSombra(view: sobraView, opacidade: 0.2)
            
            // sombra na imagem
            let imageView: UIView = cell.viewWithTag(97)!;
            aplicaSombra(view: imageView, opacidade: 0.1)
            
            
            // bordas arredondadas no botão
            comprarButton.layer.cornerRadius = 10.0

        }
        
        if (indexPath.section == 2)
        {
            let activityIndicatorView: UIActivityIndicatorView = cell.viewWithTag(1) as! UIActivityIndicatorView;
            activityIndicatorView.startAnimating()
        }
    }
    
    // MARK: - Target Actions
    
    // MARK: - Navigation

    // MARK: - Delegates

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 1)
        {
            return 195.0;
        }
        else
        {
            return 55.0;
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (distanceFromBottom < height)
        {
            listaProdutos()
        }
    }
    
}
