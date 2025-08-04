delimiter //

create trigger impedir_alteracao_evento_passado
before update on evento
for each row 
begin 
    if old.data_hora < curdate() then
        signal sqlstate '45000'
        set message_text = 'Não é permitido alterar eventos que ocorreram.';
    end if;
end;//

delimiter ; 

update evento set local = "Novo" where nome = 'Congresso de Tecnologia';

update evento set local = "Teatro Central" where nome = 'Feira Cultural de Inverno';