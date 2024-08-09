import Foundation

// MARK: - Modelos de dados
struct Vehicle: Decodable {
    let nick: String
    let model: String
    let manufacturer: String
    let plate: String
    let productionYear: String
    let acquisitionYear: String
    let km: String
    let services: [Maintenance]
    let optionals: Optionals
    
    enum CodingKeys: String, CodingKey {
        case services = "maintenanceHistory"
        case nick, model, manufacturer, plate, productionYear, acquisitionYear, km, optionals
    }
    
    struct Maintenance: Decodable {
        let type: MaintenanceType
        let resume: String
        let km: String
        let price: String
        
        enum MaintenanceType: Int, Decodable {
            case oil, brake, tire, suspension, eletric
            
            var title: String {
                switch self {
                case .oil:
                    return "Oil 🛢️"
                case .brake:
                    return "Brakes 🛑"
                case .tire:
                    return "Tires 🛞"
                case .suspension: 
                    return "Suspension ⬇️"
                case .eletric:
                    return "Eletric ⚡️"
                }
            }
        }
    }
    
    struct Optionals: Decodable {
        let eletricGlass: String
        let airConditioned: String
        let alarm: String
        let powerSteering: String
        
        private enum CodingKeys: String, CodingKey {
            case eletricGlass = "automaticGlass"
            case airConditioned, alarm, powerSteering
        }
    }
}

// MARK: = Payload JSON
let sampleJson = """
[
    {
        "nick": "Lemonade",
        "model": "Palio",
        "manufacturer": "Fiat",
        "plate": "mjmj123",
        "production_year": "2004",
        "acquisition_year": "2010",
        "km": "234982",
        "optionals" : {
            "automaticGlass": "S",
            "airConditioned": "N",
            "alarm": "N",
            "powerSteering": "S"
        },
        "maintenance_history": []
    },
    {
        "nick": "Pikachu",
        "model": "Fiesta",
        "manufacturer": "Ford",
        "plate": "mjhj321",
        "production_year": "2000",
        "acquisition_year": "2008",
        "km": "234982",
        "optionals" : {
            "automaticGlass": "S",
            "airConditioned": "S",
            "alarm": "S",
            "powerSteering": "S"
        },
        "maintenance_history": [
            {
                "type": 0,
                "resume": "Oil change with filter",
                "km": "235200",
                "price": "230.00",
            },
            {
                "type": 1,
                "resume": "Change rear pads",
                "km": "235800",
                "price": "300.00",
            },
        ]
    },
]
"""

// MARK: - Decodificando o payload
func decode() {
    let decodeProduct: [Vehicle]
    guard let data = sampleJson.data(using: .utf8) else {
        return
    }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        decodeProduct = try decoder.decode([Vehicle].self, from: data)
        printInformation(vehicle: decodeProduct)
    } catch {
        print("Ops!")
    }
}

func printInformation(vehicle: [Vehicle]) {
    vehicle.forEach { product in
        print("""
        Nick: \(product.nick)
        Model: \(product.model)
        Manufacturer: \(product.manufacturer)
        Production year: \(product.productionYear)
        Aquisition year: \(product.acquisitionYear)
        Km: \(product.km)
        Optionals: 
         Glass: \(product.optionals.eletricGlass)
         A.C.: \(product.optionals.airConditioned)
         Alarm: \(product.optionals.alarm)
         Power steering: \(product.optionals.powerSteering)\n
        """)
        if !product.services.isEmpty {
            print("Maintenance history:")
            product.services.forEach { maintenance in
                print("""
                 Type: \(maintenance.type.title)
                 Resume: \(maintenance.resume)
                 Km: \(maintenance.km)
                 Price: \(maintenance.price)
                \n
                """)
            }
        }
    }
}
//decode()


// MARK: - Brincando com o init Decoder
let imovelJSON = """
{
    "categoria": "casa",
    "quantidade_quartos": 3,
    "localizacao": {
        "rua": "Edelmindo Silveira",
        "numero": 12,
        "cep": "88293875"
    },
    "observacoes": "FíDumaÉgua"
}
"""

struct Imovel: Decodable {
    let categoria: String
    let quantidadeQuartos: Int
    let observacoes: String?
    
    let rua: String
    let numero: Int
    let cep: String
}

extension Imovel {
    private enum CodingKeys: String, CodingKey {
        case categoria, quantidadeQuartos, observacoes, localizacao
    }
    
    enum LocalizacaoKeys: String, CodingKey {
        case numero, rua, cep
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.categoria = try container.decode(String.self, forKey: .categoria)
        self.quantidadeQuartos = try container.decode(Int.self, forKey: .quantidadeQuartos)
        self.observacoes = try container.decodeIfPresent(String.self, forKey: .observacoes)
        
        let nestedContainer = try container.nestedContainer(keyedBy: LocalizacaoKeys.self, forKey: .localizacao)
        self.rua = try nestedContainer.decode(String.self, forKey: .rua)
        self.numero = try nestedContainer.decode(Int.self, forKey: .numero)
        self.cep = try nestedContainer.decode(String.self, forKey: .cep)
    }
}

func decodeImovel(data: Data) {
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let decoded = try decoder.decode(Imovel.self, from: data)
        printImovel(imovel: decoded)
    } catch DecodingError.dataCorrupted(let context) {
        print("Context currupted: \(context.debugDescription)")
    } catch DecodingError.keyNotFound(let codingKey, let context) {
        print("Context not found: \(context.debugDescription)\n codingKey: \(codingKey)")
    } catch DecodingError.typeMismatch(_ , let context) {
        print("Context decoding error: \(context.debugDescription)")
    } catch {
        print(error.localizedDescription)
    }
    
}

func printImovel(imovel: Imovel) {
    print(imovel)
}


decodeImovel(data: Data(imovelJSON.utf8))
