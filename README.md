# README

TODO 
	Aicionar devise_token_auth framework para controle de acesso

OBS
    Utilizei as rotas default por uma questão de tempo
    Utilizei um modelo mais simples por uma questão de tempo
    Primeira ideia do modelo na pasta docs


 CONFIGURAÇÃO
 	Modiicar o arquivo database.yml
 	Rodar o comando rake db:create; rake db:migrate

 PARA RODAR OS TESTES
 	Rodar o comando bundle exec rspec


Url's e payloads:


Transferência:
POST /transactions
{ 
  amount: 10, 
  credited_account_id: 1 
  debited_account_id: 1
}

Aporte:
POST /transactions
{ 
  amount: 10, 
  credited_account_id: 1
}

Busca por transferências:
GET /transactions?start_date=XXX&end_date=YYYY
GET /transactions


Estornar:
PUT /transactions/:id
{ 
  reversed: true
}




