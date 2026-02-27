# 🏭 SIDERA PREDICT

Repositório do **SIDERA PREDICT**, um ecossistema inteligente para inspeção de peças e gestão de qualidade no chão de fábrica. 

cite_startNós construímos esta solução dividida em dois aplicativos complementares, unindo Visão Computacional local e Inteligência Artificial Generativa para transformar a maneira como anomalias são detectadas e tratadas.

---

## 🎯 Visão do Produto

### ⚠️ O Problema
Na linha de produção, a inspeção visual de peças muitas vezes sofre com lentidão, gargalos e falta de padronização. Operadores precisam de respostas em tempo real, enquanto inspetores necessitam de dados consolidados para tomar decisões rápidas sobre manutenção e ajustes de maquinário.

### 👥 Público-Alvo
Nossa solução atende a dois perfis cruciais na operação:
1. **O Operador (Chão de Fábrica):** Precisa de extrema agilidade, zero atrito e respostas em milissegundos sem depender de conexão constante com a internet
2. **O Inspetor (Gestão/Qualidade):** Focado em análise de métricas, gestão do pátio e emissão rápida de laudos técnicos padronizados.

### 🚀 Nosso Objetivo
Criar um fluxo contínuo onde a captura de uma imagem pelo Operador seja processada instantaneamente por um modelo de IA local (Teachable Machine). Caso uma anomalia seja detectada, o Inspetor recebe os dados estruturados e utiliza IA Generativa (Google Gemini) para gerar um laudo automático e disparar ordens de manutenção com um único clique.

---

## 📱 Os Aplicativos

### 1️⃣ APP 1: Sidera Predict - Operador (Mobile)
Focado em velocidade e simplicidade no ambiente de produção.
* **Login Rápido:** Acesso via leitura de crachá (câmera) e PIN numérico.
* **Setup de Turno:** Seleção da Área e Máquina de trabalho.
* **Câmera Inteligente:** Guias visuais e giroscópio para garantir o ângulo perfeito (paralelo à peça) antes da captura.
* **Veredito em Milissegundos:** O modelo TFLite embarcado avalia a foto e colore a tela por 3 segundos (Verde = Aprovada, Vermelho = Anomalia, Laranja = Falha/Tentar Novamente).

### 2️⃣ APP 2: Sidera Predict - Inspetor (Híbrido Web/Mobile)
O centro de comando para gestão de qualidade.
* **Dashboard de KPIs:** Gráficos de defeitos, ranking de gargalos por máquina, volume de leitura e latência da IA.
* **Raio-X da Inspeção:** Visualização detalhada da peça reprovada com as predições brutas do modelo.
* **Laudos com IA (Gemini):** Geração automática de textos apontando a causa provável do defeito e a ação recomendada.
* **Integração de Manutenção:** Disparo de e-mail pré-formatado abrindo direto no aplicativo nativo do celular.

---

## 🛠️ Tecnologias e Ferramentas

* **Frontend/Mobile:** Flutter (Dart) para criação da interface do Operador e do Inspetor.
* **Inteligência Artificial (Local):** Google Teachable Machine exportado em formato TFLite para rodar offline no celular.
* **Inteligência Artificial (Nuvem):** API do Google Gemini para cruzamento de dados e geração de laudos em linguagem natural.

---

## 📁 Estrutura do Repositório

Nós organizamos nosso repositório para manter a documentação e o código sempre alinhados:

* `/docs/`: Contém todos os nossos Requisitos Funcionais (`RF.md`), Não Funcionais (`RNF.md`) e Regras de Negócio (`RN.md`).
* `/.github/`: Contém os nossos templates de Pull Request e Issues para padronizar o desenvolvimento da equipe.

---

## 🤝 Como estamos trabalhando

Nós utilizamos um fluxo rigoroso de padronização para garantir a qualidade do projeto durante o semestre:

1. **Issues:** Antes de escrever qualquer código, abrimos uma Issue utilizando um de nossos templates (`Funcionalidade`, `Bug`, `Documentação` ou `Infraestrutura`).
2. **Branches:** Cria-se uma branch a partir da `main` com o número da Issue (ex: `feat/issue-12-tela-login`).
3. **Pull Requests:** Ao finalizar, abrimos um PR preenchendo o nosso Checklist obrigatório (incluindo prints de telas, se houver mudanças visuais). E relacionamos a Issue no PR usando a palavra-chave (ex: `Closes #12`).