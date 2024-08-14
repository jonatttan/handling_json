import Foundation

// MARK: - Modelos de dados
struct Vehicle: Codable {
    let nick: String
    let model: String
    let manufacturer: String
    let plate: String
    let productionYear: String
    let acquisitionYear: String
    let km: Double?
    let services: [Maintenance]
    let optionals: Optionals
    
    enum CodingKeys: String, CodingKey {
        case services = "maintenanceHistory"
        case nick, model, manufacturer, plate, productionYear, acquisitionYear, km, optionals
    }
    
    struct Maintenance: Codable {
        let type: MaintenanceType
        let resume: String
        let km: Double?
        let price: String
        
        enum MaintenanceType: Int, Codable {
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
    
    struct Optionals: Codable {
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
        "km": 234.982,
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
        "km": "NaN",
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
                "km": "-Infinity",
                "price": "230.00",
            },
            {
                "type": 1,
                "resume": "Change rear pads",
                "km": "+Infinity",
                "price": "300.00",
            },
        ]
    },
]
"""

// MARK: - Decodificando o payload
func decode(from jsonString: String) -> [Vehicle] {
    var decodeProduct = [Vehicle]()
    let data = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity",
                                                                    negativeInfinity: "-Infinity",
                                                                    nan: "NaN")
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        decodeProduct = try decoder.decode([Vehicle].self, from: data)
    } catch {
        print("Ops!")
    }
    return decodeProduct
}

func printInformation(vehicle: [Vehicle]) {
    vehicle.forEach { product in
        print("""
        Nick: \(product.nick)
        Model: \(product.model)
        Manufacturer: \(product.manufacturer)
        Production year: \(product.productionYear)
        Aquisition year: \(product.acquisitionYear)
        Km: \(product.km ?? 0)
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
                 Km: \(maintenance.km ?? 0)
                 Price: \(maintenance.price)
                \n
                """)
            }
        }
    }
}

let vehicleModelList = decode(from: sampleJson)
//printInformation(vehicle: vehicleModelList)


// MARK: - Decode encripted data
func encodeVehiclesToBase64(vehicle: [Vehicle]) -> String {
    let encoder = JSONEncoder()
    encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+Infinity",
                                                                  negativeInfinity: "-Infinity",
                                                                  nan: "NaN")
    do {
        let encoded = try encoder.encode(vehicle)
        return encoded.base64EncodedString()
    } catch {
        return "encoding error"
    }
}

func decodeVehiclesFromBase64(encriptedString: String) -> [Vehicle] {
    var decodeProduct = [Vehicle]()
    guard let data = Data(base64Encoded: encriptedString) else {
        return decodeProduct
    }
    let decoder = JSONDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity",
                                                                    negativeInfinity: "-Infinity",
                                                                    nan: "NaN")
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        decodeProduct = try decoder.decode([Vehicle].self, from: data)
    } catch {
        print("decoding error")
    }
    return decodeProduct
}

let vehicle = Vehicle(nick: "", model: "",
                      manufacturer: "",
                      plate: "",
                      productionYear: "",
                      acquisitionYear: "",
                      km: 0,
                      services: [],
                      optionals: .init(eletricGlass: "S",
                                       airConditioned: "S",
                                       alarm: "S",
                                       powerSteering: "S")
)

let encodedString = encodeVehiclesToBase64(vehicle: decode(from: sampleJson))
//print(encodedString)

let decodedString = decodeVehiclesFromBase64(encriptedString: encodedString)
//printInformation(vehicle: decodedString)


// MARK: - Brincando com decode de arquivo json
func getJsonArchive(name: String) -> Data? {
    let data: Data
    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
        print("error url")
        return nil
    }
    do {
        data = try Data(contentsOf: url)
        return data
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

func decodeJsonArchive(name: String) -> [Vehicle] {
    var vehicles = [Vehicle]()
    
    guard let data = getJsonArchive(name: name),
          let jsonString = String(data: data, encoding: .utf8) else {
        print("Get archive ou parse to String error")
        return vehicles
    }
    
    let decoded = decode(from: jsonString)
    return decoded
}

let jsonArchiveDecoded = decodeJsonArchive(name: "vehicles")
printInformation(vehicle: jsonArchiveDecoded)


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
    let localizacao: Localizacao
    
    struct Localizacao: Codable {
        let rua: String
        let numero: Int
        let cep: String
    }
}

func decodeImovel(data: Data) {
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let decoded = try decoder.decode(Imovel.self, from: data)
        printImovel(imovel: decoded)
    } catch {
        print(error.localizedDescription)
    }
}

func printImovel(imovel: Imovel) {
    print(imovel)
}

//decodeImovel(data: Data(imovelJSON.utf8))
