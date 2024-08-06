import Foundation

struct Vehicle: Decodable {
    let nick: String
    let model: String
    let manufacturer: String
    let plate: String
    let productionYear: String
    let acquisitionYear: String
    let km: String
    let maintenanceHistory: [Maintenance]
    
    struct Maintenance: Decodable {
        let type: String
        let resume: String
        let km: String
        let price: String
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
        """)
        if !product.maintenanceHistory.isEmpty {
            print("Maintenance history:")
            product.maintenanceHistory.forEach { maintenance in
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

