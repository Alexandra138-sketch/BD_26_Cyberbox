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

-- ===========================================================
-- 1.1 CRUD UTILIZADORES 
-- ============================================================
--CREATE
CREATE OR REPLACE FUNCTION crud_criar_utilizador(p_nome VARCHAR, p_email VARCHAR, p_password VARCHAR, p_telefone VARCHAR, p_perfil VARCHAR, p_foto VARCHAR) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO utilizadores (nome, email, password, telefone, perfil, foto)
    VALUES (p_nome, p_email, p_password, p_telefone, p_perfil, p_foto) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_utilizador(p_id INT) 
RETURNS TABLE(id INT, nome VARCHAR, email VARCHAR, telefone VARCHAR, perfil VARCHAR, estado VARCHAR, foto VARCHAR) AS $$
BEGIN
    RETURN QUERY SELECT u.id, u.nome, u.email, u.telefone, u.perfil, u.estado, u.foto FROM utilizadores u WHERE u.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_utilizador(p_id INT, p_nome VARCHAR, p_telefone VARCHAR, p_estado VARCHAR, p_foto VARCHAR) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE utilizadores SET nome = p_nome, telefone = p_telefone, estado = p_estado, foto = p_foto, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_utilizador(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM utilizadores WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

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
-- 2.1 CRUD CLIENTES 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_cliente(p_nome VARCHAR, p_email VARCHAR, p_telefone VARCHAR, p_utilizador_id INT, p_gestor_id INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO clientes (nome, email, telefone, utilizador_id, gestor_id)
    VALUES (p_nome, p_email, p_telefone, p_utilizador_id, p_gestor_id) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_cliente(p_id INT) 
RETURNS TABLE(id INT, nome VARCHAR, email VARCHAR, telefone VARCHAR, estado VARCHAR, utilizador_id INT, gestor_id INT) AS $$
BEGIN
    RETURN QUERY SELECT c.id, c.nome, c.email, c.telefone, c.estado, c.utilizador_id, c.gestor_id FROM clientes c WHERE c.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_cliente(p_id INT, p_nome VARCHAR, p_email VARCHAR, p_telefone VARCHAR, p_estado VARCHAR, p_gestor_id INT) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE clientes SET nome = p_nome, email = p_email, telefone = p_telefone, estado = p_estado, gestor_id = p_gestor_id, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_cliente(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM clientes WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

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
-- 3.1 CRUD SERVIÇOS 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_servico(p_titulo VARCHAR, p_descricao TEXT, p_descricao_longa TEXT, p_icone VARCHAR, p_nis2 BOOLEAN) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO servicos (titulo, descricao, descricao_longa, icone, nis2)
    VALUES (p_titulo, p_descricao, p_descricao_longa, p_icone, p_nis2) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_servico(p_id INT) 
RETURNS TABLE(id INT, titulo VARCHAR, descricao TEXT, nis2 BOOLEAN, ativo BOOLEAN) AS $$
BEGIN
    RETURN QUERY SELECT s.id, s.titulo, s.descricao, s.nis2, s.ativo FROM servicos s WHERE s.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_servico(p_id INT, p_titulo VARCHAR, p_descricao TEXT, p_ativo BOOLEAN) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE servicos SET titulo = p_titulo, descricao = p_descricao, ativo = p_ativo, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_servico(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM servicos WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 4. TABELA DE LIGAÇÃO: CLIENTES_SERVICOS 
-- ============================================================
CREATE TABLE clientes_servicos (
    cliente_id INT REFERENCES clientes(id) ON DELETE CASCADE,
    servico_id INT REFERENCES servicos(id) ON DELETE CASCADE,
    PRIMARY KEY (cliente_id, servico_id) -- Chave primária composta
);
-- ============================================================
-- 4.1 CRUD CLIENTES_SERVICOS 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_associar_cliente_servico(p_cliente_id INT, p_servico_id INT) RETURNS VOID AS $$
BEGIN
    INSERT INTO clientes_servicos (cliente_id, servico_id) VALUES (p_cliente_id, p_servico_id);
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_verificar_associacao(p_cliente_id INT, p_servico_id INT) RETURNS BOOLEAN AS $$
DECLARE v_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM clientes_servicos WHERE cliente_id = p_cliente_id AND servico_id = p_servico_id) INTO v_existe;
    RETURN v_existe;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_remover_associacao(p_cliente_id INT, p_servico_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM clientes_servicos WHERE cliente_id = p_cliente_id AND servico_id = p_servico_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;


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
-- 5.1 CRUD DOCUMENTOS 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_documento(p_titulo VARCHAR, p_descricao TEXT, p_tipo VARCHAR, p_ficheiro VARCHAR, p_cliente_id INT, p_criado_por INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO documentos (titulo, descricao, tipo, ficheiro, cliente_id, criado_por)
    VALUES (p_titulo, p_descricao, p_tipo, p_ficheiro, p_cliente_id, p_criado_por) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_documento(p_id INT) 
RETURNS TABLE(id INT, titulo VARCHAR, tipo VARCHAR, estado VARCHAR, cliente_id INT) AS $$
BEGIN
    RETURN QUERY SELECT d.id, d.titulo, d.tipo, d.estado, d.cliente_id FROM documentos d WHERE d.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_documento(p_id INT, p_titulo VARCHAR, p_estado VARCHAR, p_versao VARCHAR) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE documentos SET titulo = p_titulo, estado = p_estado, versao = p_versao, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_documento(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM documentos WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;


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
-- 6.1 CRUD INCIDENTES 
-- ============================================================

-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_incidente(p_titulo VARCHAR, p_descricao TEXT, p_severidade VARCHAR, p_cliente_id INT, p_reportado_por INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO incidentes (titulo, descricao, severidade, cliente_id, reportado_por)
    VALUES (p_titulo, p_descricao, p_severidade, p_cliente_id, p_reportado_por) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_incidente(p_id INT) 
RETURNS TABLE(id INT, titulo VARCHAR, severidade VARCHAR, estado VARCHAR, cliente_id INT, responsavel_id INT) AS $$
BEGIN
    RETURN QUERY SELECT i.id, i.titulo, i.severidade, i.estado, i.cliente_id, i.responsavel_id FROM incidentes i WHERE i.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_incidente(p_id INT, p_estado VARCHAR, p_responsavel_id INT, p_data_resolucao TIMESTAMP) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE incidentes SET estado = p_estado, responsavel_id = p_responsavel_id, data_resolucao = p_data_resolucao, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_incidente(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM incidentes WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

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
-- 7.1 CRUD CATEGORIAS 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_categoria(p_designacao VARCHAR, p_id_admin INT) RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO categorias (designacao, id_admin) VALUES (p_designacao, p_id_admin) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_categoria(p_id INT) RETURNS TABLE(id INT, designacao VARCHAR, id_admin INT) AS $$
BEGIN
    RETURN QUERY SELECT c.id, c.designacao, c.id_admin FROM categorias c WHERE c.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_categoria(p_id INT, p_designacao VARCHAR) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE categorias SET designacao = p_designacao, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_categoria(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM categorias WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;


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
-- 8.1 CRUD TICKETS 
-- ============================================================

-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_ticket(p_assunto VARCHAR, p_descricao TEXT, p_utilizador_id INT, p_categoria_id INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO tickets (assunto, descricao, utilizador_id, categoria_id)
    VALUES (p_assunto, p_descricao, p_utilizador_id, p_categoria_id) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_ticket(p_id INT) 
RETURNS TABLE(id INT, assunto VARCHAR, estado VARCHAR, utilizador_id INT, categoria_id INT) AS $$
BEGIN
    RETURN QUERY SELECT t.id, t.assunto, t.estado, t.utilizador_id, t.categoria_id FROM tickets t WHERE t.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_ticket(p_id INT, p_estado VARCHAR) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE tickets SET estado = p_estado, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_ticket(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM tickets WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;


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
-- 9.1 CRUD CHATS 
-- ============================================================
-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_mensagem(p_conteudo_mensagem TEXT, p_id_remetente INT, p_id_destinatario INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO chats (conteudo_mensagem, id_remetente, id_destinatario)
    VALUES (p_conteudo_mensagem, p_id_remetente, p_id_destinatario) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_mensagem(p_id INT) 
RETURNS TABLE(id INT, conteudo_mensagem TEXT, id_remetente INT, id_destinatario INT, created_at TIMESTAMP) AS $$
BEGIN
    RETURN QUERY SELECT c.id, c.conteudo_mensagem, c.id_remetente, c.id_destinatario, c.created_at FROM chats c WHERE c.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_mensagem(p_id INT, p_conteudo_mensagem TEXT) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE chats SET conteudo_mensagem = p_conteudo_mensagem, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_mensagem(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM chats WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;


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
-- 10.1 CRUD LEMBRETES 
-- ============================================================

-- CREATE
CREATE OR REPLACE FUNCTION crud_criar_lembrete(p_descricao_notificacao TEXT, p_documento_id INT, p_utilizador_id INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
INSERT INTO lembretes (descricao_notificacao, documento_id, utilizador_id)
VALUES (p_descricao_notificacao, p_documento_id, p_utilizador_id) RETURNING id INTO v_id;
RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_lembrete(p_id INT) 
RETURNS TABLE(id INT, descricao_notificacao TEXT, documento_id INT, utilizador_id INT) AS $$
BEGIN
RETURN QUERY SELECT l.id, l.descricao_notificacao, l.documento_id, l.utilizador_id FROM lembretes l WHERE l.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_lembrete(p_id INT, p_descricao_notificacao TEXT) RETURNS BOOLEAN AS $$
BEGIN
UPDATE lembretes SET descricao_notificacao = p_descricao_notificacao, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_lembrete(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
DELETE FROM lembretes WHERE id = p_id;
RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

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
-- 11.1 CRUD REGISTOS DE LOGS 
-- ============================================================

 -- CREATE
CREATE OR REPLACE FUNCTION crud_criar_log(p_acao_efetuada VARCHAR, p_detalhes_auditoria TEXT, p_utilizador_id INT) 
RETURNS INT AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO registos_logs (acao_efetuada, detalhes_auditoria, utilizador_id)
    VALUES (p_acao_efetuada, p_detalhes_auditoria, p_utilizador_id) RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION crud_ler_log(p_id INT) 
RETURNS TABLE(id INT, acao_efetuada VARCHAR, detalhes_auditoria TEXT, utilizador_id INT, created_at TIMESTAMP) AS $$
BEGIN
    RETURN QUERY SELECT r.id, r.acao_efetuada, r.detalhes_auditoria, r.utilizador_id, r.created_at FROM registos_logs r WHERE r.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION crud_atualizar_log(p_id INT, p_acao_efetuada VARCHAR, p_detalhes_auditoria TEXT) 
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE registos_logs SET acao_efetuada = p_acao_efetuada, detalhes_auditoria = p_detalhes_auditoria, updated_at = CURRENT_TIMESTAMP WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION crud_eliminar_log(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM registos_logs WHERE id = p_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;
 
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