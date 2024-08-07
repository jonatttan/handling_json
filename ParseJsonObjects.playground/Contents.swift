import Foundation

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
    // Quero forçar a necessidade de init Decoder com nestedContainer
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.services = try container.decode([Vehicle.Maintenance].self, forKey: .services)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.model = try container.decode(String.self, forKey: .model)
        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
        self.plate = try container.decode(String.self, forKey: .plate)
        self.productionYear = try container.decode(String.self, forKey: .productionYear)
        self.acquisitionYear = try container.decode(String.self, forKey: .acquisitionYear)
        self.km = try container.decode(String.self, forKey: .km)
        
        let optionalsNestedObj = try container.nestedContainer(keyedBy: OptionalsKeys.self, forKey: .optionals)
        let eletricGlass = try optionalsNestedObj.decode(String.self, forKey: .eletricGlass)
        let airConditioned = try optionalsNestedObj.decode(String.self, forKey: .airConditioned)
        let alarm = try optionalsNestedObj.decode(String.self, forKey: .alarm)
        let powerSteering = try optionalsNestedObj.decode(String.self, forKey: .powerSteering)
        self.optionals = Optionals(eletricGlass: eletricGlass,
                                   airConditioned: airConditioned,
                                   alarm: alarm,
                                   powerSteering: powerSteering)
    }
    
    enum CodingKeys: String, CodingKey {
        case services = "maintenanceHistory"
        case nick, model, manufacturer, plate, productionYear, acquisitionYear, km, optionals
    }
    
    enum OptionalsKeys: String, CodingKey {
        case eletricGlass = "automaticGlass"
        case airConditioned, alarm, powerSteering
    }
    
    struct Maintenance: Decodable {
        let type: String
        let resume: String
        let km: String
        let price: String
        // Adicionar enum para o type
    }
    
    struct Optionals: Decodable {
        let eletricGlass: String
        let airConditioned: String
        let alarm: String
        let powerSteering: String
    }
}

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
                "type": "Oil",
                "resume": "Oil change with filter",
                "km": "235200",
                "price": "230.00",
            },
            {
                "type": "Brake",
                "resume": "Change rear pads",
                "km": "235800",
                "price": "300.00",
            },
        ]
    },
]
"""

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
                 Type: \(maintenance.type)
                 Resume: \(maintenance.resume)
                 Km: \(maintenance.km)
                 Price: \(maintenance.price)
                \n
                """)
            }
        }
        print("\n\n")
    }
}
decode()

