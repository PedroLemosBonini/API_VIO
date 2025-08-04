const connect = require("../db/connect");

module.exports = class eventoController {
  // criação de um evento
  static async createEvento(req, res) {
    const { nome, descricao, data_hora, local, fk_id_organizador } = req.body;

    // validação genérica de todos os atributos
    if (!nome || !descricao || !data_hora || !local || !fk_id_organizador) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    }

    const query = `insert into evento (nome, descricao, data_hora, local, fk_id_organizador) values (?, ?, ?, ?, ?)`; //placeholder, transiçao entre os dados que chegam
    const values = [nome, descricao, data_hora, local, fk_id_organizador];
    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(400).json({ error: "Erro ao criar o evento!" });
        }
        return res.status(201).json({ message: "Evento criado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao executar consulta");
      return res.status(500).json({ erro: "Erro interno do servidor" });
    }
  } //fechamento do create

  // Visualizar todos os eventos
  static async getAllEventos(req, res) {
    const query = `select * from evento`;
    try {
      connect.query(query, (err, results) => {
        if (err) {
          //err é do banco de dados
          console.log(err);
          return res.status(500).json({ error: "Erro ao buscar eventos" });
        }
        return res
          .status(200)
          .json({ message: "Listando todos os eventos", events: results });
      });
    } catch (error) {
      //error é do js
      console.log("Erro ao executar a query:", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  } //fim do get

  //update de um evento
  static async updateEvento(req, res) {
    const { id_evento, nome, descricao, data_hora, local, fk_id_organizador } =
      req.body;

    // validação genérica de todos os atributos
    if (
      !id_evento ||
      !nome ||
      !descricao ||
      !data_hora ||
      !local ||
      !fk_id_organizador
    ) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    }

    const query = `update evento set nome=? , descricao=?, data_hora=?, local=?, fk_id_organizador=? where id_evento=?`; //placeholder, transiçao entre os dados que chegam
    const values = [
      nome,
      descricao,
      data_hora,
      local,
      fk_id_organizador,
      id_evento,
    ];
    try {
      connect.query(query, values, (err, results) => {
        console.log("Resultados:", results);
        if (err) {
          console.log(err);
          return res.status(400).json({ error: "Erro ao atualizar o evento!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Evento não encontrado" });
        }
        return res
          .status(200)
          .json({ message: "Evento atualizado com sucesso!" });
      });
    } catch (error) {
      return res.status(500).json({ erro: "Erro interno do servidor" });
    }
  } //fim do update

  static async deleteEvento(req, res) {
    const IdEvento = req.params.id; //é o mesmo que passo nas rotas
    const query = `delete from evento where id_evento=?`;

    try {
      connect.query(query, IdEvento, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao excluir evento!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Evento não encontrado!" });
        }
        return res
          .status(200)
          .json({ message: "Evento excluído com sucesso!" });
      });
    } catch (error) {
      if (error) {
        console.log("Erro ao executar a consulta", error);
        return res.status(500).json({ error: "Erro interno do servidor" });
      }
    }
  }

  static async getEventosPorData(req, res) {
    const query = `SELECT * FROM evento`;

    try {
      connect.query(query, (err, results) => {
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Erro ao buscar eventos" });
        }
        const dataEvento = new Date(results[0].data_hora);
        const dia = dataEvento.getDate();
        const mes = dataEvento.getMonth() + 1; //janeiro é 0 e dezembro é 11 tenho que somar mais 1
        const ano = dataEvento.getFullYear();
        console.log(dia + "/" + mes + "/" + ano);

        const now = new Date();
        const eventosPassados = results.filter(
          (evento) => new Date(evento.data_hora) < now
        );
        const eventosFuturos = results.filter(
          (evento) => new Date(evento.data_hora) >= now
        );

        const diferencaMs =
          eventosFuturos[0].data_hora.getTime() - now.getTime();
        const dias = Math.floor(diferencaMs / (1000 * 60 * 60 * 24)); // 1000 por causa do mls, 60 seg, 60 min, 24 hr, vira um dia
        const horas = Math.floor(
          (diferencaMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
        );
        console.log(
          diferencaMs,
          "Falta:" + dias + " dias e " + horas + " horas"
        );

        // Comparando datas
        const dataFiltro = new Date("2024-12-15").toISOString().split("T");
        const eventosDia = results.filter(
          (evento) =>
            new Date(evento.data_hora).toISOString().split("T")[0] ===
            dataFiltro[0]
        ); // cada registro do results eu chamo de evento

        console.log("Eventos: ", eventosDia);

        return res
          .status(200)
          .json({ message: "OK", eventosPassados, eventosFuturos });
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Erro ao buscar eventos" });
    }
  }
  static async getEventosSemana(req, res) {
    let diaInicio = req.params.data;
    diaInicio = new Date(diaInicio).toISOString().split("T")[0];
    const query = `SELECT * FROM evento WHERE TIMESTAMPDIFF(DAY, ?, data_hora) BETWEEN 0 AND 6 ORDER BY data_hora ASC`;
    try {
      connect.query(query, diaInicio, (err, results) => {
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Erro Interno de Servidor" });
        }
        return res
          .status(200)
          .json({ message: "Busca concluida:", eventos: results });
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Erro Interno de Servidor" });
    }
  }
};
