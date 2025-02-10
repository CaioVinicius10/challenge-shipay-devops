# Shipay DevOps Challenge Documentation

1. No path devops/garapua/base-test-api, foi criado o Dockerfile com as instruções necessarias para o funcionanemto da imagem, primeiramente definir a imagem slim do python, para termos uma imagem mais otimizada e menor, criei o path /app, copiei o Pipefile para dentro do container no path criado anteriormente, instalei os pacotes necessarios, depopis adicionei o arquivo .py principal em uma env e adicionei tambem os comandos necessarios para a inicialização da aplicação.

    1.1 Bônus - Foi realizado o build no Github Actions e como eu já estava utilizando a cloud do GCP, eu armazenei a imagem no artifact registry do Google, tambem criei os arquivos de deployment, presente na pasta /devops/k8s,
    para deployar essa imagem no cluster no GCP, vamos rodar os seguintes comandos:

    gcloud auth login
    gcloud container clusters get-credentials CLUSTER-NAME --region REGION --project PROJECT-ID
    kubectl apply -f deployment.yaml


2. Sobre o diagrama criado, eu criei uma VPC, ambos ambientes compartilhando a mesma VPC, porem para não ter comunicação vamos criar 2 regras de firewall, na VPC criada:
 Subnets Criadas na VPC:
 dev - 10.0.2.0/24
 prod - 10.0.1.0/23


    IP's da subnet de dev: Para o CIDR 10.0.2.0/24, nesse range temos 256 IP's disponiveis, ou seja vai atender o ambiente de dev tranquilamente.

    IP's da subnet de prod: Para o CIDR 10.0.1.0/23, nesse range temos 512 IP's disponiveis, ou seja vai atender o ambiente de prod tranquilamente.


    Regra 1 bloquear trafego de dev para prod: Vamos criar uma rule Egress, especificando o CIDR de origem da subrede de development 10.0.2.0/24, para o CIDR de destino que é o de produção 10.0.1.0/23 e vamos definir a action da regra DENY para bloquear todo trafego de development a produção para que não haja comunicação. 

    Regra 2 bloquear trafego de prod para dev: Vamos criar uma rule Egress, especificando o CIDR de origem da subrede de prod 10.0.1.0/23, para o CIDR de destino que é o de development 10.0.2.0/24 e vamos definir a action da regra DENY para bloquear todo trafego de produção a development para que não haja comunicação.

3. No path . github/script, foi criado um script que podemos rodar localmente no S.O Linux ou WSL configurado no windows para validar o funcionamento, nesse script temos 2 variaveis de ambiente 1 origem e outra destino, pois temos o path de origem ou seja aonde vai estar os arquivos.log e o destino que seria o path para onde os arquivos serão movidos.

4. No WSL eu configurei um crontab, ou seja no linux pode ser configurado um crontab e podemos informar o dia, horarios e quantas vezes ao dia esse script será executado, eu fiz um workflow parecido que demonstra melhor o fluxo do script.


BÔNUS: O Cluster foi criado no GKE, serviço do GCP e no pipeline configurei o fluxo de CI/CD, apois o Build a imagem é enviada para o AR serviço do GCP tambem e o deploy é feito com a imagem mais recente enviada, criei um prefixo shipay-sha, é feito uma concatenação com o hash do commit. A aplicação está acessivel pelo link - challenge-devops.shipay.app.br, Criei uma conta no cloudflare e comprei o dominio shipay.app.br, para exemplifiar de maneira mais clara o acesso, e tambem o prorio cert-manager para gerenciar o nosso certificado TLS. Configurei tambem um Issuer que trabalha em conjunto com o cert-manager. Tambem precisei configurar o nginx-controller para trabalhar como loadbalancer. a instalação foi realizada via helmchart tanto do cert-manager e nginx-controller. Optei pelo cert-manager mas podemos usar o prorio serviço de certificado do GCP porem para não ficarmos dependente de um cloud provider é interessante implementarmos via helmchart e configurar de acordo com o cloud provider que será utilizado. Apos se autenticar no cluster, bastou rodar os seguintes comandos: 

    helm repo add jetstack https://charts.jetstack.io
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.12.0
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install ingress-controller ingress-nginx/ingress-nginx -n cert-manager

Vou adicionar umas imagens para um melhor entendimento sobre todos os processos realizados no teste, qualquer duvida fico a disposição.