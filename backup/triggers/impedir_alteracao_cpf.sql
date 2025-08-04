DELIMITER //

CREATE TRIGGER impedir_alteracao_cpf
BEFORE UPDATE ON usuario
FOR EACH ROW
BEGIN
    IF OLD.cpf <> NEW.cpf THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido alterar o cpf de um usuario já cadastrado';
    END IF;
END;
//

DELIMITER ;

update usuario 
set cpf = '16000000000'
where id_usuario = 1;


create table historico_compra(
    id_historico int auto_increment primary key,
    id_compra int not null,
    data_compra datetime not null,
    id_usuario int not null, 
    data_exclusao datetime default current_timestamp
);

