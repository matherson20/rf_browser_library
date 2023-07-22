*** Settings ***
Resource    ../resources/serve-rest-front.resource
Suite Teardown    Close Browser    All


*** Test Cases ***
Login com sucesso Serve Rest front
    [Tags]    Login 
    Abrir o navegador
    Ir para o site
    Preencher os dados e cadastrar
    Conferir usuário cadastrado com sucesso
    Conferir usuário na listagem de usuários 

Login com sucesso e Cadastro de produto
    [Tags]    Cadastro de Produto 
    Abrir o navegador
    Ir para o site
    Preencher os dados e cadastrar
    Cadastrar Produto
    Conferir produto cadastrado com sucesso
Utilizando Requisições HTTP
    [Tags]    Requisições HTTP
    Abrir o navegador
    Ir para o site
    Criar usuário via API
    Logar com o usuário cadastrado via API
    
