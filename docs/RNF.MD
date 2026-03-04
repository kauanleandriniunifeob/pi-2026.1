### Requisitos Não Funcionais (RNF)

* **RNF01 - Framework de Desenvolvimento:** O aplicativo mobile deve ser desenvolvido em **Flutter**, garantindo compatibilidade multiplataforma (Android e iOS).
* **RNF02 - Processamento Local (Edge AI):** A inferência do modelo de visão computacional deve ser executada localmente no dispositivo utilizando **TensorFlow Lite (TFLite)**.
* **RNF03 - Desempenho e Latência:** O processamento da imagem pela IA local (TFLite) deve retornar um veredito em milissegundos, garantindo a agilidade da operação.
* **RNF04 - Integração de IA Generativa:** A geração de laudos e recomendações deve ser processada através do consumo da API do **Google Gemini** ou uso de IA rodando localmente em servidores da empresa.
* **RNF05 - Usabilidade e UI/UX:** A interface do usuário deve possuir alto contraste e elementos visuais grandes, otimizados para a visibilidade em ambientes industriais (chão de fábrica).
