import Foundation

struct Vehicle: Decodable {
    let nick: String
    let model: String
    let manufacturer: String
    let plate: String
    let productionYear: String
    let acquisitionYear: String
    let km: String
    
    enum CodingKeys: String, CodingKey {
        case nick, model, manufacturer, plate,
             productionYear = "production_year",
             acquisitionYear = "acquisition_year",
             km
    }
}

let sampleJson = """
{
    "nick": "Lemonade",
    "model": "Palio",
    "manufacturer": "Fiat",
    "plate": "mjmj123",
    "production_year": "2004",
    "acquisition_year": "2010",
    "km": "234982"
}
"""

func decode() {
    let decodeProduct: Vehicle
    guard let data = sampleJson.data(using: .utf8) else {
        return
    }
    let decoder = JSONDecoder()
    do {
        decodeProduct = try decoder.decode(Vehicle.self, from: data)
        print(decodeProduct)
    } catch {
        print("Ops!")
    }
}

decode()

