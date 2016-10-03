//
//  ViewController.swift
//  OpenLibrary
//
//  Created by jesus serrano on 24/09/16.
//  Copyright © 2016 gezuzm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var tfISBN: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var imgvPortada: UIImageView!
    @IBOutlet weak var labPortada: UILabel!
    @IBOutlet weak var labError: UILabel!

    func sincronoJSON()
    {
        
        titulo.text=""
        autores.text=""
        labError.text=""
        
        if labPortada.text == ""
        {
            imgvPortada.hidden = true
        }
        
        labPortada.text=""
        
        let isbn: String = "ISBN:"
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=" + isbn + tfISBN.text!
        // se convierte a URL
        let url = NSURL(string: urls)
        
        // HACE UNA PETCION AL SERVIDOR
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        // para mostrarlo hay qye decirel en que formato esta
        let textoISBN = tfISBN.text!
        // print(  datos)
        
        if datos != nil
        {
            if datos?.length > 2
            {
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                
                // hacer el recorrido del arbol JSON
                let dic1 = json as! NSDictionary
                let dic2 = dic1[isbn + textoISBN] as! NSDictionary
                
                // muestra el titulo
                self.titulo.text = dic2["title"] as! NSString as String
                
                var author: String?
                var authores: String = " "
            
                // muestra los autores
                if let dic3 = dic2["authors"] as? NSArray
                {
                   for array in dic3
                    {
                    if let obj_array = dic3.lastObject as? NSDictionary
                            {
                                author = obj_array["name"] as? String
                                    
                                if author != nil{
                                        authores = authores + " - " + author!
                                    }
                           }
                    }
                }
                
                if authores != " "{
                    self.autores.text = authores
                }
                else{
                    self.autores.text = "no hay autores"
                }
  
                // muestra la portada si hay
                do{
                    
                    if  let dic4 = dic2["cover"] as? NSDictionary
                    {
                        
                        let urlImg4 = dic4["small"] as! NSString as String
                        
                        imageFromUrl(urlImg4)
                    }
                    else
                    {
                        self.labPortada.text = "No hay Portada"
                    }
                }
                catch {
                       // self.imgvPortada.image = "no tiene portada registrada"
                }
            }
            catch _
            {
            
            }
            }
            else
            {
                
                self.labError.text = "ISBN no válido..."
                
                titulo.text=""
                autores.text=""
                
                if labPortada.text == ""
                {
                    
                    // imgvPortada.removeFromSuperview()  // this removes it from your view hierarchy
                    imgvPortada.hidden = true
                    // imgvPortada = nil;
                }
                
                labPortada.text=""
            }
        }
        else
        {
           // tvResultado.text = "Ocurrió un error, no hay conexion..."
            self.labError.text = "Ocurrió un error, no hay conexion..."
            
            titulo.text=""
            autores.text=""
            
            if labPortada.text == ""
            {
                
                // imgvPortada.removeFromSuperview()  // this removes it from your view hierarchy
                imgvPortada.hidden = true
                // imgvPortada = nil;
            }
            
            labPortada.text=""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfISBN.text = "978-84-376-0494-7"
        tfISBN.text = "8425220181"
        
    }
    
    @IBAction func btnLimpiar(sender: AnyObject) {
        
        tfISBN.text = ""
        //tvResultado.text = ""
        
        titulo.text=""
        autores.text=""
        labError.text=""
        
        if labPortada.text == ""
        {
            imgvPortada.hidden = true
        }
        
        labPortada.text=""
    }
    
    @IBAction func btnBuscar(sender: AnyObject) {
        
        // cerrar teclado
        tfISBN.resignFirstResponder()
        
        if tfISBN.text != ""
        {
            sincronoJSON()
        }
        else
        {
            muestraMensaje("Es necesario escribir el ISBN")
        }
        
    }
    
    func muestraMensaje(cadena : String)
    {
        let alertController = UIAlertController(title: "Aviso", message:
            cadena, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    // oculta el teclado cuando presiona enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        self.sincronoJSON()
        return true
        
    }
    
    // oculta el teclado cuando presiona esoacio vacio
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        tfISBN.resignFirstResponder()
        
    }

    // codigo descargado de:
    // http://blog.mcnallydevelopers.com/cargar-imagen-desde-un-url-en-un-imageview-de-ios-con-swift-2/
    func imageFromUrl(urlString: String) {
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                   
                    self.imgvPortada.hidden = false
                   
                    
                    if data != nil
                    {
                    self.imgvPortada.image = UIImage(data: data!)
                         self.labPortada.text = ""
                      self.imgvPortada.contentMode = UIViewContentMode.ScaleAspectFit
                    }
                    else
                    {
                        self.imgvPortada.hidden = true
                        self.labPortada.text = "No hay Portada"
                    }
                }
        }.resume()
        }
    
}


