-- Exclui o banco de dados devdb se ele já existir
IF DB_ID('devdb') IS NOT NULL
BEGIN
    ALTER DATABASE devdb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE devdb;
END;
GO

-- Cria o banco de dados novamente
CREATE DATABASE devdb;
GO

-- Muda o contexto para o banco de dados devdb
USE devdb;
GO

-- Exclui tabelas se já existirem, removendo constraints de chaves estrangeiras
IF OBJECT_ID('dbo.empresa_grupo_risco', 'U') IS NOT NULL DROP TABLE dbo.empresa_grupo_risco;
IF OBJECT_ID('dbo.utilizador_permissao', 'U') IS NOT NULL DROP TABLE dbo.utilizador_permissao;
IF OBJECT_ID('dbo.login', 'U') IS NOT NULL DROP TABLE dbo.login;
IF OBJECT_ID('dbo.utilizador', 'U') IS NOT NULL DROP TABLE dbo.utilizador;
IF OBJECT_ID('dbo.tipo', 'U') IS NOT NULL DROP TABLE dbo.tipo;
IF OBJECT_ID('dbo.empresa', 'U') IS NOT NULL DROP TABLE dbo.empresa;
IF OBJECT_ID('dbo.grupo_risco', 'U') IS NOT NULL DROP TABLE dbo.grupo_risco;
IF OBJECT_ID('dbo.permissao', 'U') IS NOT NULL DROP TABLE dbo.permissao;
GO

-- Criação das tabelas na ordem correta e com constraints
CREATE TABLE grupo_risco (
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE empresa (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    data_criacao DATETIME2 DEFAULT SYSDATETIME()
);

CREATE TABLE tipo (
    id INT PRIMARY KEY IDENTITY(1,1),
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE utilizador (
    id INT PRIMARY KEY IDENTITY(1,1),
    id_empresa INT NULL,
    id_tipo INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    super_user BIT NOT NULL DEFAULT 0,
    active BIT NOT NULL DEFAULT 1,
    data_criacao DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT fk_utilizador_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id),
    CONSTRAINT fk_utilizador_tipo FOREIGN KEY (id_tipo) REFERENCES tipo(id)
);

CREATE TABLE login (
    id_login INT PRIMARY KEY IDENTITY(1,1),
    id_utilizador INT NOT NULL,
    data_login DATETIMEOFFSET,
    ip_maquina NVARCHAR(39),
    tentativas INT,
    token NVARCHAR(100),
    FOREIGN KEY (id_utilizador) REFERENCES utilizador(id)
);

CREATE TABLE permissao (
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descricao_permissao VARCHAR(100) NOT NULL
);

CREATE TABLE utilizador_permissao (
    id INT PRIMARY KEY IDENTITY(1,1),
    id_utilizador INT NOT NULL,
    id_permissao INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_utilizador_permissao_utilizador FOREIGN KEY (id_utilizador) REFERENCES utilizador(id),
    CONSTRAINT fk_utilizador_permissao_permissao FOREIGN KEY (id_permissao) REFERENCES permissao(id)
);

CREATE TABLE empresa_grupo_risco (
    id INT PRIMARY KEY IDENTITY(1,1),
    id_empresa INT NOT NULL,
    id_grupo_risco INT NOT NULL,
    nome NVARCHAR(240) NULL,
    codigo NVARCHAR(24) NULL,
    period INT NULL,
    period_mcd INT NULL,
    ecd_bianuais INT NULL,
    CONSTRAINT fk_empresa_grupo_risco_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id),
    CONSTRAINT fk_empresa_grupo_risco_grupo_risco FOREIGN KEY (id_grupo_risco) REFERENCES grupo_risco(id)
);
GO


------------------------------DADOS---------------------------------------

USE devdb;
GO

-- Inserindo dados na tabela grupo_risco
INSERT INTO grupo_risco (codigo, nome)
VALUES 
    ('GR001', 'Alto Risco'),
    ('GR002', 'Médio Risco'),
    ('GR003', 'Baixo Risco');
GO

-- Inserindo dados na tabela empresa
INSERT INTO empresa (nome, codigo)
VALUES 
    ('Empresa A', 'EMP001'),
    ('Empresa B', 'EMP002'),
    ('Empresa C', 'EMP003');
GO

-- Inserindo dados na tabela tipo
INSERT INTO tipo (descricao)
VALUES 
    ('myHACCP'),
    ('MT'),
    ('HST');
GO

-- Inserindo dados na tabela utilizador
INSERT INTO utilizador (id_empresa, id_tipo, nome, username, email, senha, super_user, active)
VALUES 
    (1, 1, 'Alice Silva', 'alice.s', 'alice@example.com', 'hashed_password1', 1, 1),
    (2, 2, 'Bruno Santos', 'bruno.s', 'bruno@example.com', 'hashed_password2', 0, 1),
    (3, 3, 'Carla Oliveira', 'carla.o', 'carla@example.com', 'hashed_password3', 0, 0);
GO

-- Inserindo dados na tabela login
INSERT INTO login (id_utilizador, data_login, ip_maquina, tentativas, token)
VALUES 
    (1, SYSDATETIMEOFFSET(), '192.168.1.10', 1, 'token123'),
    (2, SYSDATETIMEOFFSET(), '192.168.1.11', 3, 'token456'),
    (3, SYSDATETIMEOFFSET(), '192.168.1.12', 2, 'token789');
GO

-- Inserindo dados na tabela permissao
INSERT INTO permissao (codigo, descricao_permissao)
VALUES 
    ('PERM001', 'Acesso Total'),
    ('PERM002', 'Acesso Parcial'),
    ('PERM003', 'Acesso Restrito');
GO

-- Inserindo dados na tabela utilizador_permissao
INSERT INTO utilizador_permissao (id_utilizador, id_permissao, active)
VALUES 
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 0);
GO

-- Inserindo dados na tabela empresa_grupo_risco
INSERT INTO empresa_grupo_risco (id_empresa, id_grupo_risco, nome, codigo, period, period_mcd, ecd_bianuais)
VALUES 
    (1, 1, 'Associação 1', 'AGR001', 12, 24, 1),
    (2, 2, 'Associação 2', 'AGR002', 6, 12, 0),
    (3, 3, 'Associação 3', 'AGR003', 3, 6, 1);
GO