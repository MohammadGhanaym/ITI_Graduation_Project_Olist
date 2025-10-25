IF OBJECT_ID('dbo.brazilian_federative_units', 'U') IS NOT NULL
    DROP TABLE brazilian_federative_units
CREATE TABLE brazilian_federative_units (
    id INT PRIMARY KEY IDENTITY(1, 1),
    name NVARCHAR(255) NOT NULL,
    abbreviation NVARCHAR(255) NOT NULL UNIQUE,
);
CREATE INDEX idx_abbreviation ON brazilian_federative_units(abbreviation);

INSERT INTO brazilian_federative_units (name, abbreviation) VALUES
('Acre', 'AC'),
('Alagoas', 'AL'),
('Amap�', 'AP'),
('Amazonas', 'AM'),
('Bahia', 'BA'),
('Cear�', 'CE'),
('Distrito Federal', 'DF'),
('Esp�rito Santo', 'ES'),
('Goi�s', 'GO'),
('Maranh�o', 'MA'),
('Mato Grosso', 'MT'),
('Mato Grosso do Sul', 'MS'),
('Minas Gerais', 'MG'),
('Par�', 'PA'),
('Para�ba', 'PB'),
('Paran�', 'PR'),
('Pernambuco', 'PE'),
('Piau�', 'PI'),
('Rio de Janeiro', 'RJ'),
('Rio Grande do Norte', 'RN'),
('Rio Grande do Sul', 'RS'),
('Rond�nia', 'RO'),
('Roraima', 'RR'),
('Santa Catarina', 'SC'),
('S�o Paulo', 'SP'),
('Sergipe', 'SE'),
('Tocantins', 'TO');

SELECT * FROM brazilian_federative_units