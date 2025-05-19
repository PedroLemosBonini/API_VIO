delimiter //

create procedure registrar_compra(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin
    declare v_id_compra int;

    insert into compra(data_compra, fk_id_usuario)
    values(now(), p_id_usuario);

    set v_id_compra = last_insert_id();

    insert into ingresso_compra(fk_id_compra, fk_id_ingresso, quantidade)
    values(v_id_compra, p_id_ingresso, p_quantidade);

end; //

delimiter ;



delimiter //

create procedure total_ingressos_usuario(
    in p_id_usuario int,
    out p_total_ingressos int
)
begin
    set p_total_ingressos = 0;

    select coalesce(sum(ic.quantidade), 0)
    into p_total_ingressos
    from ingresso_compra ic
    join compra c on ic.fk_id_compra = c.id_compra
    where c.fk_id_usuario = p_id_usuario;

end; //

delimiter ;

show procedure status where db = "vio_bonini";

set @total = 0;

call total_ingressos_usuario(1, @total);



delimiter //

create procedure registrar_presenca(
    in p_id_compra int,
    in p_id_evento int
)
begin
    insert into presenca(data_hora_checkin, fk_id_evento, fk_id_compra)
    values (now(), p_id_evento, p_id_compra);
end; //

delimiter ;


-- procedure para resumo do usuário
delimiter $$

create procedure resumo_usuario(in pid int)
begin
    declare nome varchar(100);
    declare email varchar(100);
    declare totalrs decimal(10,2);
    declare faixa varchar(20);

    -- buscar o nome e o email do usuário
    select u.name, u.email into nome, email
    from usuario u
    where u.id_usuario = pid;

    -- chamada das funções específicas já criadas
    set totalrs = calcula_total_gasto(pid);
    set faixa = buscar_faixa_etaria_usuario(pid);

    -- exibe os dados formatados
    select nome as nome_usuario,
        email as email_usuario,
        totalrs as total_gasto,
        faixa as faixa_etaria;
end; $$
delimiter ;

-- Mostra o nome do evento, a data, o total de ingressos vendidos e a renda total.

delimiter $$

create procedure resumo_evento(in id_evento int)
begin
    declare nome varchar(100);
    declare data_hora date;
    declare total_vendidos int;
    declare renda decimal(10,2);

    select e.nome, e.data_hora into nome, data_hora
    from evento e
    where e.id_evento = id_evento;

    set total_vendidos = total_ingressos_vendidos(id_evento);
    set renda = renda_total_evento(id_evento);

    select coalesce(nome, "Nome não encontrado") as nome_evento,
        coalesce(data_hora, "Horário não encontrado") as data_evento,
        total_vendidos as total_ingressos_vendidos,
        renda as valor_arrecadado;
end; $$
delimiter ;

-- IP: 10.89.240.72