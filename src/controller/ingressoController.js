const connect = require("../db/connect");

module.exports = class ingressoController {
  // Criação de um ingresso
  static async createIngresso(req, res) {
    const { preco, tipo, fk_id_evento } = req.body;

    // Validação genérica de todos
    if (!preco || !tipo || !fk_id_evento) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }

    const query = `insert into ingresso (preco, tipo, fk_id_evento) values(?, ?, ?)`;

    const values = [preco, tipo, fk_id_evento];

    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao criar o ingresso!" });
        }

        return res.status(201).json({ message: "ingresso criado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao executar query: ", error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }

  // Visualizar todos os ingressos
  static async getAllIngressos(req, res) {
    const query = `select * from ingresso`;

    try {
      connect.query(query, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(400).json("Erro ao obter ingressos!");
        }
        return res
          .status(200)
          .json({ message: "ingressos listados com sucesso:", events: results });
      });
    } catch (error) {
      console.log("Erro ao executar a query", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  static async updateIngresso(req, res) {
    const { id_ingresso, preco, tipo, fk_id_evento } =
      req.body;

    // Validação genérica de todos
    if (
      !id_ingresso ||
      !preco ||
      !tipo ||
      !fk_id_evento
    ) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }

    const query = `update ingresso set preco=?, tipo=?, fk_id_evento=? where id_ingresso=?`;

    const values = [
      preco,
      tipo,
      fk_id_evento,
      id_ingresso,
    ];

    try {
      connect.query(query, values, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao atualizar o ingresso!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "ingresso não encontrado" });
        }

        return res
          .status(200)
          .json({ message: "ingresso atualizado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao consultar consulta: ", error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }

  static async deleteIngresso(req, res) {
    const ingressoId = req.params.id;
    const query = `DELETE FROM ingresso where id_ingresso = ?`
    const values = [ingressoId];

    try {
      connect.query(query, values, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(400).json({ error: "Erro ao deletar ingresso!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "ingresso não encontrado!" });
        }
        return res
          .status(200)
          .json({ message: "ingresso deletado com sucesso!" });
      });
    } catch {
      console.log(error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }
};
