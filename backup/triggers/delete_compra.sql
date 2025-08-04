

DELIMITER //

CREATE TRIGGER trg_after_delete_compra
AFTER DELETE ON compra
FOR EACH ROW
BEGIN 
    INSERT INTO historico_compra(id_compra, data_compra, id_usuario)
    VALUES (OLD.id_compra, OLD.data_compra, OLD.fk_id_usuario);
END; //

DELIMITER ;
