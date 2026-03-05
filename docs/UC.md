# Casos de Uso do Sistema: SIDERA PREDICT

## UC01 — Realizar Inspeção de Peça (SCAN)

**Ator Principal:** Inspetor (Gestão/Qualidade) ou Operador.

**Objetivo:** Permitir a inspeção visual e obter um veredito instantâneo na linha de produção.

**Pré-condições:**

* O usuário deve possuir o aplicativo aberto no dispositivo móvel.

**Pós-condições:**

* O resultado da análise estruturada é processado e exibido na tela.

**Fluxo Principal:**

1. O aplicativo permite o acesso imediato à tela principal de inspeção sem a necessidade de autenticação (login/senha).
2. O sistema disponibiliza uma interface de câmera integrada com o enquadramento correto da peça utilizando guias visuais.
3. O usuário captura a foto da peça.
4. O aplicativo envia a foto instantaneamente para análise do modelo de Inteligência Artificial Preditiva.
5. A inferência do modelo de visão computacional é executada localmente no dispositivo utilizando TensorFlow Lite (TFLite).
6. O processamento da imagem pela IA local retorna um veredito em milissegundos.
7. O sistema exibe o resultado da inspeção.

**Fluxos Alternativos:**

* **A1 — Inspeção Aprovada:**
* O status da inspeção é classificado como Aprovado.
* O sistema exibe o resultado utilizando a cor Verde.


* **A2 — Falha de Leitura:**
* O status da inspeção é classificado como Falha de Leitura.
* O sistema exibe o resultado utilizando a cor Laranja.



**Relacionamentos:**

* **RF:** RF01, RF02, RF03, RF04.
* **RN:** RN01, RN03.
* **RNF:** RNF01, RNF02, RNF03, RNF05.

---

## UC02 — Analisar Anomalia e Gerar Laudo

**Ator Principal:** Inspetor (Gestão/Qualidade).

**Objetivo:** Visualizar detalhes de uma peça reprovada e gerar um laudo técnico inteligente com ajuda da IA Generativa.

**Pré-condições:**

* A inspeção submetida ao modelo deve resultar no estado de "Anomalia Detectada".

**Pós-condições:**

* Descrições técnicas e recomendações são geradas no sistema.

**Fluxo Principal:**

1. O status da inspeção é classificado como "Anomalia Detectada".
2. O sistema exibe o resultado utilizando a cor Vermelha.
3. O aplicativo apresenta uma tela de detalhamento (Raio-X da Inspeção) para peças reprovadas.
4. O sistema destaca os pontos exatos da anomalia na imagem.
5. O sistema exibe o grau de confiabilidade (percentual) da IA.
6. A requisição para a API do Gemini é disparada.
7. O sistema integra-se ao Google Gemini para redigir automaticamente descrições técnicas detalhando a causa provável do defeito.
8. O aplicativo fornece sugestões imediatas de ajuste de maquinário geradas pela IA.

**Relacionamentos:**

* **RF:** RF04, RF05, RF06, RF07.
* **RN:** RN01, RN02, RN03.
* **RNF:** RNF04, RNF05.

---

## UC03 — Emitir Ordem de Serviço e Notificar Equipe

**Ator Principal:** Inspetor (Gestão/Qualidade).

**Objetivo:** Transformar os dados da anomalia em ações de manutenção de forma rápida.

**Pré-condições:**

* O sistema deve ter detectado uma anomalia.

**Pós-condições:**

* Ordem de serviço é gerada e encaminhada via e-mail.

**Fluxo Principal:**

1. O aplicativo permite a criação simplificada de ordens de serviço a partir de uma anomalia detectada.
2. Os e-mails e ordens de serviço gerados seguem um template técnico estrito pré-definido pelo módulo de Inteligência.
3. O sistema impede variações de formatação que prejudiquem a leitura da equipe de manutenção.
4. O sistema envia e-mails pré-formatados para a equipe de manutenção com apenas um clique.
5. O sistema anexa o laudo e a OS ao disparo de comunicação.

**Relacionamentos:**

* **RF:** RF09, RF10.
* **RN:** RN04.

---

## UC04 — Acompanhar Dashboard de KPIs

**Ator Principal:** Inspetor (Gestão/Qualidade).

**Objetivo:** Permitir a análise de métricas para embasar decisões.

**Pré-condições:**

* O sistema deve possuir dados consolidados de inspeções anteriores.

**Pós-condições:**

* Gráficos gerenciais são exibidos na tela.

**Fluxo Principal:**

1. O inspetor acessa o painel gerencial.
2. O sistema exibe gráficos interativos.
3. O sistema mostra o volume total de inspeções.
4. O sistema mostra o ranking de máquinas com maior índice de falhas/gargalos.
5. O sistema mostra a latência de resposta do modelo.

**Relacionamentos:**

* **RF:** RF08.
* **RNF:** RNF05.
