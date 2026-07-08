# Ghost CMS Deployment

## 🚀 Deploy 100% Grátis (Render + Aiven + Brevo)

Este diretório contém a configuração para hospedar uma instância do Ghost CMS
usando apenas serviços com camada gratuita permanente, sem custo mensal.

### 🎯 Arquitetura

| Componente | Serviço | Por quê |
|------------|---------|---------|
| **App (Ghost)** | Render.com (Web Service, free) | Deploy direto do GitHub, SSL automático |
| **Banco de dados** | Aiven for MySQL (free tier) | Render não oferece MySQL gerenciado, só Postgres, e o Ghost exige MySQL 8 em produção |
| **Email transacional** | Brevo (SMTP, free tier) | Render free bloqueia as portas SMTP padrão (25/465/587); Brevo suporta a porta alternativa 2525 |

⚠️ **Nota sobre free tiers:** nenhum provedor garante "grátis para sempre" por contrato — são cortesias que podem mudar. Trate como "grátis enquanto durar" e mantenha backups do conteúdo fora da plataforma.

⚠️ **Nota sobre o Render free:** o serviço "dorme" após ~15 min de inatividade (primeira requisição depois disso leva 30-60s para responder). Use um serviço de ping como o UptimeRobot (grátis) se quiser evitar isso.

---

## 📋 Passo a Passo

### 1. Banco de dados (Aiven MySQL)

```
1. Acesse aiven.io e crie uma conta (sem cartão de crédito)
2. Create service → MySQL → Service tier: Free
3. Aguarde o status mudar para "Running"
4. Na aba Overview, copie: host, port, user (avnadmin), password, database
```

### 2. Email transacional (Brevo)

```
1. Acesse brevo.com e crie uma conta (sem cartão de crédito)
2. Vá em Transacional → SMTP
3. Copie: servidor SMTP, login e chave SMTP (gere uma nova se necessário)
4. Use a porta 2525 (não a 587 mostrada por padrão — o Render free bloqueia 587)
```

### 3. Deploy no Render

```
1. Acesse render.com e crie uma conta
2. New + → Web Service
3. Conecte o repositório deste projeto
4. Runtime: Docker (usa o Dockerfile deste diretório)
5. Plan: Free
6. Create Web Service
```

Se o repositório for privado, confirme que o GitHub App do Render tem
permissão para acessá-lo em `github.com/settings/installations` → Render →
Configure → Repository access.

### 4. Variáveis de ambiente no Render

Na aba **Environment** do serviço, adicione:

```bash
# Node
NODE_ENV=production

# URL pública (o domínio *.onrender.com gerado pelo Render após o deploy)
url=https://SEU-SERVICO.onrender.com

# Banco de dados (Aiven MySQL)
database__client=mysql
database__connection__host=SEU_HOST.aivencloud.com
database__connection__port=SUA_PORTA
database__connection__user=avnadmin
database__connection__password=SUA_SENHA
database__connection__database=defaultdb
database__connection__ssl__rejectUnauthorized=false

# Email transacional (Brevo)
mail__transport=SMTP
mail__from=Seu Nome <seu-email@exemplo.com>
mail__options__host=smtp-relay.brevo.com
mail__options__port=2525
mail__options__secure=false
mail__options__auth__user=SEU_LOGIN_SMTP_BREVO
mail__options__auth__pass=SUA_CHAVE_SMTP_BREVO
```

Salve e aguarde o redeploy automático (1-2 min).

### 5. Acessar o Ghost Admin

```
URL: https://SEU-SERVICO.onrender.com/ghost

Primeira vez:
1. Criar conta admin
2. Configurar título, descrição e timezone do site
3. Começar a publicar
```

---

## 🔧 Configurações Adicionais

### Domínio customizado

```
Render → Settings → Custom Domain → adicione seu domínio
Configure o CNAME indicado no seu provedor de DNS
Depois, atualize a variável "url" para o novo domínio e aguarde redeploy
```

### Manter o serviço sempre acordado

```
UptimeRobot (grátis): configure um monitor HTTP(s) apontando para
https://SEU-SERVICO.onrender.com com intervalo de 5-10 minutos.
```

### Backup de conteúdo

```
Ghost Admin → Settings → Labs → Export
Baixe o JSON periodicamente e guarde em local seguro (fora da Aiven/Render).
```

### Desenvolvimento local (opcional)

```bash
docker compose -f - up <<'EOF'
version: '3.8'
services:
  ghost:
    image: ghost:6-alpine
    ports:
      - "2368:2368"
    environment:
      url: http://localhost:2368
      database__client: sqlite3
      database__connection__filename: /var/lib/ghost/content/data/ghost.db
      NODE_ENV: development
    volumes:
      - ghost-data:/var/lib/ghost/content
volumes:
  ghost-data:
EOF
```

Acesse em `http://localhost:2368`.

---

## 🆘 Troubleshooting

**Site não abre / erro de porta no deploy**
Geralmente transitório em free tier (recursos compartilhados). Veja os logs em
Render → Logs. Se persistir, tente um novo deploy manual.

**"Error establishing database connection"**
Verifique se o serviço MySQL no Aiven está com status "Running" (serviços free
podem ser suspensos por inatividade — basta religar no painel).

**"Failed to send email" / "Authentication failed" no envio de email**
Confirme usuário e senha SMTP do Brevo, e que a porta configurada é 2525.
Contas muito recentes no Brevo podem levar alguns minutos para serem
totalmente ativadas.

**Imagens desaparecem depois de um tempo**
O Render free não oferece disco persistente — qualquer arquivo enviado pelo
Ghost Admin (capa de post, logo) é perdido quando o serviço reinicia. Para
resolver de forma definitiva, configure um storage adapter S3-compatível
(ex: Cloudflare R2) para o Ghost.

---

## 📚 Referências

- [Deploy Ghost – Render Docs](https://render.com/docs/deploy-ghost)
- [Aiven for MySQL free tier](https://aiven.io/docs/products/mysql/concepts/mysql-free-tier)
- [Brevo SMTP relay](https://help.brevo.com/hc/en-us/articles/7924908994450-Send-transactional-emails-using-Brevo-SMTP)
- [Ghost configuration docs](https://ghost.org/docs/config/)
- [Supported databases (Ghost)](https://docs.ghost.org/faq/supported-databases)
