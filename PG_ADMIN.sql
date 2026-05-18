-- ============================================================
-- BASE DE DADOS: Sistema de Gestão de Cibersegurança
-- Motor: PostgreSQL
-- ============================================================


-- ============================================================
-- 1. UTILIZADORES 
-- ============================================================
CREATE TABLE utilizadores (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    telefone    VARCHAR(50),
    perfil      VARCHAR(20)  NOT NULL DEFAULT 'empresa',
    estado      VARCHAR(20)  DEFAULT 'Ativo',
    foto        VARCHAR(255),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Restrições CHECK como dado na Aula 5
    CONSTRAINT chk_perfil_utilizador CHECK (perfil IN ('admin', 'gestor', 'empresa')),
    CONSTRAINT chk_estado_utilizador CHECK (estado IN ('Ativo', 'Inativo'))
);


-- ============================================================
-- 2. CLIENTES 
-- ============================================================
CREATE TABLE clientes (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    telefone      VARCHAR(50),
    estado        VARCHAR(20)  DEFAULT 'Ativo',
    utilizador_id INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    gestor_id     INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_estado_cliente CHECK (estado IN ('Ativo', 'Inativo'))
);


-- ============================================================
-- 3. SERVIÇOS 
-- ============================================================
CREATE TABLE servicos (
    id              SERIAL PRIMARY KEY,
    titulo          VARCHAR(150) NOT NULL,
    descricao       TEXT         NOT NULL,
    descricao_longa TEXT,
    icone           VARCHAR(100),
    nis2            BOOLEAN      DEFAULT FALSE,
    ativo           BOOLEAN      DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. TABELA DE LIGAÇÃO: CLIENTES_SERVICOS 
-- ============================================================
CREATE TABLE clientes_servicos (
    cliente_id INT REFERENCES clientes(id) ON DELETE CASCADE,
    servico_id INT REFERENCES servicos(id) ON DELETE CASCADE,
    PRIMARY KEY (cliente_id, servico_id) -- Chave primária composta
);


-- ============================================================
-- 5. DOCUMENTOS 
-- ============================================================
CREATE TABLE documentos (
    id         SERIAL PRIMARY KEY,
    titulo     VARCHAR(200) NOT NULL,
    descricao  TEXT,
    tipo       VARCHAR(50)  NOT NULL,
    versao     VARCHAR(20)  DEFAULT 'v1.0',
    estado     VARCHAR(30)  DEFAULT 'Ativo',
    ficheiro   VARCHAR(255),
    tamanho    VARCHAR(50),
    cliente_id INT REFERENCES clientes(id) ON DELETE SET NULL,
    criado_por INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_tipo_documento CHECK (tipo IN ('Política', 'Pentest', 'Auditoria', 'Contrato', 'Relatório')),
    CONSTRAINT chk_estado_documento CHECK (estado IN ('Ativo', 'Em Revisão', 'Expirado'))
);


-- ============================================================
-- 6. INCIDENTES 
-- ============================================================
CREATE TABLE incidentes (
    id              SERIAL PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    descricao       TEXT,
    severidade      VARCHAR(20)  NOT NULL,
    estado          VARCHAR(30)  DEFAULT 'Aberto',
    nis2_notificado BOOLEAN      DEFAULT FALSE,
    cliente_id      INT REFERENCES clientes(id) ON DELETE SET NULL,
    reportado_por   INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    responsavel_id  INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    data_resolucao  TIMESTAMP,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_severidade_incidente CHECK (severidade IN ('Crítico', 'Alto', 'Médio', 'Baixo')),
    CONSTRAINT chk_estado_incidente CHECK (estado IN ('Aberto', 'A Investigar', 'Resolvido', 'Fechado'))
);


-- ============================================================
-- 7. CATEGORIAS 
-- ============================================================
CREATE TABLE categorias (
    id         SERIAL PRIMARY KEY,
    designacao VARCHAR(100) NOT NULL,
    id_admin   INT REFERENCES utilizadores(id) ON DELETE RESTRICT,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 8. TICKETS 
-- ============================================================
CREATE TABLE tickets (
    id           SERIAL PRIMARY KEY,
    assunto      VARCHAR(255) NOT NULL,
    descricao    TEXT         NOT NULL,
    estado       VARCHAR(30)  DEFAULT 'em analise',
    utilizador_id INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    categoria_id INT REFERENCES categorias(id) ON DELETE SET NULL,
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_estado_ticket CHECK (estado IN ('em revisao', 'em analise', 'resolvido', 'fechado'))
);


-- ============================================================
-- 9. CHATS 
-- ============================================================
CREATE TABLE chats (
    id                SERIAL PRIMARY KEY,
    conteudo_mensagem TEXT      NOT NULL,
    id_remetente      INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    id_destinatario   INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 10. LEMBRETES 
-- ============================================================
CREATE TABLE lembretes (
    id                    SERIAL PRIMARY KEY,
    descricao_notificacao TEXT      NOT NULL,
    documento_id          INT REFERENCES documentos(id) ON DELETE CASCADE,
    utilizador_id         INT REFERENCES utilizadores(id) ON DELETE CASCADE NOT NULL,
    created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 11. REGISTOS DE LOGS 
-- ============================================================
CREATE TABLE registos_logs (
    id                 SERIAL PRIMARY KEY,
    acao_efetuada      VARCHAR(255) NOT NULL,
    detalhes_auditoria TEXT,
    utilizador_id      INT REFERENCES utilizadores(id) ON DELETE SET NULL,
    created_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ÍNDICES 
-- ============================================================
CREATE INDEX idx_utilizadores_email    ON utilizadores(email);
CREATE INDEX idx_utilizadores_perfil   ON utilizadores(perfil);
CREATE INDEX idx_clientes_gestor       ON clientes(gestor_id);
CREATE INDEX idx_documentos_cliente    ON documentos(cliente_id);
CREATE INDEX idx_documentos_estado     ON documentos(estado);
CREATE INDEX idx_incidentes_cliente    ON incidentes(cliente_id);
CREATE INDEX idx_incidentes_estado     ON incidentes(estado);
CREATE INDEX idx_incidentes_severidade ON incidentes(severidade);
CREATE INDEX idx_logs_utilizador       ON registos_logs(utilizador_id);
CREATE INDEX idx_logs_createdat        ON registos_logs(created_at);


-- ============================================================
-- DADOS DE SEED 
-- ============================================================
INSERT INTO utilizadores (nome, email, password, telefone, perfil, estado) VALUES
('Administrador Sistema', 'admin@cybergest.pt',   'hash_admin',   '910000001', 'admin',   'Ativo'),
('Gestor Demo',           'gestor@cybergest.pt',  'hash_gestor',  '920000002', 'gestor',  'Ativo'),
('Empresa Demo',          'empresa@cybergest.pt', 'hash_empresa', '930000003', 'empresa', 'Ativo');

INSERT INTO clientes (nome, email, telefone, estado, utilizador_id, gestor_id) VALUES
('TechCorp Portugal',  'geral@techcorp.pt',  '211000001', 'Ativo', 3, 2),
('Viseu IT Solutions', 'info@viseuIT.pt',    '232000002', 'Ativo', NULL, 2);

INSERT INTO servicos (titulo, descricao, descricao_longa, nis2, ativo) VALUES
('Pentest',                'Testes de intrusão.', 'Realizamos testes de penetração.', FALSE, TRUE),
('Gestão de Incidentes',   'Resposta a incidentes.', 'Monitorizamos 24/7.', TRUE,  TRUE),
('Conformidade NIS2',      'Apoio à Diretiva NIS2.', 'Auditoria NIS2.', TRUE,  TRUE);

-- Exemplo de associação na tabela Muitos-para-Muitos (Aula 6)
INSERT INTO clientes_servicos (cliente_id, servico_id) VALUES 
(1, 1), -- TechCorp tem Pentest
(1, 2), -- TechCorp tem Gestão de Incidentes
(2, 3); -- Viseu IT tem Conformidade NIS2

INSERT INTO categorias (designacao, id_admin) VALUES
('Gestão de Acessos',     1),
('Auditoria e Segurança', 1);

INSERT INTO documentos (titulo, descricao, tipo, versao, estado, cliente_id, criado_por) VALUES
('Política de Segurança 2025',   'Política interna.', 'Política',  'v2.0', 'Ativo', 1, 2);

INSERT INTO incidentes (titulo, descricao, severidade, estado, nis2_notificado, cliente_id, reportado_por, responsavel_id) VALUES
('Tentativa de acesso não autorizado', 'Ataque força bruta.', 'Alto', 'A Investigar', FALSE, 1, 3, 2);

INSERT INTO registos_logs (acao_efetuada, detalhes_auditoria, utilizador_id) VALUES
('Login efetuado', 'Login com sucesso.', 1);