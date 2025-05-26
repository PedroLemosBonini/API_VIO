delimiter //
CREATE PROCEDURE `registrar_compra`(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin
    declare v_id_compra int;
    declare v_data_evento datetime;
    
    -- obtem a data do evento
    select e.data_hora into v_data_evento
    from ingresso i 
    join evento e on i.fk_id_evento = e.id_evento
    where i.id_ingresso  =  p_id_ingresso;
    
    -- verificar se a data do evento é menor que a atual
    if date(v_data_evento) < curdate() then
        signal sqlstate '45000'
        set message_text = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
    end if;
    
    -- Criar registro na tabela 'compra'
    insert into compra (data_compra, fk_id_usuario)
    values (now(), p_id_usuario);

    -- Obter o ID da compra recém-criada
    set v_id_compra = last_insert_id();

    -- Registrar os ingressos comprados
    insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
        values(v_id_compra, p_id_ingresso, p_quantidade);

end; //

delimiter ; 

delimiter //

    -- in nao modifico só uso como uma referencia 

create procedure total_ingressos_usuario(
    in p_id_usuario int,
    out p_total_ingressos int
)
begin
    -- inicializar o valor de saida
    set p_total_ingressos = 0;

    -- consultar e somar todos os ingressos comprados pelo usuario
    -- se o primeiro valor não for valido ele atribui o 0
    select coalesce(sum(ic.quantidade), 0)
    into p_total_ingressos
    from ingresso_compra ic
    join compra c on ic.fk_id_compra = c.id_compra
    where c.fk_id_usuario = p_id_usuario;


end; //

delimiter ;

set @total = 0;

call total_ingressos_usuario(1, @total);

delimiter //

create procedure registrar_presenca(
    in p_id_compra int,
    in p_id_evento int
)
begin
    -- registrar presenca
    insert into presenca (data_hora_checkin, fk_id_evento, fk_id_compra)
    values (now(), p_id_evento, p_id_compra);

end; //

delimiter ;

insert into evento (nome, data_hora,local, descricao,fk_id_organizador) values
 ('Feira Cultural de Inverno', '2025-07-20', 'Parque Municipal', 'Evento cultural com música e gastronomia.', 1);