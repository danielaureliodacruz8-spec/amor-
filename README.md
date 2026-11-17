# Amor — Vendas da Cássia

Projeto Android independente para registrar vendas, compras por cliente e valores em aberto. A pasta foi organizada separada do app de drenagem para poder subir em um repositório próprio chamado `amor`.

## O que o app faz

- Ao abrir, mostra “Olá, Cássia, boas vendas!” e a data e hora atuais.
- Registra uma venda com nome do cliente e quantas mercadorias forem necessárias; cada linha tem produto, quantidade e valor unitário.
- Soma automaticamente os itens da venda.
- Salva a compra com data e hora. Se a pessoa voltar, uma nova venda no mesmo nome entra no histórico do cliente.
- Mostra o histórico de compras por cliente e permite marcar vendas em aberto como pagas.
- Gera relatório em PDF para imprimir ou salvar, com nome, datas, mercadorias, valores por item, total e saldo em aberto.
- Mantém os dados localmente neste aparelho.

## Repositório e CodeMagic

1. Crie ou abra o repositório GitHub chamado `amor`.
2. Envie os arquivos desta pasta para a raiz do repositório.
3. No CodeMagic, conecte o repositório `amor`, selecione `main` e inicie o workflow **Amor — Vendas da Cássia (APK de teste)**.
4. Baixe `app-debug.apk` na área **Artifacts**.

O APK de depuração serve para teste. Para distribuir oficialmente, configure assinatura Android no CodeMagic.

