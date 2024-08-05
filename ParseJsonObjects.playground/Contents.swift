import Foundation

struct Vehicle: Decodable {
    let nick: String
    let model: String
    let manufacturer: String
    let plate: String
    let km: String
}

let sampleJson = """
{
    "nick": "Lemonade",
    "model": "Palio",
    "manufacturer": "Fiat",
    "plate": "mjmj123",
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

