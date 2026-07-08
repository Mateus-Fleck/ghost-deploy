# WarZ Tech News - Ghost CMS Deployment

## 🚀 Deploy 100% GRÁTIS PARA SEMPRE

Este diretório contém tudo que você precisa para fazer deploy do Ghost CMS **gratuitamente** em múltiplas plataformas.

### 🎯 Opções Disponíveis

| Plataforma | Free Forever? | Setup | Recomendado Para |
|------------|---------------|-------|------------------|
| **Render.com** | ✅ Sim | 10 min | 🏆 Começar rápido |
| **Oracle Cloud** | ✅ Sim | 2-3h | Máxima performance |

**📖 Guia completo:** Veja `/docs/free-forever-deployment.md`

---

## 🎯 OPÇÃO 1: Deploy Rápido - Render.com (RECOMENDADO)

### Por Que Render?

✅ **100% grátis para sempre** (free tier permanente)  
✅ Deploy em **10 minutos**  
✅ SSL automático  
✅ MySQL incluído  
✅ Zero configuração complexa

⚠️ **Nota:** Free tier "dorme" após 15min de inatividade (solução: UptimeRobot grátis)

### Passo a Passo

#### PASSO 1: Preparar Repositório GitHub

```bash
# 1. Crie um novo repositório no GitHub chamado "warztech-ghost"
# Pode ser privado ou público

# 2. Clone este diretório ou inicialize um novo repo
cd ghost-deploy
git init
git add .
git commit -m "Initial Ghost setup for WarZ Tech News"

# 3. Conecte ao seu repositório GitHub
git remote add origin https://github.com/SEU_USUARIO/warztech-ghost.git
git branch -M main
git push -u origin main
```

#### PASSO 2: Deploy no Render

##### 2.1. Criar Conta no Render
```
1. Acesse: https://render.com
2. Click "Get Started for Free"
3. Login com GitHub (autorize acesso aos repositórios)
```

##### 2.2. Deploy usando Blueprint
```
1. No Render Dashboard, click "New +" → "Blueprint"
2. Click "Connect a repository"
3. Selecione o repositório "warztech-ghost"
4. Render detecta automaticamente o render.yaml
5. Revise a configuração:
   ✅ Web Service: warztech-ghost (Docker, Free plan)
   ✅ Database: warztech-db (MySQL, Free plan)
6. Click "Apply"
7. Aguarde deploy (5-10 minutos)
```

##### 2.3. Configurar URL Final

```
Após deploy completo:

1. Acesse: warztech-ghost service → Environment
2. Localize variável "url"
3. Edite para: https://warztech-ghost.onrender.com
   (ou seu custom domain se configurar depois)
4. Salvar → Aguarde redeploy automático (1-2 min)
```

##### 2.4. Acesse Ghost Admin

```
URL: https://warztech-ghost.onrender.com/ghost

Primeira vez:
1. Criar conta admin
2. Configurar site básico
3. Começar a publicar!
```

**✅ PRONTO! Site no ar, 100% grátis para sempre!**

---

## 🎯 OPÇÃO 2: Deploy Railway (Alternativa)

⚠️ **Atenção:** Railway tem limite de 500h/mês no free tier.  
**Recomendamos Render para "free forever".**

### Se preferir Railway:

#### 2.1. Criar Conta no Railway
```
1. Acesse: https://railway.app
2. Click "Login with GitHub"
3. Autorize o Railway a acessar seus repositórios
```

#### 2.2. Criar Novo Projeto
```
1. No Railway Dashboard, click "New Project"
2. Selecione "Deploy from GitHub repo"
3. Escolha o repositório "warztech-ghost"
4. Railway detectará automaticamente o Dockerfile
5. Click "Deploy Now"
```

#### 2.3. Adicionar MySQL Database
```
1. No seu projeto Railway, click "+ New"
2. Selecione "Database"
3. Escolha "Add MySQL"
4. Aguarde o provisionamento (30-60 segundos)
```

#### 2.4. Configurar Variáveis de Ambiente

No serviço Ghost (não no MySQL), adicione estas variáveis:

**Aba "Variables" do serviço Ghost:**

```bash
# URL do site (será gerado automaticamente, mas você pode editar depois)
url = https://${{RAILWAY_STATIC_URL}}

# Database
database__client = mysql
database__connection__host = ${{MySQL.MYSQL_HOST}}
database__connection__port = ${{MySQL.MYSQL_PORT}}
database__connection__user = ${{MySQL.MYSQL_USER}}
database__connection__password = ${{MySQL.MYSQL_PASSWORD}}
database__connection__database = ${{MySQL.MYSQL_DATABASE}}

# Node Environment
NODE_ENV = production
```

**IMPORTANTE:** Railway usa `${{NomeDoServiço.VARIAVEL}}` para referenciar variáveis de outros serviços.

#### 2.5. Deploy!
```
1. Salve as variáveis
2. Railway fará redeploy automaticamente
3. Aguarde 2-3 minutos
4. Seu site estará em: https://seu-projeto.up.railway.app
```

---

## ✅ Configurar Ghost

### 1. Acessar Admin

```
URL: https://seu-projeto.up.railway.app/ghost
```

### 2. Criar Conta Admin

```
1. Preencha:
   - Site title: WarZ Tech News
   - Full name: Seu Nome
   - Email: seu@email.com
   - Password: [senha forte]

2. Click "Create account & start publishing"
```

### 3. Configurações Básicas

```
Settings → General:
- Title: WarZ Tech News
- Description: Revista Digital de Notícias de Tecnologia
- Language: Portuguese (Brazil) ou English
- Timezone: America/Sao_Paulo

Settings → Design:
- Upload logo e ícone (prepararemos depois)
- Escolher tema ou usar Casper padrão
```

---

## 🎨 Customizar Tema (Opcional)

### Tema Básico WarZ

Crie um arquivo `package.json` na pasta `custom-theme/`:

```json
{
  "name": "warztech-theme",
  "version": "1.0.0",
  "engines": {
    "ghost": ">=5.0.0"
  },
  "keywords": [
    "ghost-theme"
  ],
  "config": {
    "posts_per_page": 12
  }
}
```

Depois:
```bash
# Zip o tema
cd custom-theme
zip -r warztech-theme.zip .

# Upload via Ghost Admin → Design → Change theme → Upload
```

---

## 🔧 Configurações Avançadas

### Adicionar Domínio Customizado

**No Railway:**
```
1. Settings → Domains
2. Click "Add Domain"
3. Digite: blog.warztech.news (ou outro)
4. Siga instruções para configurar DNS
```

**No seu DNS Provider:**
```
Tipo: CNAME
Nome: blog (ou www)
Valor: seu-projeto.up.railway.app
TTL: 3600
```

**Atualizar URL no Ghost:**
```
1. No Railway, variável "url"
2. Mude para: https://blog.warztech.news
3. Salve e aguarde redeploy
```

### Configurar Email (Mailgun - Grátis)

**1. Criar conta Mailgun:**
```
https://www.mailgun.com/
- Free tier: 5000 emails/mês
```

**2. Adicionar variáveis no Railway:**
```bash
mail__transport = SMTP
mail__options__service = Mailgun
mail__options__host = smtp.mailgun.org
mail__options__port = 587
mail__options__auth__user = postmaster@warztech.news
mail__options__auth__pass = SUA_SENHA_MAILGUN
```

**3. Testar:**
```
Ghost Admin → Settings → Email
Send test email
```

---

## 🐳 Desenvolvimento Local (Opcional)

### Usando Docker Compose

```bash
# Criar docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  ghost:
    image: ghost:6-alpine
    restart: always
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

# Iniciar
docker-compose up -d

# Acessar: http://localhost:2368
```

---

## 📊 Monitoramento

### Logs no Railway
```
1. Abra seu serviço Ghost no Railway
2. Clique na aba "Logs"
3. Veja logs em tempo real
```

### Métricas
```
1. Railway → Metrics
2. Veja CPU, RAM, Network usage
```

---

## 🔒 Segurança

### Backup Automático (Railway)
```
Railway faz backup automático do database
Retention: 7 dias
```

### Backup Manual
```
Ghost Admin → Labs → Export
Baixe JSON com todo conteúdo
Guarde em local seguro
```

### Atualização do Ghost
```
Railway atualiza automaticamente quando você:
1. Muda a versão no Dockerfile
2. Faz push para o GitHub
3. Railway detecta e redeploy
```

---

## 🆘 Troubleshooting

### Site não abre após deploy
```
Verifique:
1. Logs no Railway (procure por erros)
2. Variáveis de ambiente (todas corretas?)
3. MySQL está rodando? (deve estar "Active")
4. URL está correta na variável "url"?
```

### Erro de database
```
1. Verifique conexão MySQL
2. Teste variáveis:
   - ${{MySQL.MYSQL_HOST}} está resolvendo?
   - Password está correta?
3. Tente redeployar o MySQL
```

### Site lento
```
Railway free tier tem limitações:
- Shared resources
- Pode "dormir" após inatividade

Solução:
- Upgrade para plano pago ($5/mês)
- Ou migrar para Oracle Cloud (grátis, mas mais complexo)
```

---

## 💰 Custos

### Railway Free Tier
```
✅ Grátis até 500h/mês
✅ $5 de crédito inicial
✅ MySQL incluído
✅ SSL automático

Após 500h:
→ ~$5-10/mês
```

### Quando migrar?
```
Considere Oracle Cloud (grátis) quando:
- > 1000 visitantes/dia
- > 100 artigos publicados
- Receita > $100/mês
```

---

## 📚 Próximos Passos

Após deploy bem-sucedido:

1. ✅ **Configurar Ghost**
   - Criar conta admin
   - Configurar básico

2. ✅ **Criar Conteúdo**
   - Primeiro post de teste
   - Configurar tags

3. ✅ **Customizar Design**
   - Logo e ícone
   - Cores (vermelho WarZ)
   - Tema custom

4. ✅ **Configurar Newsletter**
   - Mailgun setup
   - Testar envio

5. ✅ **Integrar Analytics**
   - Google Analytics 4
   - Plausible (privacy-focused)

6. ✅ **SEO Básico**
   - Meta descriptions
   - Social cards
   - Sitemap

7. ✅ **Deploy Middleware**
   - Seguir guia em `/middleware`
   - Integrar AI pipeline

---

## 📚 Recursos

### Guias Completos

- 📘 **Deploy 100% Grátis:** `/docs/free-forever-deployment.md`
- 📘 **Migração Railway → Render:** `/docs/migration-railway-to-render.md`
- 📘 **Quick Start Geral:** `/QUICK-START.md`

### Documentação Oficial
- Ghost: https://ghost.org/docs/
- Render: https://render.com/docs/
- Railway: https://docs.railway.app/
- Oracle Cloud: https://docs.oracle.com/en-us/iaas/
- Mailgun: https://documentation.mailgun.com/

### Comunidade
- Ghost Forum: https://forum.ghost.org/
- Render Community: https://community.render.com/
- Render Discord: https://discord.gg/render
- Railway Discord: https://discord.gg/railway

### Ferramentas Úteis

**Monitoramento (Grátis):**
- UptimeRobot: https://uptimerobot.com/ - Evita "sleep" no Render

**CDN (Grátis):**
- Cloudflare: https://cloudflare.com/ - CDN + DDoS protection

**Email (Grátis):**
- Mailgun: https://mailgun.com/ - 5k emails/mês
- SendGrid: https://sendgrid.com/ - 100 emails/dia
- Resend: https://resend.com/ - 3k emails/mês

**Analytics (Grátis):**
- Google Analytics 4: https://analytics.google.com/
- Plausible (self-hosted): https://plausible.io/
- Umami (self-hosted): https://umami.is/

**Imagens (Grátis):**
- ImageKit: https://imagekit.io/ - 20GB/mês
- Cloudinary: https://cloudinary.com/ - 25 créditos/mês
- TinyPNG: https://tinypng.com/ - Comprimir antes upload

### Suporte
- Email: tech@warztech.news
- Docs: `/docs/`
- Issues: GitHub Issues do projeto

---

## 💰 Comparação de Custos

### Render.com (Recomendado)
```
Ano 1: $0
Ano 2: $0
Ano 3: $0
...
Para sempre: $0 🎉
```

### Railway
```
Mês 1-2: $0 (até 500h)
Mês 3+: ~$5-10/mês
Ano 1: ~$50-100
```

### Oracle Cloud Always Free
```
Ano 1: $0
Ano 2: $0
...
Para sempre: $0 🎉
(Mas setup complexo: 2-3 horas)
```

**Conclusão:** Render = Melhor custo-benefício (grátis + fácil)

---

## ✨ Pronto!

Seu Ghost está no ar! 🎉

Agora você pode:
- Começar a publicar conteúdo
- Desenvolver o middleware de AI
- Criar os Weekly Reports
- Construir audiência

**Próximo arquivo a revisar:**
`/middleware/README.md` - Setup do pipeline de AI

---

**Versão:** 1.0  
**Última atualização:** Dezembro 2025  
**Mantido por:** WarZ Tech Team
