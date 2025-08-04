-- Criação de function

delimiter $$

create function calcula_idade(datanascimento date)
returns int
deterministic
reads sql data
begin
    declare idade int;
    set idade = timestampdiff(year, datanascimento, curdate());
    return idade;
end; $$

delimiter ;
-- verifica se a função especificada foi criada

SHOW CREATE FUNCTION calcula_idade;

SELECT name, calcula_idade(data_nascimento) as idade from usuario;



delimiter $$

create function status_sistema()
returns varchar(50)
no sql
begin   
    return 'Sistema operando normalmente';
end; $$
delimiter ;

select status_sistema();


delimiter $$

create function total_compras(id_usuario int)
returns int
reads sql data
begin
    declare total int;

    select count(*)into total
    from compra
    where id_usuario = compra.fk_id_usuario;

    return total;
end; $$
delimiter ;

-- tabela para testar a clausula modifies sql data

create table log_evento(
    id_log int AUTO_INCREMENT PRIMARY KEY,
    mensagem varchar(255),
    data_log datetime DEFAULT current_timestamp
);


delimiter $$
create function registrar_log_evento(texto varchar(255))
returns varchar(50)
not deterministic
modifies sql data
begin 
    insert into log_evento(mensagem)
    values (texto);

    return 'Log inserido com sucesso';

end; $$
delimiter ;


SHOW CREATE FUNCTION registrar_log_evento;

select registrar_log_evento('evento');

show variables like 'log_bin_trst_function_creators';

set global log_bin_trust_function_creators = 1;

-- se eu for alterar ou mexer em conteudo de tabelas eu devo usar procedures

delimiter $$
create function mensagem_boas_vindas(nome_usuario varchar(100))
returns varchar(255)
deterministic
contains sql
begin
    declare msg varchar(255);
    set msg = concat('Olá, ', nome_usuario, '! Seja bem-vindo(a) ao sistema VIO.');

    return msg;
end; $$
delimiter ;

select mensagem_boas_vindas('arthur') as Mensagem_Boas_Vindas;