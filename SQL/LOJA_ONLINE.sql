CREATE DATABASE LOJA_ONLINE;
USE LOJA_ONLINE;

-- =========================
-- CLIENTE
-- =========================
CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    senha VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_cliente)
);

-- =========================
-- CATEGORIA
-- =========================
CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,

    PRIMARY KEY (id_categoria)
);

-- =========================
-- ENDERECO
-- =========================
CREATE TABLE ENDERECO (
    id_endereco INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,

    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    pais VARCHAR(50) DEFAULT 'Angola',

    PRIMARY KEY (id_endereco),

    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente)
);

-- =========================
-- PRODUTO
-- =========================
CREATE TABLE PRODUTO (
    id_produto INT AUTO_INCREMENT,
    id_categoria INT NOT NULL,

    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    imagem VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_produto),

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria)
);

-- =========================
-- PEDIDO
-- =========================
CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_endereco INT NOT NULL,

    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    status ENUM(
        'Em Processamento',
        'Enviado',
        'Entregue',
        'Cancelado'
    ) DEFAULT 'Em Processamento',

    valor_total DECIMAL(10,2) NOT NULL,
    observacao TEXT,

    PRIMARY KEY (id_pedido),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente),

    CONSTRAINT fk_pedido_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES ENDERECO(id_endereco)
);

-- =========================
-- ITEM_PEDIDO
-- =========================
CREATE TABLE ITEM_PEDIDO (
    id_item INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,

    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_item),

    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido),

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES PRODUTO(id_produto)
);

-- =========================
-- PAGAMENTO
-- =========================
CREATE TABLE PAGAMENTO (
    id_pagamento INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,

    metodo_pagamento ENUM(
        'REFERENCIA',
        'MULTICAIXA EXPRESS',
        'TRANSFERENCIA BANCARIA'
    ) NOT NULL,

    valor_pago DECIMAL(10,2) NOT NULL,

    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    status_pagamento ENUM(
        'PAGO',
        'NAO PAGO'
    ) DEFAULT 'NAO PAGO',

    PRIMARY KEY (id_pagamento),

    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido)
);

-- =========================
-- ENTREGA
-- =========================
CREATE TABLE ENTREGA (
    id_entrega INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,

    transportadora VARCHAR(100),
    codigo_rastreamento VARCHAR(50),

    data_envio TIMESTAMP NULL,
    data_entrega TIMESTAMP NULL,

    status_entrega ENUM(
        'A Caminho',
        'Entregue',
        'Nao Entregue'
    ) DEFAULT 'A Caminho',

    PRIMARY KEY (id_entrega),

    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido)
);



INSERT INTO CLIENTE (
    nome,
    sobrenome,
    email,
    telefone,
    senha,
    data_nascimento
)
VALUES (
    'João',
    'Silva',
    'joao@email.com',
    '923456789',
    '123456',
    '2002-05-10'
);


INSERT INTO CATEGORIA (
    nome,
    descricao
)
VALUES (
    'Eletrônicos',
    'Produtos eletrônicos'
);

INSERT INTO ENDERECO (
    id_cliente,
    rua,
    numero,
    bairro,
    cidade,
    provincia,
    codigo_postal
)
VALUES (
    1,
    'Rua da Independência',
    '25',
    'Maianga',
    'Luanda',
    'Luanda',
    '1000'
);

INSERT INTO PRODUTO (
    id_categoria,
    nome,
    descricao,
    preco,
    estoque
)
VALUES (
    1,
    'Mouse Gamer',
    'Mouse RGB',
    15000.00,
    20
);


INSERT INTO PEDIDO (
    id_cliente,
    id_endereco,
    valor_total,
    observacao
)
VALUES (
    1,
    1,
    15000.00,
    'Entrega rápida'
);

INSERT INTO ITEM_PEDIDO (
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    subtotal
)
VALUES (
    1,
    1,
    1,
    15000.00,
    15000.00
);


INSERT INTO PAGAMENTO (
    id_pedido,
    metodo_pagamento,
    valor_pago,
    status_pagamento
)
VALUES (
    1,
    'MULTICAIXA EXPRESS',
    15000.00,
    'PAGO'
);

INSERT INTO ENTREGA (
    id_pedido,
    transportadora,
    codigo_rastreamento,
    status_entrega
)
VALUES (
    1,
    'DHL',
    'ANG123456',
    'A Caminho'
);

SELECT * FROM CLIENTE;
SELECT * FROM CATEGORIA;
SELECT * FROM ENDERECO;
SELECT * FROM PRODUTO;
SELECT * FROM PEDIDO;
SELECT * FROM ITEM_PEDIDO;
SELECT * FROM PAGAMENTO;
SELECT * FROM ENTREGA;

SELECT
    c.nome AS cliente,
    p.id_pedido,
    pr.nome AS produto,
    ip.quantidade,
    pa.metodo_pagamento,
    e.status_entrega
FROM PEDIDO p
JOIN CLIENTE c
    ON p.id_cliente = c.id_cliente
JOIN ITEM_PEDIDO ip
    ON p.id_pedido = ip.id_pedido
JOIN PRODUTO pr
    ON ip.id_produto = pr.id_produto
JOIN PAGAMENTO pa
    ON p.id_pedido = pa.id_pedido
JOIN ENTREGA e
    ON p.id_pedido = e.id_pedido;

