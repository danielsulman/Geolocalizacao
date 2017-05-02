//
//  ViewController.swift
//  Geolocalizacao
//
//  Created by Daniel Sulman de Albuquerque Eloi on 25/04/17.
//  Copyright © 2017 Daniel Sulman de Albuquerque Eloi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    var gerenciadorDeLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorDeLocalizacao.delegate = self
        gerenciadorDeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
        gerenciadorDeLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last!
        let longitude = localizacaoUsuario.coordinate.longitude
        let latitude = localizacaoUsuario.coordinate.latitude
        
        longitudeLabel.text = String(describing: longitude)
        latitudeLabel.text = String(describing: latitude)
        
        velocidadeLabel.text = String(describing: localizacaoUsuario.speed)
        
        //Atualizando o mapa
        
        //Aproximacao do mapa, quanto menor, mais próximo
        let deltaLat: CLLocationDegrees = 0.01
        let deltaLon: CLLocationDegrees = 0.01
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let areaExibicao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLat, deltaLon)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao)
        mapa.setRegion(regiao, animated: true)
        
        //Pegando a rua
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
            
            if erro == nil{
                let dadosLocal = detalhesLocal?.first
                
                var thoroughfare = ""
                if dadosLocal?.thoroughfare != nil{
                    thoroughfare = (dadosLocal?.thoroughfare!)!
                    print(thoroughfare)
                }
                
            }else{
                print(erro)
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            var alertaController = UIAlertController(title: "Permissão de localização", message: "Favor habilitar", preferredStyle: .alert)
            var acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfirguracoes) in
                
                if let configuracoes = NSURL(string : UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            })
            var acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction(acaoConfiguracoes)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
        }
    }


}

