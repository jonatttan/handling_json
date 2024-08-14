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
