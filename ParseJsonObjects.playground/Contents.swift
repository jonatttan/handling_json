import Foundation

// MARK: - Estrutura de dados
struct Imovel: Encodable {
    let categoria: String
    let quantidadeQuartos: Int
    let observacoes: String?
    let localizacao: Localizacao
    
    struct Localizacao: Encodable {
        let rua: String
        let numero: Int
        let cep: String
    }
}

// MARK: - Brincando com Encoder
func encodeImovel(imovel: Imovel) {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    jsonEncoder.outputFormatting = .prettyPrinted
    
    do {
        let encodedData = try jsonEncoder.encode(imovel)
        let encodedJSON = String(data: encodedData, encoding: .utf8) ?? ""
        print(encodedJSON)
    } catch {
        print(error.localizedDescription)
    }
}

let imovel = Imovel(categoria: "casa",
                    quantidadeQuartos: 3,
                    observacoes: "Cômodos bem iluminados durante a manhã, pátio reservado com muros altos.",
                    localizacao: Imovel.Localizacao(
                        rua: "Edelmindo Silveira",
                        numero: 12,
                        cep: "88293875"))

encodeImovel(imovel: imovel)
