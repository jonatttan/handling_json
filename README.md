# Handling JSON

### JSONDecoder
<br/> 

##### > Iniciando com um decode simples...
A estrutura foi minimizada para ficar mais simples e objetiva, mas resumidamente temos a definição de estrutura Decodable, um payload JSON diretamente em variável e uma função para de fato realizar a decodificação, que o transforma em data e o decodifica no formato da estrutura definida (Vehicle) usando o JSONDecoder.

```Swift
import Foundation

struct Vehicle: Decodable {
    let nick: String
    let km: String
}

let sampleJson = """
{
    "nick": "Lemonade",
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
```
Mais detalhes no [commit](https://github.com/jonatttan/handling_json/commit/3412828ba6c2261444479e22797d8114b7002bc7)

##### > Trabalhando com Codingeys...
Adicionando mais campos ao JSON, agora com nomes compostos em snake_case (padrão em JSON) e atributos ao struct com CodingKeys para obtermos os dados em snakeCase. Não creio ser a abordagem ideal para o Swift, mais tarde veremos que na versão 4.1 foi introduzida uma solução mais elegante.

```Swift
import Foundation

struct Vehicle: Decodable {
    ...
    let productionYear: String

    enum CodingKeys: String, CodingKey {
        case nick, km,
             productionYear = "production_year"
    }
}

let sampleJson = """
{
    ...
    "production_year": "2004",
}
"""

func decode() {
    ...
}

decode()
```
Mais detalhes no [commit](https://github.com/jonatttan/handling_json/commit/ccaf475e4a22c7c0df46a81f6a2c09af08ef14e5)

##### > Trabalhando com keyDecodingStrategy...
Chegou a hora de vermos a tal solução mais elegante para substituirmos o CodingKeys do struct para apenas fazer essa tradução de snake_case para camekCase. A solução seria o atribuir .convertFromSnakeCase a propriedade keyDecodingStrategy do JSONDecoder, um recurso trazido no Swift 4.1, que como o nome já informa, converte o nome do atributo do objeto JSON do snake_case para o padrão do Swift camelCase. Com isso eliminamos a necessidade, nesse caso, de usar o enum CodingKeys.

```Swift

func decode() {
    ...
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    ...
}
```
Mais detalhes no [commit](https://github.com/jonatttan/handling_json/commit/e9c817a8be0670b143ee43cf4d13c0ac17b3ffef)

##### > Decodando lista de objetos...
Até aqui decodamos um objeto que recebemos por JSON, agora veremos como decodar uma lista de objetos veículo.
Fazendo um pequeno ajuste no JSON (nesse caso, uma variável local), colocamos colchetes no início e fim, adicionamos uma vírgula ao fim do primeiro objeto e adicionamos outro. 
Já no Swift, indicamos que o atributo/ variável vai receber uma lista de objetos e no decode indicamos que deve ser decodado para o tipo lista desse objeto.

```Swift
let sampleJson = """
[
    {
        "nick": "Lemonade",
        ...
    },
    {
        "nick": "Pikachu",
        ...
    },
]
"""
...

func decode() {
    let decodeProduct: [Vehicle]
    ...
    do {
        decodeProduct = try decoder.decode([Vehicle].self, from: data)
        ...
    } 
    ...
```
Mais detalhes no [commit](https://github.com/jonatttan/handling_json/commit/8f472c282d1ee796c1be1bc8c63c835ea09f11d3)



Referências:
https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types (Aqui você entende um pouco a diferença entre os três protocolos, os tipos que oferecem conformidade por padrão, CodingKeys, codificação e decodificação manual com inits e outras coizinhas.)

https://www.alura.com.br/artigos/ios-swift-conversao-dados-codable-encodable-decodable (Aqui você encontra um pouco mais de exemplos desenho estrutural JSON, além é claro do Swift atuando com conversão Data, Codables/ Decodables e o uso do JSONDecoder/ JSONencoder.)

https://dev.to/reisdev/como-decodificar-json-em-swift-2dpe (Nesse artigo você vai encontrar mais exemplos de uso, além de como trazer o arquivo JSON pra dentro do seu código - deixando de usar aquela variável local.)

https://mateusfsilvablog.wordpress.com/2018/03/02/decodificando-json-com-swift-4/ (Particulamente, eu gostei muito desse. Tem bastante exemplos de código, ensina a usar as ferramentas do JSONEncoder/ JSONDecoder para traduzir os camelCases em snake_case e vice-versa, formatação de datas, números decimais, custom decode - a manual com init - e outros. Ah.. E esse cara possui um "Parte 2". 😉).

https://developer.apple.com/documentation/foundation/jsondecoder (Um breve exemplo de decoder.)

Bônus:
Para entender um pouco mais sobre as datas eu dei uma lida [aqui](https://www.swiftyplace.com/blog/swift-date-formatting-10-steps-guide#:~:text=Creating%20a%20current%20date%20in,based%20on%20the%20system%20clock.)