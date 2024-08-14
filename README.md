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

