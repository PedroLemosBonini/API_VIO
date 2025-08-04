const connect = require("../db/connect");

module.exports = class ingressoController {
  // criação de um ingresso
  static async createIngresso(req, res) {
    const { preco, tipo, fk_id_evento } = req.body;

    // validação genérica de todos os atributos
    if (!preco || !tipo || !fk_id_evento) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    } else if (isNaN(preco)) {
      return res.status(400).json({
        error: "Preço inválido.",
      });
    } else if (!preco.includes(".")) {
      return res.status(400).json({ error: "preco inválido. Deve conter ." });
    }

    const [parteInteira, parteDecimal] = preco.split(".");
    if (parteInteira && parteDecimal.length != 2) {
      return res.status(400).json({
        error:
          "Preço inválido, o preço deve ser escrito com duas casas decimais",
      });
    } else if (preco < 0) {
      return res.status(400).json({
        error: "Preço inválido.",
      });
    } else if (tipo !== "Vip" && tipo !== "Pista") {
      // Corrigido aqui
      return res.status(400).json({
        error: 'Digite "Vip" ou "Pista" como tipo de ingresso.',
      });
    }
    const query = `insert into ingresso (preco, tipo, fk_id_evento) values (?, ?, ?)`; //placeholder, transiçao entre os dados que chegam
    const values = [preco, tipo, fk_id_evento];
    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(400).json({ error: "Erro ao criar o ingresso!" });
        }
        return res
          .status(201)
          .json({ message: "Ingresso criado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao executar consulta");
      return res.status(500).json({ erro: "Erro interno do servidor" });
    }
  } //fechamento do create

  // Visualizar todos os ingressos
  static async getAllIngressos(req, res) {
    const query = `select * from ingresso`;
    try {
      connect.query(query, (err, results) => {
        if (err) {
          //err é do banco de dados
          console.log(err);
          return res.status(500).json({ error: "Erro ao buscar ingressos" });
        }
        return res
          .status(200)
          .json({ message: "Listando todos os ingressos", ingressos: results });
      });
    } catch (error) {
      //error é do js
      console.log("Erro ao executar a query:", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  } //fim do get

  static async getByIdEvento(req, res) {
    const eventoId = req.params.id;

    const query = `
      SELECT 
        ingresso.id_ingresso, 
        ingresso.preco, 
        ingresso.tipo, 
        ingresso.fk_id_evento, 
        evento.nome AS nome_evento
      FROM ingresso
      JOIN evento ON ingresso.fk_id_evento = evento.id_evento
      WHERE evento.id_evento = ?;
    `;

    try {
      connect.query(query, [eventoId], (err, results) => {
        if (err) {
          console.error("Erro ao buscar ingressos por evento:", err);
          return res
            .status(500)
            .json({ error: "Erro ao buscar ingressos do evento" });
        }

        res.status(200).json({
          message: "Ingressos do evento obtidos com sucesso",
          ingressos: results,
        });
      });
    } catch (error) {
      console.error("Erro ao executar a consulta:", error);
      res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  //update de um evento
  static async updateIngresso(req, res) {
    const { id_ingresso, preco, tipo, fk_id_evento } = req.body;

    // validação genérica de todos os atributos
    if (!id_ingresso || !preco || !tipo || !fk_id_evento) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    }
    const [parteInteira, parteDecimal] = preco.split(".");
    if (parteInteira && parteDecimal.length != 2) {
      return res.status(400).json({
        error:
          "Preço inválido, o preço deve ser escrito com duas casas decimais",
      });
    } else if (isNaN(preco)) {
      return res.status(400).json({
        error: "Preço inválido.",
      });
    } else if (tipo !== "Vip" && tipo !== "Pista") {
      return res.status(400).json({
        error: 'Digite "Vip" ou "Pista" como tipo de ingresso.',
      });
    }

    const query = `update ingresso set preco=? , tipo=?, fk_id_evento=? where id_ingresso=?`; //placeholder, transiçao entre os dados que chegam
    const values = [preco, tipo, fk_id_evento, id_ingresso];
    try {
      connect.query(query, values, (err, results) => {
        console.log("Resultados:", results);
        if (err) {
          console.log(err);
          return res
            .status(400)
            .json({ error: "Erro ao atualizar o ingresso!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Ingresso não encontrado" });
        }
        return res
          .status(200)
          .json({ message: "Ingresso atualizado com sucesso!" });
      });
    } catch (error) {
      return res.status(500).json({ erro: "Erro interno do servidor" });
    }
  } //fim do update

  static async deleteIngresso(req, res) {
    const IdIngresso = req.params.id; //é o mesmo que passo nas rotas
    const query = `delete from ingresso where id_ingresso=?`;

    try {
      connect.query(query, IdIngresso, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao excluir o ingresso!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "ingresso não encontrado!" });
        }
        return res
          .status(200)
          .json({ message: "ingresso excluído com sucesso!" });
      });
    } catch (error) {
      if (error) {
        console.log("Erro ao executar a consulta", error);
        return res.status(500).json({ error: "Erro interno do servidor" });
      }
    }
  }
};
