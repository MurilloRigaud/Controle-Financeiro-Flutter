# 💰 Controle Financeiro Flutter

Aplicativo de **Controle Financeiro Pessoal** desenvolvido em Flutter como projeto acadêmico, utilizando arquitetura **MVVM**, **Firebase** e **Riverpod** para gerenciamento de estado.

---

## 📱 Screenshots

> Tela de Login • Dashboard • Análise Financeira • Notícias

---

## ✨ Funcionalidades

- 🔐 **Autenticação real** com Firebase Auth (Login e Cadastro)
- 💸 **CRUD completo de transações** (Adicionar, Editar, Excluir)
- 📊 **Dashboard** com saldo total, receitas e despesas em tempo real
- 📈 **Análise financeira** com barras de progresso por categoria
- 🗂️ **Categorias** de transações (Alimentação, Transporte, Saúde, etc.)
- 📰 **Feed de notícias financeiras** com Skeleton Screen de carregamento
- ☁️ **Persistência na nuvem** com Firebase Firestore
- 📱 **APK gerado** e instalável em dispositivos Android

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com a seguinte estrutura:

```
lib/
├── core/
│   ├── database/         # Configuração do banco de dados local
│   └── models/           # Modelos de dados (User, Transaction)
├── features/
│   ├── auth/
│   │   ├── view/         # Tela de Login e Cadastro
│   │   └── viewmodel/    # Lógica de autenticação (Riverpod)
│   ├── transactions/
│   │   ├── view/         # Dashboard e Tela de Análise
│   │   └── viewmodel/    # Lógica de transações (Riverpod)
│   └── news/
│       ├── view/         # Feed de notícias
│       └── viewmodel/    # Consumo de API externa
└── main.dart             # Ponto de entrada e rotas
```

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Descrição |
|------------|-----------|
| [Flutter](https://flutter.dev/) | Framework de desenvolvimento mobile |
| [Dart](https://dart.dev/) | Linguagem de programação |
| [Firebase Auth](https://firebase.google.com/products/auth) | Autenticação de usuários |
| [Cloud Firestore](https://firebase.google.com/products/firestore) | Banco de dados na nuvem |
| [Flutter Riverpod](https://riverpod.dev/) | Gerenciamento de estado |
| [HTTP](https://pub.dev/packages/http) | Consumo de API externa |
| [Shimmer](https://pub.dev/packages/shimmer) | Skeleton screen de carregamento |
| [Intl](https://pub.dev/packages/intl) | Formatação de moeda e datas |
| [Shared Preferences](https://pub.dev/packages/shared_preferences) | Persistência local |

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado
- Conta no [Firebase](https://firebase.google.com/)
- Android Studio ou VS Code

### Passo a passo

```bash
# Clone o repositório
git clone https://github.com/MurilloRigaud/Controle-Financeiro-Flutter.git

# Entre na pasta do projeto
cd Controle-Financeiro-Flutter

# Instale as dependências
flutter pub get

# Rode o app no navegador
flutter run -d web-server

# Ou gere o APK
flutter build apk --release
```

### Configuração do Firebase

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Ative **Authentication** (Email/Senha) e **Firestore Database**
3. Execute `flutterfire configure` para gerar o `firebase_options.dart`

---

## 📋 Requisitos Atendidos

- ✅ CRUD de transações (Adicionar, Listar, Editar, Excluir)
- ✅ Cálculo automático de saldo
- ✅ Filtro por categoria e tipo (Receita/Despesa)
- ✅ Validação de formulários com `GlobalKey<FormState>`
- ✅ Persistência local com SharedPreferences
- ✅ Gerenciamento de estado com Riverpod
- ✅ Fluxo de autenticação real (Login + Cadastro)
- ✅ Navegação entre 3 telas funcionando
- ✅ Padrão MVVM respeitado
- ✅ Riverpod para gerenciamento de estado avançado
- ✅ Firebase Auth + Firestore (banco externo)
- ✅ Consumo de API externa (notícias financeiras)
- ✅ Skeleton Screen com pacote Shimmer
- ✅ Tratamento de erros de rede
- ✅ APK gerado e instalável

---

## 👤 Autor

**Murillo Rigaud dos Santos Oliveira**

[![GitHub](https://img.shields.io/badge/GitHub-MurilloRigaud-181717?style=flat&logo=github)](https://github.com/MurilloRigaud)

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.