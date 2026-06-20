# Pos Web 2026

[![Deploy MyAPP](https://github.com/nicolyjjang/posweb2026/actions/workflows/deploy.yml/badge.svg)](https://github.com/nicolyjjang/posweb2026/actions/workflows/deploy.yml)
[![AWS](https://img.shields.io/badge/AWS-EC2%20%26%20RDS-orange)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-purple)](https://www.terraform.io/)
[![Flask](https://img.shields.io/badge/Backend-Flask-blue)](https://flask.palletsprojects.com/)

## Sobre o Projeto

A aplicação web gerencia um cadastro simples de pessoas, com operações de CRUD através de uma API. Demonstrando a integração entre:
- **Infraestrutura como Código (IaC)** com Terraform.
- **Pipeline CI/CD** com GitHub Actions.
- **Backend API** com Flask e MySQL.
- **Fronted** com HTML, CSS e JavaScript.


### Desafios e Soluções
----

Durante o desenvolvimento, enfrentamos e resolvemos diversos desafios:
1. Erro: `groupId is invalid no Terraform`
    - **Problema**: O atributo `security_groups` em `main.tf` aceita strings mas só funciona no EC2 Classic.
    - **Solução**: Substituir por `vpc_security_groups_ids`, que aceita IDs.
---

2. Erro: `The key pair 'posweb-myapp-2026' does not exist`
   - **Problema**: A chave SSH não existia na AWS.
   - **Solução**: Criar um arquivo `` para gerar e registrar a chave automaticamente.
    > Essa abordagem é para desenvolvimento. Em produção, recomenda-se usar chaves gerenciadas manualmente.
  
---

3. Erro: `index.html: Cannot open: Permission denied`
    - **Problema**: O usuário `ubuntu` não tinha permissão para escrever em `/var/www/html`.
    - **Solução**: Atualizar o `user_data.tpl` para futuras instâncias: `chown -R ubuntu:ubuntu /var/www/html`
---

4. Erro: `connection refused no Backend` 
    - **Problema**: O Flask estava rodando apenas em localhost `app.run(debug=True)`.
    - **Solução**: Alterar para escutar em todas as interfaces `app.run(host='0.0.0.0', port=5000`.
---

5. Erro: `ERROR 500 no Backend`
    - **Problema**: O banco de dados não tinha as tabelas criadas.
    - **Solução**: Adicionar a step `Setup DB schema` para executar o script SQL via GitHub Actions.
