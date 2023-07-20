*** Settings ***
Library    Browser
...     enable_presenter_mode=${false}
Library    FakerLibrary    
Library    XML

*** Variables ***
${browser}             chromium 
${headless}            ${false}
${site_server_rest}    https://front.serverest.dev/login
*** Keywords ***

Abrir o navegador
    New Browser    browser=${browser}
    ...            headless=${headless}   

    New Context    viewport={'width': 1200, 'height': 800}

Ir para o site
    New Page        url=${site_server_rest}
    ${title}        Get Title    ==    Front - ServeRest
    Log    ${title} 

Preencher os dados e cadastrar
    ## Record Selector
    Click                css=.btn-link  ## text="Cadastre-se"
    ${email}             FakerLibrary.Email
    Set Test Variable    ${email}  
    Fill Text            css=input[data-testid='nome']        Matherson Antonio
    Fill Text            input[data-testid='email']           ${email} 
    Fill Text            input[data-testid='password']        12345
    Check Checkbox       css=input[data-testid='checkbox']
    Click                css=button[data-testid='cadastrar']
    # Click    xpath=//*[@id="root"]//teste >> text='Cadastrar' 
Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1    visible
    Get Text    h1    ==    Bem Vindo Matherson Antonio
    Get Element States    css=button[data-testid='logout']    validate    value & visible
Conferir usuário na listagem de usuários 
    Click    css=.col-md-2:nth-child(3) .btn
    Wait For Elements State    h1    visible
    ${element}    Get Table Cell Element    css=table    "Nome"    "${email}"
    ${usuario_nome}    Get Text  ${element}    ==    Matherson Antonio
    Highlight Elements    ${element}    
    Take Screenshot    fullPage=${True}

Cadastrar Produto
    Click     css=a[data-testid='cadastrarProdutos']
    Get Text    h1    ==    Cadastro de Produtos
    ${PRODNAME}    FakerLibrary.Word
    ${PRECO}    FakerLibrary.Building Number
    ${DESCRICAO}    FakerLibrary.Text
    Set Test Variable    ${PRODNAME}
    Set Test Variable    ${DESCRICAO}
    Fill Text    css=input[data-testid='nome']    ${PRODNAME}
    Fill Text    css=input[data-testid='preco']    ${PRECO}
    Fill Text    css=textarea[data-testid='descricao']    ${DESCRICAO}
    Fill Text    css=input[data-testid='quantity']    5
    Click        css=button[data-testid='cadastarProdutos']  
    
Conferir produto cadastrado com sucesso
    ${elemento}    Get Table Cell Element    css=table    "Nome"    "${DESCRICAO}"
    ${Nome_produto}    Get Text  ${elemento}    ==    ${PRODNAME}  
    Highlight Elements    ${elemento}    
    Take Screenshot    fullPage=${True}
Criar usuário via API
    ${email}    FakerLibrary.Email
    Set Test Variable    ${email}

    ${respota}    Http    url= https://serverest.dev/usuarios
    ...           method=POST   
    ...           body= {"nome": "Matherson Antonio","email": "${email}","password": "teste123","administrador": "true"}
    Should Be Equal As Integers    ${respota["status"]}    201
Logar com o usuário cadastrado via API
     ${respota}    Http    url= https://serverest.dev/login
    ...           method=POST   
    ...           body= {"email": "${email}","password": "teste123"}
    Should Be Equal As Integers    ${respota["status"]}    200
    LocalStorage Set Item    serverest/userEmail    ${email}
    LocalStorage Set Item    serverest/userToken    ${respota["body"]["authorization"]}  
    LocalStorage Set Item    serverest/userNome     Matherson Antonio


    Go To    url=https://front.serverest.dev/admin/home
    Take Screenshot