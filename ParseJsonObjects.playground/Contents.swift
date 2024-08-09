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
    
    enum CodingKeys: CodingKey {
        case categoria
        case quantidadeQuartos
        case observacoes
        case localizacao
    }
    
    enum AllCodingKey: String, CodingKey {
        case categoria, quantidadeQuartos, observacoes, rua, numero, cep
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: AllCodingKey.self)
        try container.encode(self.categoria, forKey: .categoria)
        try container.encode(self.quantidadeQuartos, forKey: .quantidadeQuartos)
        try container.encode(self.observacoes, forKey: .observacoes)
        try container.encode(self.localizacao.rua, forKey: .rua)
        try container.encode(self.localizacao.numero, forKey: .numero)
        try container.encode(self.localizacao.cep, forKey: .cep)
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
